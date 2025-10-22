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
  },
});

// AUTH FUNCTIONS
exports.createClient = onCall(async (request) => {
  try {
    if (!request.auth)
      return { status: "error", code: 401, message: "Not signed in" };

    // Create the user
    let user = await auth.createUser({
      email: request.data.email,
      password: request.data.password,
    });

    try {
      // Save user data to Firestore
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

      //save in user collection
      await db.collection("users").doc(user.uid).create({
        name: request.data.name,
        email: request.data.email,
        phone: request.data.phone,
        role: "client",
        hotelIds: [],
        departmentId: "",
        isActive: true,
        lastLogin: null,
        createdAt: request.data.createdAt,
        updatedAt: request.data.updatedAt,
      });

      console.log("User Data saved Successfully");

      // Send credentials email
      try {
        console.log("Sending credentials email");
        await sendCredentialsEmail(
          request.data.email,
          request.data.name,
          request.data.email,
          request.data.password
        );
        console.log("Credentials email sent successfully");
      } catch (emailError) {
        console.error("Failed to send credentials email:", emailError);
        // Don't fail the user creation if email fails
      }

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
exports.createUser = onCall(async (request) => {
  try {
    // if (!request.auth)
    //   return { status: "error", code: 401, message: "Not signed in" };
    console.log("Creating user:-" + request.data.email);
    // Create the user
    let user = await auth.createUser({
      email: request.data.email,
      password: request.data.password,
    });
    console.log("User created:-" + user.uid);

    try {
      console.log("Saving user data:-" + user.uid);
      //save in user collection
      await db.collection("users").doc(user.uid).create({
        name: request.data.name,
        email: request.data.email,
        phone: request.data.phone,
        role: request.data.role,
        hotelIds: request.data.hotelIds,
        departmentId: request.data.departmentId,
        isActive: true,
        lastLogin: null,
        createdAt: request.data.createdAt,
        updatedAt: request.data.updatedAt,
      });

      console.log("User Data saved Successfully:-" + user.uid);

      // Send credentials email
      try {
        console.log("Sending credentials email:-" + user.uid);
        await sendCredentialsEmail(
          request.data.email,
          request.data.name,
          request.data.email,
          request.data.password
        );
        console.log("Credentials email sent successfully:-" + user.uid);
      } catch (emailError) {
        console.error("Failed to send credentials email:", emailError);
        // Don't fail the user creation if email fails
      }

      return {
        success: true,
        msg: "User created successfully",
        docId: user.uid,
      };
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

// Function to send credentials email
async function sendCredentialsEmail(email, name, userEmail, password) {
  console.log("Sending credentials email to: ", email);
  const emailHtml = `
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body {
          font-family: Arial, sans-serif;
          line-height: 1.6;
          color: #333;
        }
        .container {
          max-width: 600px;
          margin: 0 auto;
          padding: 20px;
          background-color: #f9f9f9;
        }
        .header {
          background-color: #4a90e2;
          color: white;
          padding: 20px;
          text-align: center;
          border-radius: 5px 5px 0 0;
        }
        .content {
          background-color: white;
          padding: 30px;
          border-radius: 0 0 5px 5px;
        }
        .credentials {
          background-color: #f0f7ff;
          border-left: 4px solid #4a90e2;
          padding: 15px;
          margin: 20px 0;
        }
        .credential-item {
          margin: 10px 0;
        }
        .credential-label {
          font-weight: bold;
          color: #4a90e2;
        }
        .credential-value {
          color: #333;
          font-family: monospace;
          font-size: 14px;
        }
        .footer {
          text-align: center;
          margin-top: 20px;
          font-size: 12px;
          color: #666;
        }
        .button {
          display: inline-block;
          padding: 12px 24px;
          background-color: #4a90e2;
          color: white;
          text-decoration: none;
          border-radius: 5px;
          margin: 20px 0;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>Welcome to Taskotel!</h1>
        </div>
        <div class="content">
          <p>Hi ${name || "there"},</p>
          <p>Your account has been successfully created. Below are your login credentials:</p>
          
          <div class="credentials">
            <div class="credential-item">
              <span class="credential-label">Email:</span>
              <br>
              <span class="credential-value">${userEmail}</span>
            </div>
            <div class="credential-item">
              <span class="credential-label">Password:</span>
              <br>
              <span class="credential-value">${password}</span>
            </div>
          </div>
          
          <p><strong>Important:</strong> For security reasons, please change your password after your first login.</p>
          
          <center>
            <a href="https://yourapp.com/login" class="button">Login to Your Account</a>
          </center>
          
          <p>If you have any questions or need assistance, please don't hesitate to contact our support team.</p>
          
          <p>Best regards,<br>The Taskotel Team</p>
        </div>
        <div class="footer">
          <p>This is an automated email. Please do not reply to this message.</p>
          <p>&copy; ${new Date().getFullYear()} Taskotel. All rights reserved.</p>
        </div>
      </div>
    </body>
    </html>
  `;

  return sendEmailToUser(
    email,
    "Welcome to Taskotel - Your Login Credentials",
    emailHtml
  );
}

async function sendEmailToUser(to, subject, html) {
  try {
    const mailOptions = {
      from: {
        name: "Taskotel",
        address: "taskotel.ops@gmail.com",
      },
      to: to,
      subject: subject,
      html: html,
    };

    console.log(`Sending email to: ${to}`);

    return transporter.sendMail(mailOptions, (error, data) => {
      if (error) {
        console.error("Email sending error:", error);
        throw error;
      }
      console.log("Email sent successfully!");
      return data;
    });
  } catch (error) {
    console.error("Error in sendEmailToUser:", error);
    throw error;
  }
}

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
