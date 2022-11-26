// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gymap/SimpleScreens/RegisterScreens/firstRegisterSCreen.dart';
import 'package:gymap/SimpleScreens/RegisterScreens/secondRegisterScreen.dart';
import 'package:gymap/SimpleScreens/RegisterScreens/thirdRegisterScreen.dart';
import 'package:gymap/States/states.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IndexedRegisterScreens extends ConsumerStatefulWidget {
  const IndexedRegisterScreens({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IndexedRegisterScreensState();
}

class _IndexedRegisterScreensState
    extends ConsumerState<IndexedRegisterScreens> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = ref.watch(controllerRegisterProvider);
    final ScreensPages = [
      FirstScreen(),
      const SecondScreen(),
      const ThirdScreen(),
    ];
    return Scaffold(
      body: Stack(children: [
        PageView(
          scrollDirection: Axis.vertical,
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: ScreensPages,
        ),
        Container(
          alignment: const Alignment(0, 0.9),
          child: SmoothPageIndicator(
            controller: controller,
            count: 3,
            effect: const ScrollingDotsEffect(
              dotColor: Colors.white38,
              activeDotColor: Colors.deepOrange,
              dotHeight: 16,
              dotWidth: 16,
            ),
          ),
        )
      ]),
    );
  }
}
