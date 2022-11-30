// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/textBoxWidget.dart';
import 'package:gymap/States/states.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfigScreen extends StatefulHookConsumerWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfigScreenState();
}

TextEditingController gymBro = TextEditingController();

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    //para iniciar
    useEffect(() {
      gymBro.text = ref.read(userProvider.state).state.gymBro;
      return null;
    });
    Container cupertinoWidget(int value) {
      return Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 37, 37, 37),
              borderRadius: BorderRadius.circular(20)),
          height: 60,
          width: double.infinity,
          child: Center(
              child: Text(
            value.toString(),
            style: GoogleFonts.openSans(),
          )));
    }

    //cupertino picker
    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: 216,
                padding: const EdgeInsets.only(top: 6.0),
                // The Bottom margin is provided to align the popup above the system navigation bar.
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                color: Colors.white,
                // Use a SafeArea widget to avoid system overlaps.
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ));
    }

    Widget timePicker() {
      return CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32,
        looping: true,
        // This is called when selected item is changed.
        onSelectedItemChanged: (int selectedItem) {
          ref.read(timeProvider.state).state = selectedItem + 1;
          ref.read(userProvider.state).state.restTime = selectedItem + 1;
        },
        children: List<Widget>.generate(500, (int index) {
          return Center(
            child: Text(
              (1 + index).toString(),
              style: GoogleFonts.karla(color: Colors.black),
            ),
          );
        }),
      );
    }

    final bool darkMode = ref.watch(isDarkMode);
    final time = ref.watch(timeProvider);

    return WillPopScope(
      //cuando se cierra esta madre
      onWillPop: () async {
        //!Actualizamos la data para guardarlo en shared preferencies
        ref
            .read(userProvider.state)
            .state
            .updateData(ref.read(userProvider.state).state);
            //!Actualizamos los contadores en ejecucion
        ref.read(timeGlobalProvider.state).state =
            ref.read(userProvider.state).state.restTime;
            //!Imprimimos que se hizo mas que nada 
        log((ref.read(userProvider.state).state.restTime).toString());
        return Navigator.canPop(context);
      },
      child: Scaffold(
        appBar: AppBar(actions: const []),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //!Gymbro
            const SizedBox(
              height: 50,
            ),
            const TextBox(texto: "GymBro's Name"),

            //GymBroName
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: gymBro,
                onChanged: (value) =>
                    ref.read(userProvider.state).state.gymBro = gymBro.text,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //!!RestTime
            const TextBox(texto: "Rest Time"),
            CupertinoButton(
                onPressed: () {
                  _showDialog(timePicker());
                },
                child: cupertinoWidget(time)),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              //!DARKMODE
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark Mode",
                    style: GoogleFonts.openSans(fontSize: 20),
                  ),
                  CupertinoSwitch(
                      value: darkMode,
                      onChanged: (value) => ref.read(isDarkMode.state).state =
                          !ref.read(isDarkMode.state).state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
