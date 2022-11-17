// ignore_for_file: file_names

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<LocalExercise> exercisesFromJson(String str) => List<LocalExercise>.from(
    json.decode(str).map((x) => LocalExercise.fromJson(x)));

String exercisesToJson(List<LocalExercise> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocalExercise {
  LocalExercise(
      {required this.name,
      required this.group,
      required this.type,
      required this.weight,
      required this.sets,
      required this.reps,
      required this.color,
      required this.days});

  String name;
  String group;
  String type;
  int weight;
  int sets;
  int reps;
  int color;
  List<String> days;

  factory LocalExercise.fromJson(Map<String, dynamic> json) => LocalExercise(
        name: json["name"],
        group: json["group"],
        type: json["type"],
        weight: json["weight"],
        sets: json["sets"],
        reps: json["reps"],
        color: json["color"],
        days: List<String>.from(json["days"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "group": group,
        "type": type,
        "weight": weight,
        "sets": sets,
        "reps": reps,
        "color": color,
        "days": List<dynamic>.from(days.map((x) => x)),
      };
}

class LocalExerciseNotifier extends StateNotifier<List<LocalExercise>> {
  // Inicializamos la lista de `todos` como una lista vacía

  LocalExerciseNotifier() : super([]);
  //ExerciseNotifier() : super([]);
  // Permitamos que la interfaz de usuario agregue todos.
  void addExercise(LocalExercise ejercicio) {
    // Ya que nuestro estado es inmutable, no podemos hacer `state.add(todo)`.
    // En su lugar, debemos crear una nueva lista de todos que contenga la anterior
    // elementos y el nuevo.
    // ¡Usar el spread operator de Dart aquí es útil!
    state = [...state, ejercicio];
    // No es necesario llamar a "notifyListeners" o algo similar. Llamando a "state ="
    // reconstruirá automáticamente la interfaz de usuario cuando sea necesario.
    savebitches();
    //!AQUI PONDREMOS QUE SE GUARDEN LAS COSAS
  }

  void removeExercise(String nombre, int weight) {
    // Nuevamente, nuestro estado es inmutable. Así que estamos haciendo
    // una nueva lista en lugar de cambiar la lista existente.
    state = [
      for (final exe in state)
        if (exe.name != nombre && exe.weight != weight) exe,
    ];
    savebitches();
  }

  savebitches() async {
    //print(state);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Exercises', jsonEncode(state));
  }
}

// Finalmente, estamos usando StateNotifierProvider para permitir que la
// interfaz de usuario interactúe con nuestra clase TodosNotifier.
final localExerciseProvider =
    StateNotifierProvider<LocalExerciseNotifier, List<LocalExercise>>((ref) {
  return LocalExerciseNotifier();
});
// interfaz de usuario interactúe con nuestra clase TodosNotifier.
final localTodayExerciseProvider =
    StateNotifierProvider<LocalExerciseNotifier, List<LocalExercise>>((ref) {
  return LocalExerciseNotifier();
});