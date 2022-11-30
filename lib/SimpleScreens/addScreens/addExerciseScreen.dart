// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/ExerciseLabel.dart';
import 'package:gymap/States/states.dart';

import 'package:gymap/classes/localExercise.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:day_picker/day_picker.dart';

class AddExerciseScreen extends StatefulHookConsumerWidget {
  const AddExerciseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  //Controladores
  final nameEditingController = TextEditingController();
  final weightEditingController = TextEditingController();

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
  //! Funciones

  @override
  Widget build(BuildContext context) {
    //!PROVIDERS
    final name = ref.watch(nameAddProvider);
    final weight = ref.watch(weightAddProvider);
    final group = ref.watch(groupAddProvider);

    final sets = ref.watch(setsAddProvider);
    final reps = ref.watch(repsAddProvider);
    final color = ref.watch(colorAddProvider);

    var tester = LocalExercise(
        name: name,
        group: group,
        weight: weight,
        sets: sets,
        reps: reps,
        complete:false,
        color: color,
        days: diasString);

    //!Funciones
    //Toatadas
    void showToast(BuildContext context, mensaje) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );
    }

    bool isValid() {
      int validaciones = 0;
      //! Verificacion de Nombre 1
      if (nameEditingController.text.isNotEmpty) {
        validaciones++;
      } else {
        showToast(context, "Missed Name");
        return false;
      }
      //! Verificacion de Peso 2
      if (weightEditingController.text.isNotEmpty) {
        validaciones++;
      } else {
        showToast(context, "Missed Weight");
        return false;
      }
      //! Verificacion de Sets 3
      if (ref.read(setsAddProvider.state).state >= 1) {
        validaciones++;
      } else {
        showToast(context, "Missed Sets");
        return false;
      }
      //! Verificacion de Reps 4
      if (ref.read(repsAddProvider.state).state >= 1) {
        validaciones++;
      } else {
        showToast(context, "Missed Reps");
        return false;
      }
      //!Verificacion del tipo 5
      if (ref.read(groupAddProvider.state).state != "") {
        validaciones++;
      } else {
        showToast(context, "Missed Group");
        return false;
      }

      //! Verificacion de Dias 7
      int notSelectedDay = 0;
      for (DayInWeek dia in _days) {
        if (dia.isSelected == false) {
          notSelectedDay++;
        }
      }

      if (notSelectedDay >= 7) {
        showToast(context, "Missed at least a Day");
        return false;
      } else {
        validaciones++;
      }

      //! Si no LLegamos al menos a 6 no pasa
      if (validaciones <= 5) {
        return false;
      } else {
        return true;
      }
    }

    onsave() {
      if (isValid()) {
        //SI IS VALID ES VERDADERO ENTONCES PROCEDEMOS A HACER EL DESMADRE
        for (DayInWeek dia in _days) {
          if (dia.isSelected) {
            diasString.add(dia.dayName);
          }
        }
        //!Comprobamos que no exista con el mismo nombre
        if (ref
            .read(localExerciseProvider.notifier)
            .exist(nameEditingController.text)) {
          showToast(context, "Name Already taken");
        } else {
          ref.read(localExerciseProvider.notifier).addExercise(tester);
          ref.read(nameAddProvider.state).state = "";
          ref.read(groupAddProvider.state).state = "";
          ref.read(weightAddProvider.state).state = 1;
          ref.read(setsAddProvider.state).state = 1;
          ref.read(repsAddProvider.state).state = 1;
          Navigator.of(context).pop();
        }
      }
    }

    return Scaffold(
      //!Barra
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: GradientText(
            'New Exercise',
            style:
                GoogleFonts.karla(fontSize: 28.0, fontWeight: FontWeight.bold),
            colors: const [
              Color.fromARGB(255, 255, 17, 0),
              Color.fromARGB(255, 113, 50, 221)
            ],
          )),
      //! PARA QUE NO DE ERROR SE LE PONE UN SINGLE CHILD PARA QUE NO SE SALGA DE LA VENTANA
      body: Stack(alignment: Alignment.topCenter, children: [
        Positioned(
          top: 80,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 217, 217, 217),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                topLeft: Radius.circular(40.0),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                const SizedBox(
                  height: 60,
                ),
                fieldsWidget(color),
                const SizedBox(
                  height: 20,
                ),
                divisor(color),
                const SizedBox(
                  height: 10,
                ),
                groupWidget(group),
                setsWidget(sets),
                repsWidget(reps),
                divisor(color),
                daySelect(),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: colorSelect(color),
                ),
                MaterialButton(
                  onPressed: onsave,
                  color: Colors.black,
                  child: const Text("Save"),
                )
              ]),
            ),
          ),
        ),
        Positioned(top: 2, child: ExerciseWidget(exercise: tester)),
      ]),
    );
  }

  Widget fieldsWidget(color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          TextField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            style: GoogleFonts.karla(
                color: Colors.black, fontWeight: FontWeight.bold),
            controller: nameEditingController,
            onChanged: (value) {
              ref.read(nameAddProvider.state).state = value;
            },
            decoration: InputDecoration(
                filled: false,
                //Hint
                hintText: "Name",
                hintStyle: GoogleFonts.karla(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black26),
                //Bordes
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            style: GoogleFonts.karla(
                color: Colors.black, fontWeight: FontWeight.bold),
            controller: weightEditingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                filled: false,

                //Hint
                hintText: "Weight",
                hintStyle: GoogleFonts.karla(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black26),
                //Bordes
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
            onChanged: (value) {
              if (weightEditingController.text.isNotEmpty) {
                ref.read(weightAddProvider.state).state = int.parse(value);
              } else {
                ref.read(weightAddProvider.state).state = 0;
              }
            },
          ),
        ],
      ),
    );
  }

//! Widget de Tipos
  Widget typeWidget(color) {
    const List<Widget> types = <Widget>[
      Text('Dumbell'),
      Text('Barbell'),
      Text('Machine')
    ];
    const List<String> typeString = ['Dumbell', 'Barbell', 'Machine'];

    return Center(
      child: ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          ref.read(typeAddProvider.state).state = typeString[index];
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0;
              i < ref.read(selectedProvider.state).state.length;
              i++) {
            ref.read(selectedProvider.notifier).state[i] = i == index;
          }
          //print(ref.read(selectedProvider));
        },
        textStyle: GoogleFonts.karla(
          fontSize: 16,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: Colors.primaries[color],
        color: Colors.black,
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: ref.read(selectedProvider),
        children: types,
      ),
    );
  }

  Widget setsWidget(sets) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              "Sets",
              style: GoogleFonts.karla(
                  color: const Color.fromARGB(255, 41, 41, 41),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: CupertinoButton(
            child: Text("${sets}x"),
            onPressed: () => _showDialog(setsPicker()),
          ),
        ),
      ],
    );
  }

  Widget repsWidget(reps) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              "Reps",
              style: GoogleFonts.karla(
                  color: const Color.fromARGB(255, 41, 41, 41),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: CupertinoButton(
            child: Text("$reps Reps"),
            onPressed: () => _showDialog(repsPicker()),
          ),
        ),
      ],
    );
  }

  Widget groupWidget(group) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              "Group: ",
              style: GoogleFonts.karla(
                  color: const Color.fromARGB(255, 41, 41, 41),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: CupertinoButton(
            child: Text(group),
            onPressed: () => _showDialog(groupPicker()),
          ),
        ),
      ],
    );
  }

  //cupertino picker
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 200,
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

      children: List<Widget>.generate(10, (int index) {
        return Center(
          child: Text(
            (1 + index).toString(),
            style: GoogleFonts.karla(color: Colors.black),
          ),
        );
      }),
    );
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

  Widget groupPicker() {
    List groups = [
      'Chest',
      'Back',
      'Leg',
      'Arm',
    ];
    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32,
      looping: true,
      // This is called when selected item is changed.
      onSelectedItemChanged: (int selectedItem) {
        ref.read(groupAddProvider.state).state = groups[selectedItem];
      },

      children: List<Widget>.generate(groups.length, (int index) {
        return Center(
          child: Text(
            groups[index],
            style: GoogleFonts.karla(color: Colors.black),
          ),
        );
      }),
    );
  }

  Widget divisor(color) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
      ),
    );
  }

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
            unSelectedDayTextColor: Colors.black,
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

  Widget colorSelect(color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(12),
          border: Border.all(
            color: Colors.primaries[color],
            width: 2,
          ),
        ),
        child: ListView.builder(
          itemCount: Colors.accents.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: InkWell(
                onTap: () {
                  ref.read(colorAddProvider.state).state = index;
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.accents[index],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
