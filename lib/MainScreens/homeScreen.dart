// ignore_for_file: file_names, use_key_in_widget_constructors

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/MainScreens/exerciseScreen.dart';
import 'package:gymap/SimpleScreens/groupListScreen.dart';
import 'package:gymap/States/states.dart';

import 'package:gymap/classes/exercise.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:ionicons/ionicons.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Providers
    final String user = ref.read(userProvider.state).state.nickname;
    final List<Exercises> ejercicios = ref.watch(ExerciseProvider);
    //Funciones

    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Morning';
      }
      if (hour < 17) {
        return 'Afternoon';
      }
      return 'Evening';
    }

    gotoExercisePage() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ExercisePage()));
    }

    Widget goToExercisesBtn() {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(50, 35, 38, 47),
                Color.fromARGB(255, 35, 38, 47)
              ],
              stops: [0, 1],
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => gotoExercisePage(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(Ionicons.barbell),
                      ),
                    ),
                    Text(
                      "Exercises",
                      style: GoogleFonts.karla(
                          fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    const Icon(Ionicons.arrow_forward)
                  ]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      //APPBAR
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height / 6), // Set this height
        child: Stack(
          fit: StackFit.expand,
          children: [
            //IMAGEN
            Image.asset('lib/Assets/images/banner.gif', fit: BoxFit.cover),
            ClipRRect(
              //FILTRO
              // Clip it cleanly.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.1),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Good ${greeting()}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 152, 152, 152),
                                fontSize: 28,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            user.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
// !WIDGETS DEBAJO DEL APPBAR
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(
          height: 15,
        ),
        textToShow("My Exercises"),
        const SizedBox(
          height: 15,
        ),
        goToExercisesBtn(),
        const SizedBox(
          height: 30,
        ),
        textToShow("Other Exercises"),
        const SizedBox(
          height: 30,
        ),
        mainExercises(ejercicios),
      ]),
    );
  }

  Widget textToShow(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          texto,
          style: GoogleFonts.karla(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget squareButton(Exercises ejercicioLocal, context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 35, 38, 47),
            Colors.accents[ejercicioLocal.color],
          ],
          stops: const [1, 0],
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.accents[ejercicioLocal.color],
            blurRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 160,
      height: 160,
      child: MaterialButton(
        child: Text(
          ejercicioLocal.group,
          style: GoogleFonts.karla(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => GroupListScreen(
                    ejercicio: ejercicioLocal,
                  ))));
        },
      ),
    );
  }

  Widget mainExercises(List<Exercises> ejercicios) {
    return Expanded(
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: ejercicios.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child:
                //le pasamos al widget grafico todo el ejercicio que se hace
                squareButton(ejercicios[index], context),
          );
        }),
      ),
    );
  }
}
