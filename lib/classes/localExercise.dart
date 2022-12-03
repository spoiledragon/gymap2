// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

import 'package:gymap/States/states.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

List<LocalExercise> localExerciseFromJson(String str) =>
    List<LocalExercise>.from(
        json.decode(str).map((x) => LocalExercise.fromJson(x)));

String localExerciseToJson(List<LocalExercise> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocalExercise {
  LocalExercise({
    required this.name,
    required this.group,
    required this.weight,
    required this.sets,
    required this.reps,
    required this.color,
    required this.complete,
    required this.days,
    required this.completeds,
  });

  String name;
  String group;
  int weight;
  int sets;
  int reps;
  int color;
  bool complete;
  List<String> days;
  List<Completed> completeds;

  factory LocalExercise.fromJson(Map<String, dynamic> json) => LocalExercise(
        name: json["name"],
        group: json["group"],
        weight: json["weight"],
        sets: json["sets"],
        reps: json["reps"],
        color: json["color"],
        complete: json["complete"],
        days: List<String>.from(json["days"].map((x) => x)),
        completeds: List<Completed>.from(
            json["completeds"].map((x) => Completed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "group": group,
        "weight": weight,
        "sets": sets,
        "reps": reps,
        "color": color,
        "complete": complete,
        "days": List<dynamic>.from(days.map((x) => x)),
        "completeds": List<dynamic>.from(completeds.map((x) => x.toJson())),
      };
}

class Completed {
  Completed({
    required this.name,
    required this.date,
    required this.weight,
  });

  String name;
  DateTime date;
  String weight;

  factory Completed.fromJson(Map<String, dynamic> json) => Completed(
        name: json["name"],
        date: DateTime.parse(json["date"]),
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date.toIso8601String(),
        "weight": weight,
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

  bool removeExercise(String nombre, int weight) {
    // Nuevamente, nuestro estado es inmutable. Así que estamos haciendo
    // una nueva lista en lugar de cambiar la lista existente.
    state = [
      for (final exe in state)
        if (exe.name != nombre && exe.weight != weight) exe,
    ];
    savebitches();
    return true;
  }

  void completeExercise(String nombre) {
    List<LocalExercise> tempList = state;

    for (var exe in tempList) {
      if (exe.name == nombre) {
        exe.complete = !exe.complete;
        //!Funcion para guardar que se hizo y con que se hizo
      }
    }
    state = List.from(tempList);

    savebitches();
  }

  void retrieveEverything() {
    List<LocalExercise> tempList = state;

    for (var exe in tempList) {
      exe.complete = false;
    }

    state = List.from(tempList);
    savebitches();
  }

  void addComplete(
    String name,
    Completed hello,
  ) {
    for (var exe in state) {
      if (exe.name == name) {
        exe.completeds.add(hello);
      }
    }
    savebitches();
  }

  modify(String name, int sets, int weight, int reps) {
    for (var exe in state) {
      if (exe.name == name) {
        exe.sets = sets;
        exe.weight = weight;
        exe.reps = reps;
      }
    }
    state = [...state];
    savebitches();
  }

  savebitches() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('Exercises', jsonEncode(state));
    log(jsonEncode(state));
  }

  bool exist(name) {
    for (var exerice in state) {
      if (exerice.name.toLowerCase() == name.toString().toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}

// Finalmente, estamos usando StateNotifierProvider para permitir que la
// interfaz de usuario interactúe con nuestra clase TodosNotifier.
final localExerciseProvider =
    StateNotifierProvider<LocalExerciseNotifier, List<LocalExercise>>((ref) {
  return LocalExerciseNotifier();
});

final searchProvider = StateProvider<String>(((ref) => ""));
final todayProvider = StateProvider<String>((ref) {
  var today = DateFormat('EEEE').format(DateTime.now());
  return today;
});

final todayList = StateProvider<List<LocalExercise>>(((ref) {
  // ignore: no_leading_underscores_for_local_identifiers
  final _todayList = ref.watch(localExerciseProvider);
  final todayDay = ref.watch(todayProvider);
  List<LocalExercise> todayList2 = [];

  for (var exe in _todayList) {
    var days = exe.days;
    for (var day in days) {
      if (day == todayDay) {
        todayList2.add(exe);
      }
    }
  }
  return todayList2;
}));

final completeListExerciseProvider = StateProvider<List<LocalExercise>>(((ref) {
  final lista = ref.watch(todayList);
  final List<LocalExercise> lista2 = [];
  for (var exe in lista) {
    if (exe.complete == true) {
      lista2.add(exe);
    }
  }

  return lista2;
}));

final filterListProvider = StateProvider<List<LocalExercise>>(((ref) {
  //Provider que me regresa solo los ejercicios buscados
  final lista = ref.watch(todayList);
  final searchString = ref.watch(searchProvider);

  return lista
      .where((element) =>
          element.name.toLowerCase().contains(searchString.toLowerCase()))
      .toList();
}));

final logsProvider = StateProvider<List<Completed>>(((ref) {
  //lista de los ejercicios de hoy
  final lista = ref.watch(todayList);
  //lista vacia por si acazo
  final List<Completed> listita = [];
  //revisamos el nombre del seleccionado
  final nombre = ref.watch(currentExerciseProvider);
  for (var exe in lista) {
    if (exe.name.toLowerCase() == nombre.toLowerCase()) {
      log("si");
      for (var log in exe.completeds) {
        listita.add(log);
      }
      log(listita.length.toString());
    }
  }
  return listita;
}));
