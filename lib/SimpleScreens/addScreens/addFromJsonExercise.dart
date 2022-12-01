// ignore_for_file: file_names

import 'package:day_picker/day_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/textBoxWidget.dart';
import 'package:gymap/States/states.dart';
import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AddFromJsonScreen extends ConsumerStatefulWidget {
  final String name;
  final String group;
  final int color;
  const AddFromJsonScreen(
      {super.key,
      required this.name,
      required this.group,
      required this.color});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddFromJsonScreenState();
}

class _AddFromJsonScreenState extends ConsumerState<AddFromJsonScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  //!Lista de dias
  final List<DayInWeek> _days = [
    DayInWeek(
      "Monday",
    ),
    DayInWeek(
      "Tuesday",
    ),
    DayInWeek(
      "Wednesday",
    ),
    DayInWeek(
      "Thursday",
    ),
    DayInWeek(
      "Friday",
    ),
    DayInWeek(
      "Saturday",
    ),
    DayInWeek(
      "Sunday",
    ),
  ];
  //!Dias seleccionados
  List<String> diasString = [];

  @override
  //!Front End

  Widget build(BuildContext context) {
    //formkey

    //!Providers
    final reps = ref.watch(repsAddProvider);
    final sets = ref.watch(setsAddProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GradientText(
          widget.name,
          style:
              GoogleFonts.karla(letterSpacing: 2, fontWeight: FontWeight.bold),
          colors: const [Colors.blue, Colors.purple, Colors.red],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),

            const TextBox(texto: "Wich Days"),
            daySelect(),

            const TextBox(texto: "Weight"),
            const SizedBox(
              height: 10,
            ),
            formInput(_formKey, _weightController),
            const SizedBox(
              height: 20,
            ),
            const TextBox(texto: "Reps"),
            //Los Reps
            CupertinoButton(
                onPressed: () {
                  _showDialog(repsPicker());
                },
                child: cupertinoWidget(reps)),
            //los Sets
            const TextBox(texto: "Sets"),
            CupertinoButton(
                onPressed: () {
                  _showDialog(setsPicker());
                },
                child: cupertinoWidget(sets)),

            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget formInput(
      GlobalKey<FormState> formKey, TextEditingController weightController) {
    return Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: TextFormField(
            controller: weightController,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.none,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              //Hint
              hintText: "Weight",
              hintStyle:
                  GoogleFonts.openSans(fontSize: 14, color: Colors.white),
              //Bordes
            ),
            onChanged: (value) {
              if (weightController.text.isNotEmpty) {
                ref.read(weightAddProvider.state).state = int.parse(value);
              } else {
                ref.read(weightAddProvider.state).state = 0;
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "... Really?";
              }
              return null;
            },
          ),
        ));
  }

  Container cupertinoWidget(int reps) {
    return Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 37, 37, 37),
            borderRadius: BorderRadius.circular(20)),
        height: 60,
        width: double.infinity,
        child: Center(
            child: Text(
          reps.toString(),
          style: GoogleFonts.openSans(),
        )));
  }

  Padding basicContainer(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 37, 37, 37),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(
          value,
          style:
              GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w500),
        )),
      ),
    );
  }

  MaterialButton saveButton() => MaterialButton(
        //convertimos los dias a strings
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            showToast(context, "You forgot something");
            return;
          }
          int contador = 0;
          for (DayInWeek dia in _days) {
            if (dia.isSelected) {
              diasString.add(dia.dayName);
              contador++;
            }
          }

          //Creamos el eobjeto ejercicio
          if (contador == 0) {
            showToast(context, "Select at least a Day");
          } else {
            LocalExercise ejercicio = LocalExercise(
                name: widget.name,
                group: widget.group,
                weight: ref.read(weightAddProvider.state).state,
                sets: ref.read(setsAddProvider.state).state,
                reps: ref.read(repsAddProvider.state).state,
                color: widget.color,
                days: diasString,
                complete: false,
                completeds: []);
            //!Agregamos el ejercicio al provider

            bool saved =
                ref.read(localExerciseProvider.notifier).addExercise(ejercicio);
            if (!saved) {
              showToast(context, "There is Already an Exercise with this Name");
            }
            //!Restablecemos todos los providers
            ref.read(nameAddProvider.state).state = "";
            ref.read(groupAddProvider.state).state = "";
            ref.read(weightAddProvider.state).state = 1;
            ref.read(setsAddProvider.state).state = 1;
            ref.read(repsAddProvider.state).state = 1;
            Navigator.of(context).pop();
          }
        },
        color: Colors.amberAccent,
        child: const Text("Save"),
      );

  //Widgets de dia

  Widget daySelect() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(12),
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: SelectWeekDays(
            backgroundColor: Colors.transparent,
            unSelectedDayTextColor: Colors.white,
            daysBorderColor: const Color.fromARGB(255, 139, 139, 139),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            days: _days,
            onSelect: (values) {
              //print(values);
            }),
      ),
    );
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

  Widget repsPicker() {
    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32,
      looping: true,
      // This is called when selected item is changed.
      onSelectedItemChanged: (int selectedItem) {
        ref.read(repsAddProvider.state).state = selectedItem + 1;
      },
      children: List<Widget>.generate(50, (int index) {
        return Center(
          child: Text(
            (1 + index).toString(),
            style: GoogleFonts.karla(color: Colors.black),
          ),
        );
      }),
    );
  }

  Widget setsPicker() {
    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32,
      looping: true,
      // This is called when selected item is changed.
      onSelectedItemChanged: (int selectedItem) {
        ref.read(setsAddProvider.state).state = selectedItem + 1;
      },
      children: List<Widget>.generate(100, (int index) {
        return Center(
          child: Text(
            (1 + index).toString(),
            style: GoogleFonts.karla(color: Colors.black),
          ),
        );
      }),
    );
  }

  void showToast(BuildContext context, mensaje) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }
}
