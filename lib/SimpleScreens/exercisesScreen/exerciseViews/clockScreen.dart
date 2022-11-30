// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymap/Extras/clock.dart';

import 'package:gymap/Extras/secondClock.dart';

import 'package:gymap/States/states.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recase/recase.dart';

class ClocksScreen extends ConsumerStatefulWidget {
  const ClocksScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClocksScreenState();
}

class _ClocksScreenState extends ConsumerState<ClocksScreen> {
  @override
  Widget build(BuildContext context) {
    final exerciseName = ref.watch(currentExerciseProvider);
//le pondremos el nombre del ejercicio que estemos trackeando
    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName.titleCase),
        centerTitle: true,
      ),
      body: Column(
        children: const [Clock(color: 1), SecondClock(color: 2)],
      ),
    );
  }
}
