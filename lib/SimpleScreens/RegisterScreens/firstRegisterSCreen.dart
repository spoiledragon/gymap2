// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, file_names

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/States/states.dart';
import 'package:gymap/classes/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class FirstScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  FirstScreen({super.key});
  //Controlles
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final mailController = TextEditingController();
  String gender = 'Male';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  onChanged: (value) =>
                      ref.read(userRegisterProvider.state).state = value,
                  decoration: const InputDecoration(
                    label: Text("User"),
                    hintText: "User",
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
                height: 20,
              ),
              //!Password
              TextFormField(
                controller: passwordController,
                textAlignVertical: TextAlignVertical.center,
                obscureText: true,
                onChanged: (value) =>
                    ref.read(passwordRegisterProvider.state).state = value,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text("Password"),
                  hintText: "Password",
                  prefix: Icon(Icons.lock),
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
                height: 20,
              ),
              //!Email
              TextFormField(
                controller: mailController,
                textAlignVertical: TextAlignVertical.center,
                obscureText: false,
                textInputAction: TextInputAction.next,
                onChanged: (value) =>
                    ref.read(mailRegisterProvider.state).state = value,
                decoration: const InputDecoration(
                  label: Text("e-Mail"),
                  hintText: "e-Mail",
                  prefix: Icon(Icons.email),
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

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //banner(),
          GradientText(
            "Hey There",
            style: GoogleFonts.karla(fontWeight: FontWeight.bold, fontSize: 24),
            colors: const [Colors.purple, Colors.red, Colors.blue],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Create an Account",
            style: GoogleFonts.karla(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 60,
          ),
          textfields(),
          const SizedBox(
            height: 20,
          ),
          //genderWidget(),
          //widgetPickers(age, weight),
          //divisor(1),
          MaterialButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                showToast(context, "You forgot something");
                return;
              } else {
                ref.read(controllerRegisterProvider.state).state.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              }
            },
            child: const Text("Next"),
          )
        ]);
  }

  Widget registerText() {
    return GradientText(
      'Create an Account',
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
