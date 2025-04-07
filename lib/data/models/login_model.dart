import 'package:task_manager/data/models/user_model.dart';

class LoginModel {
  final String status;
  final String token;
  final UserModel? userData;

  LoginModel({
    required this.status,
    required this.token,
    required this.userData,
  });

  factory LoginModel.fromJson(Map<String, dynamic> jsonData) {
    return LoginModel(
      status: jsonData['status'] ?? "",
      token: jsonData['token'] ?? "",
      userData: UserModel.fromJson(jsonData['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    data['data'] = userData?.toJson();
    return data;
  }
}
