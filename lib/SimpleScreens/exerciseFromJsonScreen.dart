// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/classes/exercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExercisesFromJsonScreen extends ConsumerWidget {
  final Exercise exercise;
  const ExercisesFromJsonScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: GradientText(
            exercise.title.toUpperCase(),
            style: GoogleFonts.karla(
                letterSpacing: 2, fontWeight: FontWeight.bold),
            colors: const [Colors.blue, Colors.purple, Colors.red],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            //imagen del ejercicio
            if (exercise.image != "")
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  exercise.image,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            //Informacion del ejercio
            Text(exercise.info),
          ]),
        ));
  }
}
