import 'package:flutter/cupertino.dart';
import 'package:gymap/classes/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//En donde esta el index
final homeindexProvider = StateProvider((ref) => 0);
//Color Mode
final isDarkMode = StateProvider((ref) => true);

//! Providers Temporales para agregar en el modal
final nameAddProvider = StateProvider((ref) => "");
final typeAddProvider = StateProvider((ref) => "");
final groupAddProvider = StateProvider((ref) => "Chest");
final weightAddProvider = StateProvider<int>((ref) => 1);
final setsAddProvider = StateProvider<int>((ref) => 1);
final repsAddProvider = StateProvider<int>((ref) => 1);
final colorAddProvider = StateProvider<int>((ref) => 1);
final selectedProvider = StateProvider<List<bool>>(
  (ref) => List.filled(3, false),
);

//!Register Page
final userRegisterProvider = StateProvider<String>((ref) => "");
final passwordRegisterProvider = StateProvider<String>((ref) => "");
final mailRegisterProvider = StateProvider<String>((ref) => "");
final ageRegisterProvider = StateProvider<int>((ref) => 25);
final weightRegisterProvider = StateProvider<int>((ref) => 50);
final genderRegisterProvider = StateProvider<String>((ref) => "Female");
final familyegisterProvider = StateProvider<String>((ref) => "");

//!! USER
final userProvider = StateProvider<User>((ref) {
  return User(
      username: "",
      nickname: "",
      password: "",
      family: "",
      gender: "",
      profilePicture: "",
      age: 0,
      weight: 0);
});

//Reloj
final timeGlobalProvider = StateProvider<int>((ref) {
  return 120;
});
final maingymBroProvider = StateProvider<String>((ref) => "");
//! Para el index del registro
final controllerRegisterProvider =
    StateProvider<PageController>(((ref) => PageController()));
final controller2RegisterProvider =
    StateProvider<PageController>(((ref) => PageController()));
//!Para agregar ejercicios
final controllerAddProvider =
    StateProvider<PageController>(((ref) => PageController()));
