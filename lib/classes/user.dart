import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

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
      required this.weight,
      required this.restTime,
      required this.gymBro});

  final String username;
  String nickname;
  String password;
  String gymBro;
  String family;
  String gender;
  String profilePicture;
  int weight;
  int age;
  int restTime;

  factory User.fromJson(Map<String, dynamic> json) => User(
      username: json['username'],
      nickname: json['nickname'],
      password: json['password'],
      family: json['family'],
      gender: json['gender'],
      age: json['age'],
      weight: json['weight'],
      profilePicture: json['profilePicture'],
      restTime: json["restTime"],
      gymBro: json["gymBro"]);

  Map<String, dynamic> toJson() => {
        "username": username,
        "nickname": nickname,
        "password": password,
        "family": family,
        "gender": gender,
        "age": age,
        "profilePicture": profilePicture,
        "weight": weight,
        "restTime": restTime,
        "gymBro": gymBro
      };

  void updateData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    //convertimos el usuarios en un string
    var jsonstring = jsonEncode(user);
    //Guardamos en shared Preferences los datos
    await prefs.setString('user', jsonstring);
    log(jsonstring);
  }
}
