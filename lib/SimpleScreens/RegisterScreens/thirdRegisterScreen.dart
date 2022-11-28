// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/States/states.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../classes/user.dart';

class ThirdScreen extends ConsumerStatefulWidget {
  const ThirdScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends ConsumerState<ThirdScreen> {
  void saveUser() async {
    final user = User(
        username: ref.read(userRegisterProvider),
        nickname: ref.read(userRegisterProvider),
        password: ref.read(passwordRegisterProvider),
        family: ref.read(familyegisterProvider),
        gender: ref.read(genderRegisterProvider),
        profilePicture: "https://pbs.twimg.com/media/Fg1UFFZWAAI1vA7?format=jpg&name=large",
        age: ref.read(ageRegisterProvider),
        weight: ref.read(weightRegisterProvider));

    final prefs = await SharedPreferences.getInstance();
    //convertimos el usuarios en un string
    var jsonstring = jsonEncode(user);
    //Guardaeremos que si hay alguien registrado
    await prefs.setBool('isLoged', true);
    //lo guardamos en shader preferences
    await prefs.setString('user', jsonstring);
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      saveUser();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GradientText(
      "Registrado con exito",
      style: GoogleFonts.karla(fontSize: 32),
      colors: const [Colors.white, Colors.red, Colors.purple],
    ));
  }
}
