// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/SimpleScreens/addScreens/addFromJsonExercise.dart';
import 'package:gymap/classes/exercise.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExercisesFromJsonScreen extends ConsumerWidget {
  final Exercise exercise;
  final String group;
  final int color;
  const ExercisesFromJsonScreen({
    super.key,
    required this.exercise,
    required this.group,
    required this.color,
  });

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
        //!Se estackea para poder agregar un boton al final uwu
        body: Stack(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
            Container(
                alignment: const Alignment(0, 0.9),
                child: MaterialButton(
                  color: Colors.red,
                  onPressed: () {
                    //!Comprobamos si existe algun ejercicio ya Creado
                    if (ref
                        .read(localExerciseProvider.notifier)
                        .exist(exercise.title)) {
                      showToast(context, "Already Added");
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => AddFromJsonScreen(
                              name: exercise.title,
                              group: group,
                              color: color))));
                    }
                  },
                  child: const Text("Add to my Exercises"),
                )),
            //Boton para agregarlo a los ejercicios
          ],
        ));
  }

  void showToast(BuildContext context, mensaje) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }
}
