// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymap/classes/localExercise.dart';

import 'package:ionicons/ionicons.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SearchExerciseDelegate extends SearchDelegate {
  SearchExerciseDelegate({required this.valueQuery, required this.ejercicios});

  String valueQuery;
  List<LocalExercise> ejercicios;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = "", icon: const Icon(Ionicons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Ionicons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("BuildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListTile(
      title: GradientText(
        "Suggestions",
        colors: const [Colors.red, Colors.blue],
      ),
    );
  }
}
