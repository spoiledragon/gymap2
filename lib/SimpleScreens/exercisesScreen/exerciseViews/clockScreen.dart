// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymap/Extras/clock.dart';

import 'package:gymap/Extras/secondClock.dart';
import 'package:gymap/MainScreens/configScreen.dart';

import 'package:gymap/States/states.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:recase/recase.dart';

class ClocksScreen extends ConsumerStatefulWidget {
  const ClocksScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClocksScreenState();
}

class _ClocksScreenState extends ConsumerState<ClocksScreen> {
  @override
  Widget build(BuildContext context) {
//le pondremos el nombre del ejercicio que estemos trackeando
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: const [Clock(color: 1), SecondClock(color: 2)],
      ),
    );
  }
}
