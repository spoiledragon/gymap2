// ignore_for_file: file_names

import 'dart:developer';

import 'package:d_chart/d_chart.dart';

import 'package:flutter/material.dart';
import 'package:gymap/Extras/customTable.dart';
import 'package:gymap/States/states.dart';

import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExerciseView1 extends ConsumerStatefulWidget {
  const ExerciseView1({super.key, required this.exercise});
  final LocalExercise exercise;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExerciseView1State();
}

class _ExerciseView1State extends ConsumerState<ExerciseView1> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    //Provider de si esta completo que se actualiza cada que el contador del clock 1 llega a 0
    final complete = ref.watch(completeProvider);
    //regresamops la columna agrupada por el widget que hice customTable que acomoda los valores en un Row
    return Column(
      children: [
        //Grupo
        CustomTable(string1: "Group", string2: widget.exercise.group, color: 1),
        //Sets
        CustomTable(
            string1: "Sets",
            string2: widget.exercise.sets.toString(),
            color: 2),
        //Peso
        CustomTable(
            string1: "Weight",
            string2: widget.exercise.weight.toString(),
            color: 3),
        //Reps
        CustomTable(
            string1: "Reps",
            string2: widget.exercise.reps.toString(),
            color: 4),
        //Completados
        CustomTable(
            string1: "Sets Done Today", string2: complete.toString(), color: 5),

        MaterialButton(
          onPressed: () {
            //?actualizamos el estado del provider con el nombre del ejercicio
            //revisamos que no sea el mismo ejercicio
            if (ref.read(currentExerciseProvider) != widget.exercise.name) {
              ref.read(currentExerciseProvider.state).state =
                  widget.exercise.name;
              ref.read(controllerExerciseProvider.state).state.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn);
            }
          },
          child: GradientText("Show My Progress", colors: const [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple
          ]),
        ),
      ],
    );
  }
}
