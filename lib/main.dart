// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:gymap/SimpleScreens/splashScreen.dart';

import 'package:gymap/States/states.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends HookConsumerWidget {
  final darkTheme = ThemeData(
    //scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 22),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme:
        const AppBarTheme(backgroundColor: Color.fromARGB(255, 20, 20, 22)),
    primarySwatch: Colors.blue,
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.black),
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(size: 20, color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromARGB(255, 37, 37, 37),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      bodyText1: TextStyle(color: Colors.white),
    ),
  );

  final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme:
        const AppBarTheme(backgroundColor: Color.fromARGB(255, 20, 20, 22)),
    primarySwatch: Colors.blue,
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.black),
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(size: 20, color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromARGB(255, 37, 37, 37),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: Colors.black,
      ),
      bodyText1: TextStyle(color: Colors.black),
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(isDarkMode);
    return MaterialApp(
      title: 'WolfApp',
      debugShowCheckedModeBanner: false,
      theme: isDarkTheme ? darkTheme : lightTheme,
      home: const SplashScreen(),
    );
  }
}
