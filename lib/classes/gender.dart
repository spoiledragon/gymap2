import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Gender {
  String name;
  IconData icon;
  bool isSelected;

  Gender(this.name, this.icon, this.isSelected);
}

class GenderNotifier extends StateNotifier<List<Gender>> {
  // Inicializamos la lista de `todos` como una lista vacía

  GenderNotifier()
      : super([
          Gender("Female", Icons.female, false),
          Gender("Male", Icons.male, false)
        ]);
  //ExerciseNotifier() : super([]);

  void update(index) {
    for (var gender in state) {
      gender.isSelected = false;
    }
    state[index].isSelected = true;
  }
}

// Finalmente, estamos usando StateNotifierProvider para permitir que la
// interfaz de usuario interactúe con nuestra clase TodosNotifier.
final genderProvider =
    StateNotifierProvider<GenderNotifier, List<Gender>>((ref) {
  return GenderNotifier();
});
