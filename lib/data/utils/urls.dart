class Urls {
  static const _baseUrl = "http://35.73.30.144:2005/api/v1";

  static const login = "$_baseUrl/Login";
  static const register = "$_baseUrl/Registration";
  static const updateProfile = "$_baseUrl/ProfileUpdate";
  static const profileDetails = "$_baseUrl/ProfileDetails";
  static String recoverVerifyEmail(String email) =>
      "$_baseUrl/RecoverVerifyEmail/$email";
}
