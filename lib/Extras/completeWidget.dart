// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/SimpleScreens/exercisesScreen/exerciseViews/customExerciseScreen.dart';
import 'package:gymap/States/states.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompleteWidget extends ConsumerStatefulWidget {
  final LocalExercise exercise;
  const CompleteWidget({super.key, required this.exercise});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CompleteWidgetState();
}

class _CompleteWidgetState extends ConsumerState<CompleteWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 35, 38, 47),
            Colors.accents[widget.exercise.color],
          ],
          stops: const [1, 0],
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.accents[widget.exercise.color],
            blurRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 160,
      height: 160,
      child: MaterialButton(
        child: Text(
          widget.exercise.name,
          style: GoogleFonts.karla(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          ref.read(currentExerciseProvider.state).state = widget.exercise.name;
          //Pasamos la cantidad de sets al provider
          ref.read(setEditingProvider.state).state = widget.exercise.sets;
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) =>
                  SingleExerciseScreen(exercise: widget.exercise))));
        },
        onLongPress: () => ref
            .read(localExerciseProvider.notifier)
            .completeExercise(widget.exercise.name),
      ),
    );
  }
}
