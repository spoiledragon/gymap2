// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/classes/exercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class GroupListScreen extends ConsumerWidget {
  //ejercicio contiene a los otros ejercicios
  final Exercises ejercicio;
  const GroupListScreen({super.key, required this.ejercicio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //Le mando un gradientText de widget y le digo que diga el nombre del grupo uwu
        title: GradientText(ejercicio.group.toUpperCase(),
            style: GoogleFonts.karla(letterSpacing: 2),
            //colores masomenos a eleccion
            colors: [
              Colors.primaries[ejercicio.color],
              Colors.purple,
            ]),
      ),
      //creamos una Lista a partir de lso datos que ya tenemos uwu
      body: ListView.separated(
        separatorBuilder: (context, index) => divisor(ejercicio.color),
        itemCount: ejercicio.names.length,
        itemBuilder: (context, index) => Container(
            height: 50, child: Center(child: Text(ejercicio.names[index]))),
      ),
    );
  }

  Widget divisor(color) {
    return SizedBox(
      child: Container(
        height: 2,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.primaries[color],
          const Color.fromARGB(255, 104, 29, 146),
        ], stops: const [
          -1.0,
          1.0
        ])),
      ),
    );
  }
}
