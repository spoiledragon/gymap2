// ignore_for_file: must_be_immutable, prefer_final_fields, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:gymap/classes/gender.dart';

class CustomRadio extends StatefulWidget {
  Selecter _gender;

  CustomRadio(this._gender);

  @override
  State<CustomRadio> createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color:
            widget._gender.isSelected ? const Color(0xFF3B4257) : Colors.white,
        child: Container(
          height: 40,
          width: 80,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                widget._gender.name,
                style: TextStyle(
                    color:
                        widget._gender.isSelected ? Colors.white : Colors.grey),
              )
            ],
          ),
        ));
  }
}
