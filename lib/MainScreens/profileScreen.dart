// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymap/Extras/CustomClipper.dart';
import 'package:gymap/MainScreens/configScreen.dart';
import 'package:gymap/States/states.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String profilePicture =
        ref.read(userProvider.state).state.profilePicture;
    const double coverHeight = 150;
    const double profileHeight = 144;
    const double top = coverHeight - profileHeight;
    const double bottom = profileHeight / 1.2;
//!Providers
    final user = ref.read(userProvider.state).state.nickname;
    final family = ref.read(userProvider.state).state.family;
    final age = ref.read(userProvider.state).state.age;
    final weight = ref.read(userProvider.state).state.weight;
    final gender = ref.read(userProvider.state).state.gender;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const ConfigScreen())));
                },
                icon: const Icon(
                  Ionicons.aperture,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black26,
          child: Column(
            children: [
              topWidget(coverHeight, top, profilePicture, bottom),
              contentWidget(user, family, age, weight, gender),
            ],
          ),
        ));
  }

  Widget contentWidget(
      String nickname, String family, int age, int weight, String gender) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        nickname.toUpperCase(),
        style: GoogleFonts.karla(
            fontWeight: FontWeight.bold, fontSize: 35, letterSpacing: 4),
      ),
      const SizedBox(
        height: 10,
      ),
      divisor(2),
      const SizedBox(
        height: 10,
      ),
      Text(
        family,
        style: GoogleFonts.karla(
            fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1),
      ),
      const SizedBox(
        height: 100,
      ),
      SizedBox(
        height: 100,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(age.toString(),
                        style: GoogleFonts.karla(
                            color: Colors.white, fontSize: 24)),
                    Text("Years",
                        style: GoogleFonts.karla(
                            color: Colors.white38, fontSize: 16))
                  ]),
            ),
            //! Weight
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(weight.toString(),
                        style: GoogleFonts.karla(
                            color: Colors.white, fontSize: 24)),
                    Text("KG",
                        style: GoogleFonts.karla(
                            color: Colors.white38, fontSize: 16))
                  ]),
            ),
            //! Gender
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(gender,
                        style: GoogleFonts.karla(
                            color: Colors.white, fontSize: 24)),
                    Text(
                      "Gender",
                      style: GoogleFonts.karla(
                          color: Colors.white38, fontSize: 16),
                    )
                  ]),
            )
          ],
        ),
      )
    ]);
  }

  Stack topWidget(
      double coverHeight, double top, String profilePicture, double bottom) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: banner(coverHeight)),
        Positioned(top: top, child: profileImageWidget(profilePicture)),
      ],
    );
  }

  Widget banner(height) {
    return ClipPath(
        clipper: MyClipper(),
        //borderRadius: BorderRadius.only(bottomRight: Radius.circular(200),bottomLeft:Radius.circular(200)),
        child: Container(
          height: height,
          color: Colors.black,
        ));
  }

  Widget profileImageWidget(pp) {
    return CircleAvatar(
      radius: 105,
      backgroundColor: Colors.blueAccent,
      child: CircleAvatar(
        foregroundColor: Colors.white,
        radius: 100,
        backgroundImage: NetworkImage(pp),
      ),
    );
  }

  Widget divisor(color) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          height: 4,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 104, 29, 146),
            Colors.red,
          ], stops: [
            -1.0,
            1.0
          ])),
        ),
      ),
    );
  }
}
