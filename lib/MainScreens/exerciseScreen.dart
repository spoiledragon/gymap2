// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/ExerciseLabel.dart';
import 'package:gymap/Extras/SilverSearchPage.dart';
import 'package:gymap/SimpleScreens/addExerciseScreen.dart';
import 'package:gymap/MainScreens/profileScreen.dart';
import 'package:gymap/SimpleScreens/customExerciseScreen.dart';
import 'package:gymap/States/states.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExercisePage extends HookConsumerWidget {
  const ExercisePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Provider
    final String profilePicture =
        ref.read(userProvider.state).state.profilePicture;
    List<LocalExercise> diplayList = ref.watch(filterListProvider);

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
          InkWell(
            child: CircleAvatar(
              backgroundImage: NetworkImage(profilePicture),
            ),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen())),
          )
        ],
      ),
      //!SCROLL VIEW
      body: CustomScrollView(
        //!Barra de busqueda
        slivers: [
          const SliverPersistentHeader(
            delegate: SliverSearchAppBar(),
            // Set this param so that it won't go off the screen when scrolling
            pinned: true,
          ),
          //! Lista a
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              //Generamos el ejercicio del index
              final ejercicio = diplayList[index];
              return Container(
                //generamos un margin y padding
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                //creamos un widget inkwell para que sea presionable
                child: InkWell(
                  //si lo presinamos una vez lo mandamos a la pagina del widget
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) =>
                          SingleExerciseScreen(exercise: ejercicio)))),
                  //si lo dejamos presionado entonces lo borramos
                  onLongPress: () => ref
                      .read(localExerciseProvider.notifier)
                      .removeExercise(ejercicio.name, ejercicio.weight),
                  //como widget hijo es el ejercicio en forma grafica con el objeto interno ejercicio de forma de datos
                  child: ExerciseWidget(
                    exercise: ejercicio,
                  ),
                ),
              );
              //que se repita hasta que sea igual a la lista de ejercicios que se saca del provider
            }, childCount: diplayList.length),
          )
        ],
      ),
    );
  }
}
