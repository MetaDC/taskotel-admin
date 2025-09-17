/**
 * Taskotel Super Admin Cloud Functions
 * 
 * Functions for managing Super Admin operations:
 * - createClientAccount: Creates a new client with authentication
 * - deleteClientUser: Removes client and all associated data
 * - paymentWebhook: Handles Stripe payment webhooks
 * - generateMonthlyReport: Creates monthly analytics reports
 */

const {onRequest, onCall} = require("firebase-functions/v2/https");
const {onDocumentCreated, onDocumentUpdated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const bcrypt = require("bcryptjs");
const moment = require("moment");
const logger = require("firebase-functions/logger");

// Initialize Firebase Admin
admin.initializeApp();
const db = admin.firestore();
const auth = admin.auth();

/**
 * Creates a new client account with authentication
 * Called by Super Admin from the dashboard
 */
exports.createClientAccount = onCall(async (request) => {
  try {
    const {email, password, clientName, companyName, phone, isTrialAccount = true} = request.data;
    
    // Validate required fields
    if (!email || !password || !clientName) {
      throw new Error("Missing required fields: email, password, clientName");
    }

    // Create Firebase Auth user
    const userRecord = await auth.createUser({
      email: email,
      password: password,
      displayName: clientName,
      disabled: false,
    });

    // Set custom claims for Client Admin role
    await auth.setCustomUserClaims(userRecord.uid, {
      role: "CA", // Client Admin
      isActive: true,
    });

    // Create client document in Firestore
    const clientData = {
      docId: userRecord.uid,
      name: clientName,
      email: email,
      companyName: companyName || "",
      phone: phone || "",
      status: isTrialAccount ? "trial" : "active",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdBy: request.auth?.uid || "system",
      trialExpiresAt: isTrialAccount ? 
        admin.firestore.Timestamp.fromDate(moment().add(14, 'days').toDate()) : null,
      totalHotels: 0,
      totalRooms: 0,
      isActive: true,
    };

    await db.collection("clients").doc(userRecord.uid).set(clientData);

    logger.info(`Client account created successfully: ${email}`, {
      clientId: userRecord.uid,
      email: email,
      isTrialAccount: isTrialAccount,
    });

    return {
      success: true,
      clientId: userRecord.uid,
      message: "Client account created successfully",
    };

  } catch (error) {
    logger.error("Error creating client account:", error);
    throw new Error(`Failed to create client account: ${error.message}`);
  }
});

/**
 * Deletes a client and all associated data
 * Called by Super Admin - cascades to hotels, users, tasks, etc.
 */
exports.deleteClientUser = onCall(async (request) => {
  try {
    const {clientId} = request.data;
    
    if (!clientId) {
      throw new Error("Missing required field: clientId");
    }

    // Start batch operations
    const batch = db.batch();

    // Get all hotels for this client
    const hotelsSnapshot = await db.collection("hotels")
      .where("clientId", "==", clientId)
      .get();

    const hotelIds = [];
    hotelsSnapshot.forEach(doc => {
      hotelIds.push(doc.id);
      batch.delete(doc.ref);
    });

    // Delete all users associated with this client
    const usersSnapshot = await db.collection("users")
      .where("clientId", "==", clientId)
      .get();

    const userIds = [];
    usersSnapshot.forEach(doc => {
      userIds.push(doc.id);
      batch.delete(doc.ref);
    });

    // Delete all transactions for this client
    const transactionsSnapshot = await db.collection("transactions")
      .where("clientId", "==", clientId)
      .get();

    transactionsSnapshot.forEach(doc => {
      batch.delete(doc.ref);
    });

    // Delete client document
    batch.delete(db.collection("clients").doc(clientId));

    // Execute batch delete
    await batch.commit();

    // Delete Firebase Auth users
    const deleteAuthPromises = userIds.map(async (userId) => {
      try {
        await auth.deleteUser(userId);
      } catch (error) {
        logger.warn(`Failed to delete auth user ${userId}:`, error);
      }
    });

    await Promise.allSettled(deleteAuthPromises);

    logger.info(`Client and associated data deleted successfully: ${clientId}`, {
      clientId: clientId,
      deletedHotels: hotelIds.length,
      deletedUsers: userIds.length,
    });

    return {
      success: true,
      message: "Client and all associated data deleted successfully",
      deletedHotels: hotelIds.length,
      deletedUsers: userIds.length,
    };

  } catch (error) {
    logger.error("Error deleting client:", error);
    throw new Error(`Failed to delete client: ${error.message}`);
  }
});

/**
 * Handles Stripe payment webhooks
 * Updates subscription status based on payment events
 */
exports.paymentWebhook = onRequest(async (request, response) => {
  try {
    const event = request.body;
    
    logger.info("Received payment webhook:", {
      type: event.type,
      id: event.id,
    });

    switch (event.type) {
      case "payment_intent.succeeded":
        await handlePaymentSuccess(event.data.object);
        break;
      
      case "payment_intent.payment_failed":
        await handlePaymentFailed(event.data.object);
        break;
      
      case "invoice.payment_succeeded":
        await handleSubscriptionPayment(event.data.object);
        break;
      
      case "customer.subscription.deleted":
        await handleSubscriptionCanceled(event.data.object);
        break;
      
      default:
        logger.info(`Unhandled event type: ${event.type}`);
    }

    response.json({received: true});

  } catch (error) {
    logger.error("Error processing payment webhook:", error);
    response.status(400).send(`Webhook error: ${error.message}`);
  }
});

/**
 * Generates monthly analytics report
 * Triggered on the 1st of each month or manually by Super Admin
 */
exports.generateMonthlyReport = onCall(async (request) => {
  try {
    const {month, year} = request.data;
    const reportMonth = month || moment().subtract(1, 'month').month() + 1;
    const reportYear = year || moment().subtract(1, 'month').year();
    
    logger.info(`Generating monthly report for ${reportMonth}/${reportYear}`);

    // Calculate date ranges
    const startDate = moment(`${reportYear}-${reportMonth}-01`).startOf('month');
    const endDate = moment(startDate).endOf('month');

    // Gather analytics data
    const analytics = await gatherMonthlyAnalytics(startDate, endDate);
    
    // Create report document
    const reportData = {
      month: reportMonth,
      year: reportYear,
      generatedAt: admin.firestore.FieldValue.serverTimestamp(),
      generatedBy: request.auth?.uid || "system",
      ...analytics,
    };

    const reportId = `${reportYear}-${String(reportMonth).padStart(2, '0')}`;
    await db.collection("monthly_reports").doc(reportId).set(reportData);

    logger.info(`Monthly report generated successfully: ${reportId}`);

    return {
      success: true,
      reportId: reportId,
      message: "Monthly report generated successfully",
      data: analytics,
    };

  } catch (error) {
    logger.error("Error generating monthly report:", error);
    throw new Error(`Failed to generate monthly report: ${error.message}`);
  }
});

/**
 * Auto-update client status based on hotel subscriptions
 * Triggered when hotel subscription status changes
 */
exports.updateClientStatus = onDocumentUpdated("hotels/{hotelId}", async (event) => {
  try {
    const hotelData = event.data.after.data();
    const clientId = hotelData.clientId;

    if (!clientId) return;

    // Get all hotels for this client
    const hotelsSnapshot = await db.collection("hotels")
      .where("clientId", "==", clientId)
      .get();

    let activeHotels = 0;
    let totalHotels = hotelsSnapshot.size;
    let totalRooms = 0;

    hotelsSnapshot.forEach(doc => {
      const hotel = doc.data();
      totalRooms += hotel.roomCount || 0;
      
      if (hotel.subscriptionStatus === "active") {
        activeHotels++;
      }
    });

    // Determine client status
    let clientStatus = "churned";
    if (activeHotels > 0) {
      clientStatus = "active";
    } else if (totalHotels > 0) {
      // Check if any hotels are in trial
      const trialHotels = hotelsSnapshot.docs.filter(doc => 
        doc.data().subscriptionStatus === "trial"
      );
      if (trialHotels.length > 0) {
        clientStatus = "trial";
      }
    }

    // Update client document
    await db.collection("clients").doc(clientId).update({
      status: clientStatus,
      totalHotels: totalHotels,
      totalRooms: totalRooms,
      activeHotels: activeHotels,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`Client status updated: ${clientId} -> ${clientStatus}`);

  } catch (error) {
    logger.error("Error updating client status:", error);
  }
});

// Helper Functions

async function handlePaymentSuccess(paymentIntent) {
  // Update transaction status to success
  const transactionSnapshot = await db.collection("transactions")
    .where("paymentIntentId", "==", paymentIntent.id)
    .get();

  if (!transactionSnapshot.empty) {
    const transactionDoc = transactionSnapshot.docs[0];
    await transactionDoc.ref.update({
      status: "success",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
}

async function handlePaymentFailed(paymentIntent) {
  // Update transaction status to failed
  const transactionSnapshot = await db.collection("transactions")
    .where("paymentIntentId", "==", paymentIntent.id)
    .get();

  if (!transactionSnapshot.empty) {
    const transactionDoc = transactionSnapshot.docs[0];
    await transactionDoc.ref.update({
      status: "failed",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
}

async function handleSubscriptionPayment(invoice) {
  // Handle recurring subscription payments
  logger.info("Subscription payment received:", invoice.id);
}

async function handleSubscriptionCanceled(subscription) {
  // Handle subscription cancellation
  logger.info("Subscription canceled:", subscription.id);
}

async function gatherMonthlyAnalytics(startDate, endDate) {
  const startTimestamp = admin.firestore.Timestamp.fromDate(startDate.toDate());
  const endTimestamp = admin.firestore.Timestamp.fromDate(endDate.toDate());

  // Get clients data
  const clientsSnapshot = await db.collection("clients").get();
  const totalClients = clientsSnapshot.size;
  
  let activeClients = 0;
  let trialClients = 0;
  let churnedClients = 0;

  clientsSnapshot.forEach(doc => {
    const client = doc.data();
    switch (client.status) {
      case "active": activeClients++; break;
      case "trial": trialClients++; break;
      case "churned": churnedClients++; break;
    }
  });

  // Get hotels data
  const hotelsSnapshot = await db.collection("hotels").get();
  const totalHotels = hotelsSnapshot.size;
  
  let totalRooms = 0;
  let activeSubscriptions = 0;

  hotelsSnapshot.forEach(doc => {
    const hotel = doc.data();
    totalRooms += hotel.roomCount || 0;
    if (hotel.subscriptionStatus === "active") {
      activeSubscriptions++;
    }
  });

  // Get transactions for the month
  const transactionsSnapshot = await db.collection("transactions")
    .where("createdAt", ">=", startTimestamp)
    .where("createdAt", "<=", endTimestamp)
    .where("status", "==", "success")
    .get();

  let monthlyRevenue = 0;
  transactionsSnapshot.forEach(doc => {
    const transaction = doc.data();
    monthlyRevenue += transaction.amount || 0;
  });

  // Get subscription plans data
  const plansSnapshot = await db.collection("subscription_plans").get();
  const planStats = {};
  
  plansSnapshot.forEach(doc => {
    const plan = doc.data();
    planStats[plan.name] = {
      totalSubscriptions: 0,
      revenue: 0,
    };
  });

  // Calculate plan-specific metrics
  hotelsSnapshot.forEach(doc => {
    const hotel = doc.data();
    if (hotel.subscriptionPlan && planStats[hotel.subscriptionPlan]) {
      if (hotel.subscriptionStatus === "active") {
        planStats[hotel.subscriptionPlan].totalSubscriptions++;
      }
    }
  });

  return {
    totalClients,
    activeClients,
    trialClients,
    churnedClients,
    totalHotels,
    activeSubscriptions,
    totalRooms,
    monthlyRevenue,
    planStats,
    averageRevenuePerHotel: totalHotels > 0 ? monthlyRevenue / totalHotels : 0,
  };
}
