// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymap/Extras/customTable.dart';
import 'package:gymap/Extras/textBoxWidget.dart';
import 'package:gymap/States/states.dart';

import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
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
    final sets = ref.watch(setEditingProvider);
    final weight = ref.watch(weightEditingProvider);
    final reps = ref.watch(repsEditingProvider);
    //regresamops la columna agrupada por el widget que hice customTable que acomoda los valores en un Row
    return Column(
      children: [
        //Grupo
        CustomTable(string1: "Group", string2: widget.exercise.group, color: 1),
        //Sets
        CustomTable(string1: "Sets", string2: sets.toString(), color: 2),
        //Peso
        CustomTable(string1: "Weight", string2: weight.toString(), color: 3),
        //Reps
        CustomTable(string1: "Reps", string2: reps.toString(), color: 4),
        //Completados
        CustomTable(
            string1: "Sets Done Today", string2: complete.toString(), color: 5),

        MaterialButton(
          onPressed: () {
            //Desplegaremos un showDialog
            showBottomSheet(
                context: context,
                builder: (context) => customDialog(widget.exercise));
          },
          child: GradientText("Modify", colors: const [
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

  //!Botom modal
  //TODO: dios dame fuerza
  Container customDialog(LocalExercise exercise) {
    //Sets
    TextEditingController controller1 = TextEditingController();
    TextEditingController controller2 = TextEditingController();
    TextEditingController controller3 = TextEditingController();
    //le ponemos el valor inicial que traiga el ejercicio
    controller1.text = exercise.sets.toString();
    controller2.text = exercise.weight.toString();
    controller3.text = exercise.reps.toString();
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          //Sets
          const TextBox(texto: "Sets"),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Ionicons.remove_circle,
                  size: 30,
                ),
                onPressed: () {
                  int entero = int.parse(controller1.text);
                  if (entero > 1) {
                    controller1.text = (entero - 1).toString();
                  }
                },
              ),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: controller1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Ionicons.add_circle,
                  size: 30,
                ),
                onPressed: () {
                  int entero = int.parse(controller1.text);
                  controller1.text = (1 + entero).toString();
                },
              ),
            ],
          ),
          //!Weight Controller 2
          const TextBox(texto: "Weight"),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Ionicons.remove_circle,
                  size: 30,
                ),
                onPressed: () {
                  int entero = int.parse(controller2.text);
                  if (entero > 1) {
                    controller2.text = (entero - 1).toString();
                  }
                },
              ),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: controller2,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Ionicons.add_circle,
                  size: 30,
                ),
                onPressed: () {
                  int entero = int.parse(controller2.text);
                  controller2.text = (1 + entero).toString();
                },
              ),
            ],
          ),
          //! Reps Controller 3
          const TextBox(texto: "Reps"),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Ionicons.remove_circle,
                  size: 30,
                ),
                onPressed: () {
                  int entero = int.parse(controller3.text);
                  if (entero > 1) {
                    controller3.text = (entero - 1).toString();
                  }
                },
              ),
              Expanded(
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: controller3,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Ionicons.add_circle,
                  size: 30,
                ),
                onPressed: () {
                  int entero = int.parse(controller3.text);
                  controller3.text = (1 + entero).toString();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //!Boton de cancelar
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Cancel"),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Ionicons.close,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              //!Boton de aceptar
              MaterialButton(
                onPressed: () {
                  //!Actualizamos el provider completo y guardamos el cambio
                  ref.read(localExerciseProvider.notifier).modify(
                      exercise.name,
                      int.parse(controller1.text),
                      int.parse(controller2.text),
                      int.parse(controller3.text));
                  //!actualizamos los providers de esta pantalla  todo miado que controla los sets en el widget
                  ref.read(setEditingProvider.state).state =
                      int.parse(controller1.text);
                  ref.read(weightEditingProvider.state).state =
                      int.parse(controller2.text);
                  ref.read(repsEditingProvider.state).state =
                      int.parse(controller3.text);
                  //nos sacamos a la chingada del contenedor

                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Save"),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Ionicons.checkmark_outline,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
