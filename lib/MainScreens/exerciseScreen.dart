// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gymap/Extras/ExerciseLabel.dart';

import 'package:gymap/Extras/SilverSearchPage.dart';
import 'package:gymap/MainScreens/addExerciseScreen.dart';
import 'package:gymap/MainScreens/profileScreen.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExercisePage extends HookConsumerWidget {
  const ExercisePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ejercicios = ref.watch(localExerciseProvider);
    /*
    final LocalExercise tester = LocalExercise(
        name: "Huge Dragon Dick",
        group: "Dick",
        type: "Dumbell",
        weight: 99,
        sets: 2,
        reps: 2,
        color: 1,
        days: ["L", "M"]);
    */

    //!Funciones [Piolas]

    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
          InkWell(
            child: const CircleAvatar(
              backgroundImage: AssetImage('lib/Assets/images/login.jpg'),
            ),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen())),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverPersistentHeader(
            delegate: SliverSearchAppBar(),
            // Set this param so that it won't go off the screen when scrolling
            pinned: true,
          ),
          //! Lista a desplegar
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              final ejercicio = ejercicios[index];
              return Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  child: ExerciseWidget(
                    exercise: ejercicio,
                  ));
            }, childCount: ejercicios.length),
          )
        ],
      ),
    );
  }
}
