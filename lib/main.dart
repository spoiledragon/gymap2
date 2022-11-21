// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:gymap/MainScreens/splashScreen.dart';

import 'package:gymap/States/states.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends HookConsumerWidget {
  final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 22),
    appBarTheme:
        const AppBarTheme(backgroundColor: Color.fromARGB(255, 20, 20, 22)),
    primarySwatch: Colors.blue,
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.black),
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(size: 20, color: Colors.white),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      bodyText1: TextStyle(color: Colors.white),
    ),
  );

  final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.purple,
    iconTheme: const IconThemeData(size: 20, color: Colors.black),
    textTheme: const TextTheme(
        subtitle1: TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.black,
    )),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      hintStyle: const TextStyle(
        color: Colors.black45,
      ),
      labelStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(isDarkMode);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: isDarkTheme ? darkTheme : lightTheme,
      home: const SplashScreen(),
    );
  }
}
