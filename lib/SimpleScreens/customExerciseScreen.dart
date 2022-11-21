// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/clock.dart';
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
          style: GoogleFonts.karla(fontSize: 28.0, fontWeight: FontWeight.bold),
          colors: [
            const Color.fromARGB(255, 0, 153, 255),
            Colors.primaries[exercise.color]
          ],
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            customTable("Group", exercise.group),
            customTable("Type", exercise.type),
            customTable("Sets", exercise.sets.toString()),
            customTable("Weight", exercise.weight.toString()),
            customTable("Reps", exercise.reps.toString()),
            Clock(
              color: exercise.color,
            ),
          ]),
    );
  }

  Padding customTable(string1, string2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(31, 194, 194, 194),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ]),
        child: Row(children: [
          Expanded(
            child: Center(
                child: Text(
              string1,
              style: GoogleFonts.karla(fontSize: 20),
            )),
          ),
          Expanded(
            child: Center(
              child: Text(
                string2,
                style: GoogleFonts.karla(fontSize: 20),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
