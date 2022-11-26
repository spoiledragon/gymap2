// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gymap/Extras/CustomRadio.dart';
import 'package:gymap/States/states.dart';
import 'package:gymap/classes/gender.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelecterWidget extends ConsumerStatefulWidget {
  const SelecterWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelecterWidgetState();
}

class _SelecterWidgetState extends ConsumerState<SelecterWidget> {
  @override
  Widget build(BuildContext context) {
    List<Selecter> selecter = ref.watch(selecterProvider);
    final singleSelecter = ref.watch(familyegisterProvider);
    return SizedBox(
      height: 90,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: selecter.length,
          itemBuilder: (context, index) {
            return InkWell(
              splashColor: Colors.pinkAccent,
              onTap: () {
                ref.read(selecterProvider.notifier).update(index);
                ref.read(familyegisterProvider.state).state =
                    ref.read(selecterProvider.notifier).getName(index);
              },
              child: CustomRadio(selecter[index]),
            );
          }),
    );
  }
}
