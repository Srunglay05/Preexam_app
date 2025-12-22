const functions = require("firebase-functions");
const admin = require("firebase-admin");
const sgMail = require("@sendgrid/mail");

admin.initializeApp();
sgMail.setApiKey(functions.config().sendgrid.key);

exports.sendEmailToAllUsers = functions.https.onRequest(async (req, res) => {
  try {
    // Get all users from Firestore
    const snapshot = await admin.firestore().collection("users").get();

    const emails = snapshot.docs
      .map(doc => doc.data().email)
      .filter(email => email);

    if (emails.length === 0) {
      return res.status(400).send("No users found");
    }

    // Send email to all users
    await sgMail.sendMultiple({
      to: emails,
      from: "noreply@prexam.com", // must be verified in SendGrid
      subject: "Prexam Announcement",
      text: "Hello everyone 👋 This email is sent to all users!"
    });

    res.send("Email sent to all users ✅");
  } catch (error) {
    console.error(error);
    res.status(500).send("Error sending email ❌");
  }
});
