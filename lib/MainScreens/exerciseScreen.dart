// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/ExerciseLabel.dart';
import 'package:gymap/Extras/completeWidget.dart';
import 'package:gymap/Extras/textBoxWidget.dart';
import 'package:gymap/SimpleScreens/addScreens/addExerciseScreen.dart';
import 'package:gymap/MainScreens/profileScreen.dart';
import 'package:gymap/SimpleScreens/exercisesScreen/exerciseViews/clockScreen.dart';

import 'package:gymap/States/states.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExercisePage extends HookConsumerWidget {
  const ExercisePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Provider
    List<LocalExercise> diplayList = ref.watch(filterListProvider);
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
        title: GradientText(
          'My Exercises',
          style: GoogleFonts.karla(fontSize: 28.0, fontWeight: FontWeight.bold),
          colors: const [
            Color.fromARGB(255, 253, 23, 6),
            Color.fromARGB(255, 95, 40, 190)
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ClocksScreen()));
              },
              icon: const Icon(Ionicons.time)),
          //!Para ir al perfil
          InkWell(
            child: const CircleAvatar(
              child: Icon(Ionicons.person),
            ),
            onTap: () {
              ref.read(timeProvider.state).state =
                  ref.read(userProvider.state).state.restTime;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfileScreen()));
            },
          )
        ],
      ),
      //!SCROLL VIEW
      body: Column(
        children: [
          MaterialButton(
            onPressed: (() {
              ref.read(todayProvider.state).state = "Monday";
            }),
            child: Text(todayDay),
          ),

          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: diplayList.length,
              itemBuilder: (context, index) {
                final ejercicio = diplayList[index];
                if (ejercicio.complete == false) {
                  return Container(
                    //generamos un margin y padding
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(16),
                    //creamos un widget inkwell para que sea presionable
                    child: ExerciseWidget(
                      exercise: ejercicio,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          //!Lista de los Completados
          const SizedBox(
            height: 20,
          ),
          const TextBox(texto: "Completed"),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: diplayList.length,
              itemBuilder: (context, index) {
                final ejercicio = diplayList[index];
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
    );
  }

}
