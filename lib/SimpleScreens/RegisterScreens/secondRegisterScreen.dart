// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/genderWidget.dart';
import 'package:gymap/States/states.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SecondScreen extends ConsumerStatefulWidget {
  const SecondScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SecondScreenState();
}

class _SecondScreenState extends ConsumerState<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    onGenderChange(value) {
      if (value == 0) {
        ref.read(genderRegisterProvider.state).state = "Female";
      } else if (value == 1) {
        ref.read(genderRegisterProvider.state).state = "Male";
      }

      log(value.toString());
    }

    //Providers
    final PageController controller = ref.watch(controller2RegisterProvider);
    final genderText = ref.watch(genderRegisterProvider);
    final weightText = ref.watch(weightRegisterProvider);
    final ageText = ref.watch(ageRegisterProvider);

    //Tostada
    void showToast(BuildContext context, mensaje) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(mensaje),
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

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //todo esto para poder elegir un genero
          genderSelecterWidget(context, controller, onGenderChange, genderText),
          const SizedBox(
            height: 50,
          ),
          const SelecterWidget(),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: weightWidget(_showDialog, weightText),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ageWidget(_showDialog, ageText),
          ),
          const SizedBox(
            height: 50,
          ),
          botonWidget(showToast, context),
        ],
      ),
    );
  }

  MaterialButton botonWidget(
      void showToast(BuildContext context, dynamic mensaje),
      BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (ref.read(weightRegisterProvider.state).state <= 40) {
          showToast(context, "Ok?");
        }
        if (ref.read(ageRegisterProvider.state).state <= 12) {
          showToast(context, "Imposible...");
        }
        if (ref.read(ageRegisterProvider.state).state >= 13) {
          ref.read(controllerRegisterProvider.state).state.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        }
      },
      child: const Text("Finish"),
    );
  }

  SizedBox genderSelecterWidget(BuildContext context, PageController controller,
      Null onGenderChange(dynamic value), String genderText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Stack(children: [
        PageView(
            controller: controller,
            children: [
              femaleContainer(),
              maleContainer(),
            ],
            onPageChanged: (value) => onGenderChange(value)),
        Container(
          alignment: const Alignment(0, 0.9),
          child: SmoothPageIndicator(
            controller: controller,
            count: 2,
            effect: const WormEffect(
              activeDotColor: Colors.deepPurple,
              dotHeight: 16,
              dotWidth: 16,
              type: WormType.thin,
            ),
          ),
        ),
        Container(
            alignment: const Alignment(0, 0.7),
            child: Text(
              genderText,
              style:
                  GoogleFonts.karla(fontSize: 24, fontWeight: FontWeight.bold),
            )),
      ]),
    );
  }

  Row weightWidget(void Function(Widget child) showDialog, int weightText) {
    return Row(
      children: [
        const Expanded(child: Center(child: Text("Weight : "))),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: () {
              showDialog(weightPicker());
            },
            child: Text(weightText.toString()),
          ),
        ),
      ],
    );
  }

  Row ageWidget(void Function(Widget child) showDialog, int ageText) {
    return Row(
      children: [
        const Expanded(child: Center(child: Text("Age : "))),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: () {
              showDialog(agePicker());
            },
            child: Text(ageText.toString()),
          ),
        ),
      ],
    );
  }

  Container maleContainer() {
    return Container(
      color: Colors.black,
      child: const Icon(
        Ionicons.male,
        size: 100,
      ),
    );
  }

  Container femaleContainer() {
    return Container(
      color: Colors.black,
      child: const Icon(
        Ionicons.female,
        size: 100,
      ),
    );
  }

  Widget weightPicker() {
    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32,
      looping: true,
      // This is called when selected item is changed.
      onSelectedItemChanged: (int selectedItem) {
        ref.read(weightRegisterProvider.state).state = selectedItem;
      },
      children: List<Widget>.generate(200, (int index) {
        return Center(
          child: Text(
            index.toString(),
            style: GoogleFonts.karla(color: Colors.black),
          ),
        );
      }),
    );
  }

  Widget agePicker() {
    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32,
      looping: true,
      // This is called when selected item is changed.
      onSelectedItemChanged: (int selectedItem) {
        ref.read(ageRegisterProvider.state).state = selectedItem + 15;
      },
      children: List<Widget>.generate(100, (int index) {
        return Center(
          child: Text(
            (15 + index).toString(),
            style: GoogleFonts.karla(color: Colors.black),
          ),
        );
      }),
    );
  }
}