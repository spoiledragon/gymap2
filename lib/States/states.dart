import 'package:gymap/classes/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//En donde esta el index
final homeindexProvider = StateProvider((ref) => 0);
//Color Mode
final isDarkMode = StateProvider((ref) => true);

//! Providers Temporales para agregar en el modal
final nameAddProvider = StateProvider((ref) => "");
final typeAddProvider = StateProvider((ref) => "");
final groupAddProvider = StateProvider((ref) => "Chest");
final weightAddProvider = StateProvider<int>((ref) => 0);
final setsAddProvider = StateProvider<int>((ref) => 0);
final repsAddProvider = StateProvider<int>((ref) => 0);
final colorAddProvider = StateProvider<int>((ref) => 1);
final selectedProvider = StateProvider<List<bool>>(
  (ref) => List.filled(3, false),
);

//!Register Page
final ageRegisterProvider = StateProvider<int>((ref) => 25);
final weightRegisterProvider = StateProvider<int>((ref) => 100);
final genderRegisterProvider = StateProvider<String>((ref) => "Male");


