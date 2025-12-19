/// Auth feature error codes
abstract class AuthErrorCodes {
  static const userNotVerified = 'USER_NOT_VERIFIED';
  static const invalidCredentials = 'INVALID_CREDENTIALS';
  static const invalidOtp = 'INVALID_OTP';
  static const otpExpired = 'OTP_EXPIRED';
  static const emailExists = 'EMAIL_EXISTS';
  static const phoneExists = 'PHONE_EXISTS';
  static const accountSuspended = 'ACCOUNT_SUSPENDED';
  static const accountDeleted = 'ACCOUNT_DELETED';
}
