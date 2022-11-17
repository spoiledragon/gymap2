// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

List<Exercises> exercisesFromJson(String str) =>
    List<Exercises>.from(json.decode(str).map((x) => Exercises.fromJson(x)));

String exercisesToJson(List<Exercises> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Exercises {
  Exercises({
    required this.group,
    required this.color,
    required this.names,
  });

  String group;
  int color;
  List<String> names;

  factory Exercises.fromJson(Map<String, dynamic> json) => Exercises(
        group: json["group"],
        color: json["color"],
        names: List<String>.from(json["names"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "group": group,
        "color": color,
        "names": List<dynamic>.from(names.map((x) => x)),
      };
}

class ExerciseNotifier extends StateNotifier<List<Exercises>> {
  // Inicializamos la lista de `todos` como una lista vacía

  ExerciseNotifier() : super([]);
  //ExerciseNotifier() : super([]);
  // Permitamos que la interfaz de usuario agregue todos.
  void addExercise(Exercises ejercicio) {
    // Ya que nuestro estado es inmutable, no podemos hacer `state.add(todo)`.
    // En su lugar, debemos crear una nueva lista de todos que contenga la anterior
    // elementos y el nuevo.
    // ¡Usar el spread operator de Dart aquí es útil!
    state = [...state, ejercicio];
    // No es necesario llamar a "notifyListeners" o algo similar. Llamando a "state ="
    // reconstruirá automáticamente la interfaz de usuario cuando sea necesario.

    //!AQUI PONDREMOS QUE SE GUARDEN LAS COSAS
  }
}

// Finalmente, estamos usando StateNotifierProvider para permitir que la
// interfaz de usuario interactúe con nuestra clase TodosNotifier.
final ExerciseProvider =
    StateNotifierProvider<ExerciseNotifier, List<Exercises>>((ref) {
  return ExerciseNotifier();
});
