// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/SimpleScreens/exercisesScreen/exerciseViews/customExerciseScreen.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:recase/recase.dart';

class ExerciseWidget extends HookConsumerWidget {
  final LocalExercise exercise;

  const ExerciseWidget({required this.exercise});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Para presionar
    return Container(
      width: 340,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 35, 38, 47),
            Colors.accents[exercise.color],
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
            color: Colors.accents[exercise.color],
            blurRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      //!Row principal
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        //! Esfera Circular
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.accents[exercise.color],
                    blurRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: exercise.complete
                  ? const Icon(
                      Ionicons.sparkles_outline,
                      color: Colors.black,
                      size: 30,
                    )
                  : const Icon(
                      Ionicons.snow_outline,
                      color: Colors.lightBlue,
                      size: 30,
                    )),
        ),

        //?Contenido Derecho
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: Text(exercise.name.titleCase,
                      style: GoogleFonts.karla(
                          fontSize: 28, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              customTable("Sets", exercise.sets.toString()),
              customTable("Reps", exercise.reps.toString()),
              customTable("Lb", exercise.weight.toString()),
            ],
          ),
        )
      ]),
    );
  }

  Padding customTable(string1, string2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        Expanded(
          child: Center(
              child: Text(
            string1,
            style: GoogleFonts.karla(fontSize: 20),
          )),
        ),
        const Icon(Ionicons.arrow_forward_sharp),
        Expanded(
          child: Center(
            child: Text(
              string2,
              style: GoogleFonts.karla(fontSize: 20),
            ),
          ),
        ),
      ]),
    );
  }
}
