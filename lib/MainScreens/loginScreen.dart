// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/CustomClipper.dart';
import 'package:gymap/MainScreens/homeScreen.dart';
import 'package:gymap/SimpleScreens/RegisterScreens/indexedScreens.dart';
import 'package:gymap/States/states.dart';
import 'package:gymap/classes/exercise.dart';
import 'package:gymap/classes/user.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

final obscureTextProvider = StateProvider<bool>((ref) {
  return true;
});

class LoginPage extends HookConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  LoginPage({super.key});
  @override
  //Controladores
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  Widget build(BuildContext context, WidgetRef ref) {
    //FUNCION PARA TRAER TODOS LOS EJERCICIOS A LOS JSON Y GUARDALOS EN EL PROVIDER
    Future<void> readJson() async {
      if (ref.read(isReadedProvider) == false) {
        final String response =
            await rootBundle.loadString('lib/Assets/jsons/exercises.json');

        final data = await json.decode(response);
        //POR CADA EJERCICIO LO GUARDAMOS
        for (var exe in data) {
          Exercises x = Exercises.fromJson(exe);
          ref.read(exercisesProvider.notifier).addExercise(x);
          //print(x.group);
        }
        ref.read(isReadedProvider.state).state = true;
      }
    }

    void showToast(BuildContext context, mensaje) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );
    }

    //!Funcion que trae de los shared preferences

    //Funcion para comprobar la validacion de los datos
    void isValid() async {
      //llamamos a las prefs de shared preferences
      final prefs = await SharedPreferences.getInstance();
      //Comprobaremos si de verdad hay alguien Registrado

      final isLoged = prefs.getBool("isLoged") ?? false;
      if (!isLoged) {
        showToast(context, "No hay Usuarios registrados");
        return;
      }

      if (!_formKey.currentState!.validate()) {
        showToast(context, "Hmmm...");
        return;
      }

      //traemos el objeto user si es que lo encuentra, si no , me trae un string vacio
      final jsondata = jsonDecode(prefs.getString('user') ?? "");
      //guardamos el usuario desde el objeto json
      final User user = User.fromJson(jsondata);
      //si no estan vacio los textinput se lo decimos

      if (userNameController.text == user.nickname &&
          passwordController.text == user.password) {
        //!SI ES VERDAD QUE ES CORRECTO, Traemos todos los ejercicios del json y los que ya esten guardados
        readJson();
        //como solo se logea la primera vez pues ni para que traigo datos incesesarios
        //getExercisesFromPreferences();

        //MANDAMOS A GUARDAR QUE SI ESTA LOGEADO para no tener que pasar por esta pagina jamas
        await prefs.setBool('isLoged', true);
        ref.read(userProvider.state).state = user;
        //EMPUJAMOS LA MATERIAL PAGE CON EL DATO DEL USERNAME CONTROLLER PORQUE SI
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        showToast(context, "Datos Incorrectos");
      }
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

    void guestLog(context) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      ref.read(userProvider.state).state.nickname = "Random UwU";
      readJson();
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
              const SizedBox(height: 40),
              Center(child: loginText()),
              const SizedBox(height: 40),
              inputs(userNameController, passwordController),
              const SizedBox(height: 50),
              Center(child: boton()),
              const SizedBox(height: 15),
              registerLabel(context),
              Center(
                child: CupertinoButton(
                  child: const Text("Not log and be Guest"),
                  onPressed: () {
                    guestLog(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row registerLabel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Not a memeber ?", style: GoogleFonts.karla(fontSize: 14)),
        CupertinoButton(
          child: Text("Register", style: GoogleFonts.karla(fontSize: 14)),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const IndexedRegisterScreens())),
        )
      ],
    );
  }

  //inputs
  Form inputs(TextEditingController userNameController,
      TextEditingController passwordController) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              TextFormField(
                controller: userNameController,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text("User"),
                  hintText: "User",
                  prefix: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.person),
                  ),
                ),
                validator: (value) {
                  if (value!.isNotEmpty && value.length > 2) {
                    return null;
                  } else if (value.length < 3 && value.isEmpty) {
                    return "... Really?";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: passwordController,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  label: Text("Password"),
                  hintText: "Password",
                  prefix: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.lock),
                  ),
                ),
                validator: (value) {
                  if (value!.isNotEmpty && value.length > 2) {
                    return null;
                  } else if (value.length < 3 && value.isEmpty) {
                    return "Pls";
                  }
                  return null;
                },
              )
            ],
          ),
        ));
  }
}
