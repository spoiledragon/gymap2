// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/SimpleScreens/exercisesScreen/exerciseViews/indexeExerciseViews.dart';

import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SingleExerciseScreen extends ConsumerWidget {
  final LocalExercise exercise;

  const SingleExerciseScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: GradientText(
            exercise.name,
            style:
                GoogleFonts.karla(fontSize: 28.0, fontWeight: FontWeight.bold),
            colors: [
              const Color.fromARGB(255, 0, 153, 255),
              Colors.primaries[exercise.color]
            ],
          ),
        ),
        //un par de paginas indexadas para desplegar las estadisticas y el contenido del ejercicio
//se le pasa el ejercicio como parametro
        body: IndexedExercisesScreens(
          exercise: exercise,
        ));
  }
}
