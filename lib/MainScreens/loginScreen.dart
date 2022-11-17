// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/CustomClipper.dart';
import 'package:gymap/MainScreens/RegisterScreen.dart';
import 'package:gymap/MainScreens/homeScreen.dart';
import 'package:gymap/classes/user.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

final obscureTextProvider = StateProvider<bool>((ref) {
  return true;
});

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Controladores
    final userNameController = TextEditingController();
    final passwordController = TextEditingController();

    //!Por implementar

    void isValid() async {
      final prefs = await SharedPreferences.getInstance();
      final jsondata = jsonDecode(prefs.getString('user') ?? "");

      final User user = User.fromJson(jsondata);

      if (userNameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        if (userNameController.text == user.nickname &&
            passwordController.text == user.password) {
          //!SI ES VERDAD QUE ES CORRECTO LOS DATOS

          //AHORA LLAMAMOS A LAS PREFS COMO SIEMPRE

          //MANDAMOS A GUARDAR EL DATO USUARIO
          // await prefs.setString('user', jsonEncode(user));
          //MANDAMOS A GUARDAR QUE SI ESTA LOGEADO
          await prefs.setBool('isLoged', true);
          //EMPUJAMOS LA MATERIAL PAGE CON EL DATO DEL USERNAME CONTROLLER PORQUE SI
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    user,
                  )));
        }
      }
    }

    //TextBox del usuario
    Widget userTextBox() {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: userNameController,
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
                label: Text("User"),
                hintText: "User",
                prefix: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.person),
                )),
          ));
    }

    Widget passwordTextBox() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: passwordController,
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration(
            alignLabelWithHint: true,
            label: Text("Password"),
            hintText: "Password",
            prefix: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.lock),
            ),
          ),
        ),
      );
    }

    Widget boton() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: MaterialButton(
          onPressed: () {
            isValid();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text("Log In"),
              Icon(Icons.skip_next),
            ],
          ),
        ),
      );
    }

    Widget banner() {
      return ClipPath(
        clipper: MyClipper(),
        //borderRadius: BorderRadius.only(bottomRight: Radius.circular(200),bottomLeft:Radius.circular(200)),
        child: Image.asset(
          'lib/Assets/images/login.jpg',
        ),
      );
    }

    Widget loginText() {
      return GradientText(
        'Welcome',
        style: GoogleFonts.karla(fontSize: 28.0, fontWeight: FontWeight.bold),
        colors: const [Colors.blue, Colors.purple],
      );
    }

//aqui va la pagina
    return SafeArea(
      child: Scaffold(
        //header: banner(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Columna para contener el banner principal
              banner(),
              const SizedBox(
                height: 40,
              ),
              Center(child: loginText()),
              const SizedBox(
                height: 55,
              ),
              userTextBox(),
              const SizedBox(
                height: 40,
              ),
              passwordTextBox(),
              const SizedBox(
                height: 50,
              ),
              Center(child: boton()),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a memeber ?",
                      style: GoogleFonts.karla(fontSize: 14)),
                  CupertinoButton(
                    child: Text("Register",
                        style: GoogleFonts.karla(fontSize: 14)),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen())),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
