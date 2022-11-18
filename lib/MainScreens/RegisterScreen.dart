// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, file_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/CustomClipper.dart';
import 'package:gymap/Extras/CustomRadio.dart';
import 'package:gymap/States/states.dart';
import 'package:gymap/classes/gender.dart';
import 'package:gymap/classes/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class RegisterScreen extends HookConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  RegisterScreen({super.key});
  //Controlles
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final mailController = TextEditingController();
  String gender = 'Male';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Providers
    final age = ref.watch(ageRegisterProvider);
    final weight = ref.watch(weightRegisterProvider);
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

    Widget agePicker() {
      return CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32,
        looping: true,
        // This is called when selected item is changed.
        onSelectedItemChanged: (int selectedItem) {
          ref.read(ageRegisterProvider.state).state = selectedItem;
        },
        children: List<Widget>.generate(99, (int index) {
          return Center(
            child: Text(
              index.toString(),
              style: GoogleFonts.karla(color: Colors.black),
            ),
          );
        }),
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
        children: List<Widget>.generate(300, (int index) {
          return Center(
            child: Text(
              index.toString(),
              style: GoogleFonts.karla(color: Colors.black),
            ),
          );
        }),
      );
    }

    Widget widgetPickers(age, weight) {
      return Column(
        children: [
          //!Weight
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Weight: ",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              CupertinoButton(
                child: Text(weight.toString()),
                onPressed: () => _showDialog(weightPicker()),
              ),
            ],
          ),
          //!Age
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Age: ",
                  style: GoogleFonts.karla(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              CupertinoButton(
                child: Text(age.toString()),
                onPressed: () => _showDialog(agePicker()),
              ),
            ],
          ),
        ],
      );
    }

    Widget genderWidget() {
      final genders = ref.watch(genderProvider);

      return SizedBox(
        height: 90,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: genders.length,
            itemBuilder: (context, index) {
              return InkWell(
                splashColor: Colors.pinkAccent,
                onTap: () {
                  ref.read(genderProvider.notifier).update(index);
                  gender = ref.read(genderProvider)[index].name;
                },
                child: CustomRadio(genders[index]),
              );
            }),
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: <Widget>[
        banner(),
        registerText(),
        const SizedBox(
          height: 20,
        ),
        textfields(),
        const SizedBox(
          height: 10,
        ),
        genderWidget(),
        widgetPickers(age, weight),
        const SizedBox(
          height: 10,
        ),
        divisor(1),
        MaterialButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              if (ref.read(ageRegisterProvider.state).state < 10) {
                showToast(context, "No Way you are that Young");
              } else if (ref.read(weightRegisterProvider.state).state < 50) {
                showToast(context, "You sure?... okay");
              }
              showToast(context, "You forgot something");
              return;
            } else {
              registerButton(
                  userNameController.text,
                  passwordController.text,
                  "Novice",
                  gender,
                  "",
                  ref.read(weightRegisterProvider.state).state,
                  ref.read(ageRegisterProvider.state).state);
              Navigator.of(context).pop();
            }
          },
          child: const Text("Register"),
        )
      ]),
    ));
  }

  Widget textfields() {
    bool isEmail(String em) {
      bool emailValid =
          RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
              .hasMatch(em);

      return emailValid;
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            //!User
            TextFormField(
                controller: userNameController,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  label: Text("User"),
                  hintText: "User",
                  prefix: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.person),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isNotEmpty && value.length > 2) {
                    return null;
                  } else if (value.length < 3 && value.isNotEmpty) {
                    return "No way this is your name";
                  } else {
                    return "Give us a UserName!";
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            //!Password
            TextFormField(
              controller: passwordController,
              textAlignVertical: TextAlignVertical.center,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text("Password"),
                hintText: "Password",
                prefix: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.lock),
                ),
              ),
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                } else if (value.length < 5 && value.isNotEmpty) {
                  return "Write a larger Password";
                } else {
                  return "This Cant be Blank!";
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            //!Email
            TextFormField(
              controller: mailController,
              textAlignVertical: TextAlignVertical.center,
              obscureText: false,
              decoration: const InputDecoration(
                label: Text("e-Mail"),
                hintText: "e-Mail",
                prefix: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.email),
                ),
              ),
              validator: (value) {
                if (value!.isNotEmpty) {
                  if (!isEmail(value)) {
                    return "Email Is Not Valid";
                  }
                } else {
                  return "This Cant be Blank!";
                }
                return null;
              },
            ),
          ],
        ),
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

  Widget banner() {
    return ClipPath(
      clipper: MyClipper(),
      //borderRadius: BorderRadius.only(bottomRight: Radius.circular(200),bottomLeft:Radius.circular(200)),
      child: Image.network(
        'https://media.tenor.com/dtWcrQzDfsAAAAAC/the-simpsons-homer-simpson.gif',
      ),
    );
  }

  Widget registerText() {
    return GradientText(
      'Register',
      style: GoogleFonts.karla(
          fontSize: 28.0, fontWeight: FontWeight.bold, letterSpacing: 2),
      colors: const [Colors.pink, Colors.purple],
    );
  }

  void registerButton(u, ps, f, g, p, w, a) async {
    var usuario = User(
        username: u,
        nickname: u,
        password: ps,
        family: f,
        gender: g,
        profilePicture:
            "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80",
        weight: w,
        age: a);

    //AHORA LLAMAMOS A LAS PREFS COMO SIEMPRE
    final prefs = await SharedPreferences.getInstance();
    //MANDAMOS A GUARDAR EL DATO USUARIO
    var jsonstring = jsonEncode(usuario);
    await prefs.setString('user', jsonstring);
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
