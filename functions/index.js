const { onCall } = require("firebase-functions/v2/https");
const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const { FieldValue } = require("firebase-admin/firestore");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");

admin.initializeApp();
const db = admin.firestore();
const auth = admin.auth();
const messaging = admin.messaging();

var transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465,
  secure: true,
  auth: {
    user: "teammetadc@gmail.com",
    pass: "skfbnyjbyotmfvmw",
    // pass: 'zniorhjmhmatlzfd'
  },
});

// AUTH FUNCTIONS
exports.createUser = onCall(async (request) => {
  // let data = req.body;
  try {
    if (!request.auth)
      return { status: "error", code: 401, message: "Not signed in" };
    let user = await auth.createUser({
      email: request.data.email,
      password: request.data.password,
    });

    try {
      let dbUser = await db.collection("clients").doc(user.uid).create({
        name: request.data.name,
        email: request.data.email,
        phone: request.data.phone,
        createdAt: request.data.createdAt,
        status: request.data.status,
        lastPaymentExpiry: null,
        updatedAt: request.data.updatedAt,
        lastLogin: null,
        totalHotels: request.data.totalHotels,
        totalRevenue: request.data.totalRevenue,
        isDeleted: false,
      });
      console.log("User Data saved Successfully");
      return { success: true, msg: dbUser, docId: user.uid };
    } catch (error) {
      console.log(
        `Failed to create user doc, need to delete this user again ${error}!`
      );
      await auth.deleteUser(user.uid);
      console.log(`User deleted successfully ${error} !`);
      return { success: false, msg: error };
    }
  } catch (error) {
    console.log("Error creating new user:", error);
    return {
      success: false,
      msg: error["errorInfo"]["message"],
      code: error["errorInfo"]["code"],
    };
  }
});

exports.deleteUser = onCall(async (request) => {
  try {
    // await auth.deleteUser(request.data.userId);
    await db.collection("clients").doc(request.data.userId).update({
      isDeleted: true,
    });
    return { success: true, msg: "User deleted successfully" };
  } catch (error) {
    return { success: false, msg: error };
  }
});

// NOTIFICATION FUNCTIONS

exports.sendNotification = onDocumentCreated(
  "notifications/{docId}",
  async (event) => {
    const snapshot = event.data;
    const doc = snapshot?.data();

    if (!doc) {
      console.error("No data in notification document");
      return;
    }

    const notifyType = doc.notifyType || "general";
    const title = doc.title || "New Notification";
    const messageBody = doc.message || "You have a new update";

    const extraData = doc.data || {};

    const message = {
      notification: {
        title,
        body: messageBody,
      },
      data: {
        type: notifyType,
        ...Object.fromEntries(
          Object.entries(extraData).map(([key, value]) => [
            key,
            typeof value === "boolean" || typeof value === "number"
              ? String(value)
              : value ?? "",
          ])
        ),
      },
    };

    if (doc.topic) {
      message.topic = doc.topic;
    } else if (doc.token) {
      message.token = doc.token;
    } else {
      console.error("No token or topic provided");
      return;
    }

    try {
      const response = await admin.messaging().send(message);
      console.log(`${notifyType} notification sent:`, response);
    } catch (error) {
      console.error(`Error sending ${notifyType} notification:`, error);
    }
  }
);
