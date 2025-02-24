class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registrationUrl = '$_baseUrl/registration';
  static const String loginUrl = '$_baseUrl/login';
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String taskCountByStatusUrl = '$_baseUrl/taskStatusCount';

  static String taskListByStatusUrl(String status) =>
      '$_baseUrl/listTaskByStatus/$status';

  static String deleteTaskUrl(String id) => '$_baseUrl/deleteTask/$id';

  static String taskStatusUpdateUrl(String taskId, String newStatus, context) =>
      '$_baseUrl/updateTaskStatus/$taskId/$newStatus';

  static String recoveryVerifyEmailUrl(String email) =>
      '$_baseUrl/RecoverVerifyEmail/$email';

  static String otpVerificationUrl(String email, String otp) =>
      '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static const String recoverPasswordUrl = '$_baseUrl/RecoverResetPass';
  static const String updateProfile = '$_baseUrl/profileUpdate';
}
