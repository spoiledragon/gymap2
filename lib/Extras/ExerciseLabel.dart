// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
              boxShadow: [
                BoxShadow(
                  color: Colors.accents[exercise.color],
                  blurRadius: 0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
        //?Contenido Derecho
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: Text(exercise.name,
                      style: GoogleFonts.karla(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //! Primera Columna
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(exercise.type,
                        style: GoogleFonts.karla(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Text("${exercise.sets}x Sets",
                        style: GoogleFonts.karla(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              //? Sized Box
              const SizedBox(
                height: 10,
              ),
              //!Segunda Columna
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text("${exercise.weight} Lb",
                        style: GoogleFonts.karla(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Text("${exercise.reps} Reps",
                        style: GoogleFonts.karla(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
