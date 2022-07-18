class LoginModel {

  late String token;
  late String id;
  late String role;
  LoginModel(this.token, this.id,this.role);
  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    role = json['role'];
  }
}