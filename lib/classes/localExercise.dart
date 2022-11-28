// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

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
      required this.weight,
      required this.sets,
      required this.reps,
      required this.color,
      required this.days});

  String name;
  String group;

  int weight;
  int sets;
  int reps;
  int color;
  List<String> days;

  factory LocalExercise.fromJson(Map<String, dynamic> json) => LocalExercise(
        name: json["name"],
        group: json["group"],
        weight: json["weight"],
        sets: json["sets"],
        reps: json["reps"],
        color: json["color"],
        days: List<String>.from(json["days"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "group": group,
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
  bool addExercise(LocalExercise ejercicio) {
    // Ya que nuestro estado es inmutable, no podemos hacer `state.add(todo)`.
    // En su lugar, debemos crear una nueva lista de todos que contenga la anterior
    // elementos y el nuevo.
    // ¡Usar el spread operator de Dart aquí es útil!

//!Comprobamos que no este repetido
    if (exist(ejercicio.name)) {
      return false;
    }
    state = [...state, ejercicio];

    // No es necesario llamar a "notifyListeners" o algo similar. Llamando a "state ="
    // reconstruirá automáticamente la interfaz de usuario cuando sea necesario.
    savebitches();
    return true;
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

  bool exist(name) {
    for (var exerice in state) {
      if (exerice.name.toLowerCase() == name.toString().toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  List<LocalExercise> todayExercises(String fetchDay) {
    List<LocalExercise> todayExercises = [];
    //var today = DateFormat('EEEE').format(DateTime.now());

    //creamos lista vacia de ejercicios
    //recorremos los ejercicios en el estado
    for (final ejercicio in state) {
      //creamos la vairable de dias a partir del arreglo json del ejercicio
      final dias = ejercicio.days;
      //comprobamos si corresponde con el dia de hoy
      for (String dia in dias) {
        if (dia == fetchDay) {
          log(dia);
          log(ejercicio.name);
          todayExercises.add(ejercicio);
        }
      }
    }
    return todayExercises;
  }

  List<LocalExercise> onSearch(String search) {
    List<LocalExercise> todayExercises = [];
    //var today = DateFormat('EEEE').format(DateTime.now());

    //creamos lista vacia de ejercicios
    //recorremos los ejercicios en el estado
    for (final ejercicio in state) {
      //creamos la vairable de dias a partir del arreglo json del ejercicio
      final dias = ejercicio.days;
      //comprobamos si corresponde con el dia de hoy
      for (String dia in dias) {
        if (dia == search) {
          log(dia);
          log(ejercicio.name);
          todayExercises.add(ejercicio);
        }
      }
    }
    return todayExercises;
  }
}

// Finalmente, estamos usando StateNotifierProvider para permitir que la
// interfaz de usuario interactúe con nuestra clase TodosNotifier.
final localExerciseProvider =
    StateNotifierProvider<LocalExerciseNotifier, List<LocalExercise>>((ref) {
  return LocalExerciseNotifier();
});
//Provider que me regresa solo los ejercicios del dia actual

final searchProvider = StateProvider<String>(((ref) => ""));
final filterListProvider = StateProvider<List<LocalExercise>>(((ref) {
  final lista = ref.watch(localExerciseProvider);
  final searchString = ref.watch(searchProvider);

  return lista
      .where((element) =>
          element.name.toLowerCase().contains(searchString.toLowerCase()))
      .toList();
}));
