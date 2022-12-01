// To parse this JSON data, do
//
//     final exercises = exercisesFromJson(jsonString);

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
    required this.exercises,
  });

  String group;
  int color;
  List<Exercise> exercises;

  factory Exercises.fromJson(Map<String, dynamic> json) => Exercises(
        group: json["group"],
        color: json["color"],
        exercises: List<Exercise>.from(
            json["exercises"].map((x) => Exercise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "group": group,
        "color": color,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
      };
}

class Exercise {
  Exercise({
    required this.title,
    required this.info,
    required this.image,
    required this.videoUrl,
  });

  String title;
  String info;
  String image;
  String videoUrl;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
      title: json["title"],
      info: json["info"],
      image: json["image"],
      videoUrl: json["videoUrl"]);

  Map<String, dynamic> toJson() =>
      {"title": title, "info": info, "image": image, "videoUrl": videoUrl};
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
  }
}

// Finalmente, estamos usando StateNotifierProvider para permitir que la
// interfaz de usuario interactúe con nuestra clase TodosNotifier.
final exercisesProvider =
    StateNotifierProvider<ExerciseNotifier, List<Exercises>>((ref) {
  return ExerciseNotifier();
});
