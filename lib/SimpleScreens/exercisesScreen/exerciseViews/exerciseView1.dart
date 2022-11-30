// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymap/Extras/customTable.dart';
import 'package:gymap/States/states.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExerciseView1 extends ConsumerStatefulWidget {
  const ExerciseView1({super.key, required this.exercise});
  final LocalExercise exercise;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExerciseView1State();
}

class _ExerciseView1State extends ConsumerState<ExerciseView1> {
  @override
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

        /*
            MaterialButton(
          onPressed: () {
            //?actualizamos el estado del provider con el nombre del ejercicio
            //revisamos que no sea el mismo ejercicio
            if (ref.read(currentExerciseProvider) != widget.exercise.name) {
              ref.read(currentExerciseProvider.state).state =
                  widget.exercise.name;
              //?actualizamos el estado del provider con la cantidad de sets que deben de ser
              ref.read(currentSetsToDoProvider.state).state =
                  widget.exercise.sets;
              //?Ponemos los completados en 0
              ref.read(completeProvider.state).state = 0;
              //?vamos a la pagina de los relojes para trackearlo correctamente
            }
          },
          child: GradientText("Track Exercise", colors: const [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple
          ]),
        )
            
             */
      ],
    );
  }
}
