// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymap/Extras/CustomClipper.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends HookConsumerWidget {
  
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget profileImageWidget() {
      return CircleAvatar(
        radius: 125,
        backgroundColor: Colors.teal,
        child: CircleAvatar(
          foregroundColor: Colors.white,
          radius: 120,
          backgroundImage: NetworkImage(""),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.grey),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              profileImageWidget(),
              Center(child: Text("")),
            ]),
      ),
    );
  }

  Widget banner() {
    return ClipPath(
        clipper: MyClipper(),
        //borderRadius: BorderRadius.only(bottomRight: Radius.circular(200),bottomLeft:Radius.circular(200)),
        child: Container(
          height: 200,
          color: Colors.grey,
        ));
  }
}
