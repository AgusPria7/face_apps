import 'package:flutter/material.dart';
import 'package:face_apps/Sys/Frm/Frm.dart';
import 'package:face_apps/sys.dart';

class Cmb extends StatelessWidget {
  String name, label;
  List data;
  bool allowBlank;
  InputDecoration? decoration = const InputDecoration();
  String theme, value;
  Function(Object?)? onChanged;

  Cmb(
      {required this.name,
      required this.label,
      this.theme = 'M',
      this.value = '',
      this.onChanged,
      this.allowBlank = false,
      required this.data,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    var txtName = name;
    // Frm.setInitialValues({txtName: value});
    return FormBuilderDropdown(
      initialValue: value,
      name: txtName,
      style: TextStyle(fontSize: 16),
      validator: allowBlank
          ? null
          : FormBuilderValidators.compose([FormBuilderValidators.required()]),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      items: data
          .map(
            (rec) => DropdownMenuItem(
                value: rec,
                child: Text(
                  rec.toString(),
                  style: TextStyle(fontSize: 16),
                )),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
