// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({
    Key? key,
    required this.string1,
    required this.string2,
    required this.color,
  }) : super(key: key);

  final String string1;
  final String string2;
  final int color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.primaries[color],
            boxShadow: [
              BoxShadow(
                color: Colors.accents[color],
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ]),
        child: Row(children: [
          Expanded(
            child: Center(
                child: Text(
              string1,
              style: GoogleFonts.karla(fontSize: 20),
            )),
          ),
          Expanded(
            child: Center(
              child: Text(
                string2,
                style: GoogleFonts.karla(fontSize: 20),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
