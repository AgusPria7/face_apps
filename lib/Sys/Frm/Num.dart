import 'package:flutter/material.dart';
import 'package:face_apps/Sys/Frm/Frm.dart';
import 'package:face_apps/sys.dart';

class Num extends StatelessWidget {
  final name, label, maxLength, keyboardType, decimal;
  final minValue;
  final value;
  final hint;
  bool allowBlank;
  Function(String?)? onChanged;
  final suffixIcon;
  final inputFormatter;

  Num(
      {required this.name,
      required this.label,
      this.maxLength = 16,
      this.allowBlank = true,
      this.minValue,
      this.suffixIcon,
      this.onChanged,
      this.value,
      this.hint,
      this.inputFormatter,
      this.keyboardType,
      this.decimal = 0});

  @override
  Widget build(BuildContext context) {
    var txtName = name;
    return FormBuilderTextField(
      name: txtName,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 16),
      ),
      inputFormatters: inputFormatter,
      keyboardType: TextInputType.number,
      //TODO: validator belum bener waktu save kalo null
      validator: allowBlank
          ? null
          : FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(maxLength),
            ]),
      valueTransformer: (val) {
        if (val != null) {
          return val.replaceAll(',', '');
        }
      },
      style: TextStyle(fontSize: 16),
      onChanged: onChanged,
    );
  }
}
