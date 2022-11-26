// ignore_for_file: file_names, use_build_context_synchronously, body_might_complete_normally_nullable

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:gymap/MainScreens/homeScreen.dart';
import 'package:gymap/MainScreens/loginScreen.dart';
import 'package:gymap/States/states.dart';
import 'package:gymap/classes/exercise.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:gymap/classes/user.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> readJson() async {
      final String response =
          await rootBundle.loadString('lib/Assets/jsons/exercises.json');

      final data = await json.decode(response);

      for (var exe in data) {
        Exercises x = Exercises.fromJson(exe);
        ref.read(exercisesProvider.notifier).addExercise(x);
        //print(x.group);
      }
    }

    //!Funcion que trae de los shared preferences
    void getExercisesFromPreferences() async {
      //definimos los prefs
      final prefs = await SharedPreferences.getInstance();
      //creamos una lista dinamica condeando el en el jsondata
      final List<dynamic> jsonData =
          jsonDecode(prefs.getString('Exercises') ?? '[]');
      //ya aqui tenemos los datos para ser almacenados en donde quieras
      for (int i = 0; i < jsonData.length; i++) {
        var exe = jsonData[i];
        LocalExercise x = LocalExercise.fromJson(exe);
        ref.read(localExerciseProvider.notifier).addExercise(x);
      }
    }

    void getDataAndGo() async {
      final prefs = await SharedPreferences.getInstance();
      final isLoged = prefs.getBool("isLoged") ?? false;
      if (!isLoged) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        //EN EL CASO DE QUE SI ESTE LOGEADO ENTRAMOS A ESTE CASO
        //LLAMAMOS A LAS PREFS COMO SIEMPRE
        final prefs = await SharedPreferences.getInstance();
        //LE DECIMOS QUE NOS CONSIGA EL STRING LLAMADO USER Y LO GUARDE EN EL DATO USERPREF
        final jsondata = jsonDecode(prefs.getString('user') ?? "");

        final user = User.fromJson(jsondata);
        ref.read(userProvider.state).state = user;

        //!Guardaremos al usuario en el provider

        //Cuando todo esta hecho ya solo cargamos el json
        readJson();
        getExercisesFromPreferences();
        //LO IMPRIMIMOS PARA VER QUE PEDO CON ESTO
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }

    useEffect(() {
      getDataAndGo();
    });

    return const Scaffold(
      body: Center(
        child: Text("MY APP"),
      ),
    );
  }
}
