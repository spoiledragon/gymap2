// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:gymap/SimpleScreens/exercisesScreen/exerciseViews/exerciseView1.dart';
import 'package:gymap/SimpleScreens/exercisesScreen/exerciseViews/exerciseView2.dart';
import 'package:gymap/States/states.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../classes/localExercise.dart';

class IndexedExercisesScreens extends ConsumerStatefulWidget {
  final LocalExercise exercise;
  const IndexedExercisesScreens({super.key, required this.exercise});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IndexedRegisterScreensState();
}

class _IndexedRegisterScreensState
    extends ConsumerState<IndexedExercisesScreens> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = ref.watch(controllerExerciseProvider);
    //lista de las paginas que puede desplegar
    final ScreensPages = [
      //pagina 1
      ExerciseView1(
        exercise: widget.exercise,
      ),
      //pagina 2 como constante por el momento
      const ExerciseView2()
    ];

    //regrsamos un par de widgets stackeados
    return Stack(children: [
      //vista de las paginas de la lista
      PageView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        children: ScreensPages,
      ),
      //contendor que muestra los puntos de que pagian estamos
      Container(
        alignment: const Alignment(0, 0.9),
        child: SmoothPageIndicator(
          controller: controller,
          count: 2,
          //efecto si lo quieres cambiar
          effect: const ScrollingDotsEffect(
            dotColor: Colors.white38,
            activeDotColor: Colors.grey,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
      )
    ]);
  }
}
