// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gymap/Extras/ExerciseLabel.dart';
import 'package:gymap/Extras/completeWidget.dart';
import 'package:gymap/Extras/textBoxWidget.dart';
import 'package:gymap/SimpleScreens/addScreens/addExerciseScreen.dart';
import 'package:gymap/SimpleScreens/exercisesScreen/exerciseViews/clockScreen.dart';
import 'package:gymap/SimpleScreens/exercisesScreen/exerciseViews/customExerciseScreen.dart';
import 'package:gymap/States/states.dart';

import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';

class ExercisePage extends HookConsumerWidget {
  const ExercisePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Provider
    List<LocalExercise> displayList = ref.watch(filterListProvider);
    List<LocalExercise> completeList = ref.watch(completeListExerciseProvider);
    final String todayDay = ref.watch(todayProvider);

    //!Funciones [Piolas]

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddExerciseScreen()));
        },
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: TextFormField(
          onChanged: (value) => ref.read(searchProvider.state).state = value,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: "Search Something",
            filled: false,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ClocksScreen()));
              },
              icon: const Icon(Ionicons.time)),
        ],
      ),
      //!SCROLL VIEW DE LOS NO COMPLETADOS
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: MaterialButton(
              /*onPressed: () => showDialog(
                  context: context, builder: (context) => AlertDialog(

                  )),
               */
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => botomModal(ref, context),
              ),
              child: Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey),
                child: Center(child: Text(todayDay)),
              ),
            ),
          ),

          if (displayList.isNotEmpty)
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final ejercicio = displayList[index];
                  if (ejercicio.complete == false) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Slidable(
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          //Delete
                          SlidableAction(
                            borderRadius: BorderRadius.circular(5),
                            flex: 2,
                            onPressed: (context) {
                              ref
                                  .read(localExerciseProvider.notifier)
                                  .removeExercise(
                                      ejercicio.name, ejercicio.weight);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Ionicons.trash_bin,
                            label: 'Delete',
                          ),
                          //Complete
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,

                            onPressed: (context) {
                              //!Para Completar
                              ref
                                  .read(localExerciseProvider.notifier)
                                  .completeExercise(ejercicio.name);
                              //!Para crear el registro
                              //conseugimos la fecha de ahorita mismo
                              DateTime rightNow = DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day);
                              //!Creamos la instancia de completedExercise
                              final hello = Completed(
                                  date: rightNow,
                                  name: ejercicio.name,
                                  weight: ejercicio.weight.toString());
                              ref
                                  .read(localExerciseProvider.notifier)
                                  .addComplete(ejercicio.name, hello);
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 67, 117, 192),
                            borderRadius: BorderRadius.circular(5),
                            foregroundColor: Colors.white,
                            icon: Icons.play_arrow,
                            label: 'Complete',
                          ),
                        ]),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              //decimos cual ejercicio
                              ref.read(currentExerciseProvider.state).state =
                                  ejercicio.name;
                              //Pasamos la cantidad de sets al provider
                              ref.read(setEditingProvider.state).state =
                                  ejercicio.sets;
                              log(ref
                                  .read(currentExerciseProvider.state)
                                  .state);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => SingleExerciseScreen(
                                      exercise: ejercicio))));
                            },
                            child: ExerciseWidget(
                              exercise: ejercicio,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            )
          else
            const TextBox(
              texto: "Empy List",
            ),
          //!Lista de los Completados
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextBox(texto: "Completed"),
              Row(
                children: [
                  const Text("Back Everything"),
                  IconButton(
                      onPressed: () => ref
                          .read(localExerciseProvider.notifier)
                          .retrieveEverything(),
                      icon: const Icon(Ionicons.arrow_undo)),
                ],
              )
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: completeList.length,
                    itemBuilder: (context, index) {
                      final ejercicio = completeList[index];
                      if (ejercicio.complete == true) {
                        return Container(
                          //generamos un margin y padding
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(16),
                          //creamos un widget inkwell para que sea presionable
                          child: CompleteWidget(
                            exercise: ejercicio,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//MOdal inferior para elegir que dia quieres
  Column botomModal(WidgetRef ref, BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      InkWell(
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text(
              "Monday",
              style: GoogleFonts.openSans(fontSize: 24),
            ))),
        onTap: () {
          ref.read(todayProvider.state).state = "Monday";
          Navigator.of(context).pop();
        },
      ),
      InkWell(
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text("Tuesday",
                    style: GoogleFonts.openSans(fontSize: 24)))),
        onTap: () {
          ref.read(todayProvider.state).state = "Tuesday";
          Navigator.of(context).pop();
        },
      ),
      InkWell(
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text("Wednesday",
                    style: GoogleFonts.openSans(fontSize: 24)))),
        onTap: () {
          ref.read(todayProvider.state).state = "Wednesday";
          Navigator.of(context).pop();
        },
      ),
      InkWell(
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text("Thursday",
                    style: GoogleFonts.openSans(fontSize: 24)))),
        onTap: () {
          ref.read(todayProvider.state).state = "Thursday";
          Navigator.of(context).pop();
        },
      ),
      InkWell(
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child:
                    Text("Friday", style: GoogleFonts.openSans(fontSize: 24)))),
        onTap: () {
          ref.read(todayProvider.state).state = "Friday";
          Navigator.of(context).pop();
        },
      ),
      InkWell(
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text("Saturday",
                    style: GoogleFonts.openSans(fontSize: 24)))),
        onTap: () {
          ref.read(todayProvider.state).state = "Saturday";
          Navigator.of(context).pop();
        },
      ),
      InkWell(
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child:
                    Text("Sunday", style: GoogleFonts.openSans(fontSize: 24)))),
        onTap: () {
          ref.read(todayProvider.state).state = "Sunday";
          Navigator.of(context).pop();
        },
      ),
    ]);
  }
}
