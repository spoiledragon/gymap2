// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/States/states.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//Cronometro 1

final runingProvider = StateProvider<bool>((ref) => false);
final secondtickProvider = StateProvider((ref) => 120);

class Clock extends ConsumerStatefulWidget {
  final int color;
  const Clock({Key? key, required this.color}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClockState();
}

class _ClockState extends ConsumerState<Clock> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    int ticks = ref.watch(secondtickProvider);
    bool isRunning = ref.watch(runingProvider);
    //FUNCIONES

    void pauseTimer() {
      ref.read(runingProvider.state).state = false;
      timer?.cancel();
    }

    void stopTimer() {
      ref.read(runingProvider.state).state = false;
      ref.read(secondtickProvider.state).state = ref.read(timeGlobalProvider);
      timer?.cancel();
    }

    void starttimer() {
      if (ref.read(runingProvider.state).state == false) {
        ref.read(runingProvider.state).state = true;
        //timer que decrementa cada segundoi
        // ignore: avoid_types_as_parameter_names
        timer = Timer.periodic(const Duration(seconds: 1), (Timer Timer) async {
          //el no va a parar
          //!Si el segundero es mayor a 0 y esta corriendo
          if (ref.read(secondtickProvider.state).state > 0) {
            ref.read(secondtickProvider.state).state--;
          } else {
            stopTimer();
          }
        });
      } else {
        stopTimer();
      }
    }

    Widget buildTime() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ref.read(maingymBroProvider)),
            Text(
              "$ticks",
              style: GoogleFonts.bebasNeue(fontSize: 60, color: Colors.white),
            ),
          ],
        );

    Widget buildTimer() => SizedBox(
          width: 150,
          height: 150,
          child: Stack(fit: StackFit.expand, children: [
            CircularProgressIndicator(
              color: Colors.accents[widget.color],
              strokeWidth: 12,
              value: ticks / ref.read(timeGlobalProvider),
            ),
            Center(child: buildTime())
          ]),
        );

    Widget buildButtons() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: (() => {
                    pauseTimer(),
                  }),
              child: const Text("Pause"),
            ),
            MaterialButton(
              onPressed: (() => {
                    stopTimer(),
                  }),
              child: const Text("Cancel"),
            ),
          ],
        );

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //esta corriendo?
          isRunning
              //Si
              ? Center(
                  child: Column(
                    children: [
                      buildTimer(),
                      const SizedBox(
                        height: 20,
                      ),
                      buildButtons(),
                    ],
                  ),
                )
              :
              //No
              Center(
                  child: MaterialButton(
                    onPressed: (() => starttimer()),
                    child: const Text("Start"),
                  ),
                ),
        ],
      ),
    );
  }
}
