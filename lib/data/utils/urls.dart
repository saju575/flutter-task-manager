class Urls {
  static const _baseUrl = "http://35.73.30.144:2005/api/v1";

  static const login = "$_baseUrl/Login";
  static const register = "$_baseUrl/Registration";
  static const updateProfile = "$_baseUrl/ProfileUpdate";
  static const profileDetails = "$_baseUrl/ProfileDetails";
  static const createTask = '$_baseUrl/createTask';
  static const taskStatusSummery = '$_baseUrl/taskStatusCount';
  static String resetRecoverPassword = "$_baseUrl/RecoverResetPassword";

  static String recoverVerifyEmail(String email) =>
      "$_baseUrl/RecoverVerifyEmail/$email";

  static String recoverVerifyOtp(String email, String pin) =>
      "$_baseUrl/RecoverVerifyOtp/$email/$pin";

  static String getLaskListByStatus(String status) =>
      "$_baseUrl/listTaskByStatus/$status";
  static String deleteTask(String taskId) => "$_baseUrl/deleteTask/$taskId";
  static String updateTaskStatus(String taskId, String status) =>
      "$_baseUrl/updateTaskStatus/$taskId/$status";
}
