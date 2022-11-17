import 'dart:convert';

List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User(
      {required this.username,
      required this.nickname,
      required this.password,
      required this.family,
      required this.gender,
      required this.profilePicture,
      required this.age,
      required this.weight});

  String? username;
  String? nickname;
  String? password;
  String? family;
  String? gender;
  String? profilePicture;
  int? weight;
  int? age;

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        nickname: json['nickname'],
        password: json['password'],
        family: json['family'],
        gender: json['gender'],
        age: json['age'],
        weight: json['weigh'],
        profilePicture: json['profilePicture'],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "nickname": nickname,
        "password": password,
        "family": family,
        "gender": gender,
        "age": age,
        "profilePicture": profilePicture,
      };
}
