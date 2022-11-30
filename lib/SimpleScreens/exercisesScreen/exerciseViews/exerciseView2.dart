// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExerciseView2 extends ConsumerStatefulWidget {
  const ExerciseView2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExerciseView2State();
}

class _ExerciseView2State extends ConsumerState<ExerciseView2> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Stat"));
  }
}
