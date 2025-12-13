// utils/email.js
async function sendOTPEmail(email, otp) {
  // For testing we'll just log. Replace with nodemailer/SendGrid in production.
  console.log(`➡️ Sending OTP to ${email}: ${otp}`);
  // return resolved promise
  return Promise.resolve();
}

module.exports = { sendOTPEmail };
