// ignore_for_file: file_names

import 'package:gymap/classes/localExercise.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';

class ExerciseView2 extends ConsumerStatefulWidget {
  const ExerciseView2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExerciseView2State();
}

class _ExerciseView2State extends ConsumerState<ExerciseView2> {
  @override
  Widget build(BuildContext context) {
    final logsList = ref.watch(logsProvider);

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: logsList.length,
      itemBuilder: (context, index) {
        final loger = logsList[index];
        //sacamos la fecha en pedazos porque si no se hace un mega desmadre
        final datelog = DateTime.parse(loger.date);
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(datelog);
        //!Regresamos el widget
        return logLabel(formatted: formatted, loger: loger);
      },
    );
  }
}

//Widget de el label
// ignore: camel_case_types
class logLabel extends StatelessWidget {
  const logLabel({
    Key? key,
    required this.formatted,
    required this.loger,
  }) : super(key: key);

  final String formatted;
  final CompletedExercises loger;

  @override
  Widget build(BuildContext context) {
    return Container(
      //generamos un margin y padding
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 54, 54, 54)),
      //creamos un widget inkwell para que sea presionable
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Ionicons.checkbox,
            color: Colors.orangeAccent,
          ),
          Expanded(
              flex: 1,
              child: Center(
                child: Text(formatted,
                    style: GoogleFonts.openSans(color: Colors.white)),
              )),
          Expanded(flex: 1, child: Center(child: Text(loger.weight)))
        ],
      ),
    );
  }
}
