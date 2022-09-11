class UserModel {
   String? uid;

   String? fullName;

   int? phone;

   String? email;

   String? password;

  UserModel({this.uid, this.fullName, this.phone, this.email, this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      fullName: json["fullName"],
      phone: json["phone"],
      email: json["email"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "fullName": fullName,
      "phone": phone,
      "email": email,
      "password": password,
    };
  }
}
