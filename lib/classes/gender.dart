import 'dart:developer';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Selecter {
  String name;
  bool isSelected;

  Selecter(this.name, this.isSelected);
}

class SelecterNotifier extends StateNotifier<List<Selecter>> {
  // Inicializamos la lista de `todos` como una lista vacía

  SelecterNotifier()
      : super([
          Selecter("PowerLifter", false),
          Selecter("Novice", false),
          Selecter("Advance", false)
        ]);
  //ExerciseNotifier() : super([]);

  void update(index) {
    for (var gender in state) {
      gender.isSelected = false;
    }
    state[index].isSelected = true;
    log(state[index].name);
  }

  String getName(index) {
    return state[index].name;
  }
}

// Finalmente, estamos usando StateNotifierProvider para permitir que la
// interfaz de usuario interactúe con nuestra clase TodosNotifier.
final selecterProvider =
    StateNotifierProvider<SelecterNotifier, List<Selecter>>((ref) {
  return SelecterNotifier();
});
