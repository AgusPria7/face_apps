import 'package:flutter/material.dart';
import 'package:face_apps/Sys/Frm/Frm.dart';
import 'package:face_apps/sys.dart';

class Txt extends StatelessWidget {
  final maxLength, keyboardType;
  final minValue;
  bool allowBlank, readOnly, obscureText;
  String name, label, theme, value;
  String hint;
  String txtType;
  Function(String?)? onChanged;
  InputDecoration decoration;
  Widget? suffixIcon;
  Widget? icon;
  FontWeight fontWeight;
  final textCapitalization;
  final textInputAction;
  final inputFormatters;
  Txt(
      {required this.name,
      required this.label,
      this.hint = '',
      this.fontWeight = FontWeight.normal,
      this.theme = 'M',
      this.value = '',
      this.txtType = '',
      this.onChanged,
      this.maxLength,
      this.allowBlank = false,
      this.minValue,
      this.readOnly = false,
      this.obscureText = false,
      this.keyboardType,
      this.icon,
      this.suffixIcon,
      this.decoration = const InputDecoration(),
      this.textCapitalization = TextCapitalization.none,
      this.textInputAction,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    var txtName = name;

    var geaKeyboardType = keyboardType;
    var geaminLines = 1;
    var geamaxLines = 1;
    if (txtType == 'EDT') {
      geaKeyboardType = TextInputType.multiline;
      geaminLines = 2;
      geamaxLines = 5;
    }

    Frm.setInitialValues({txtName: value});
    return FormBuilderTextField(
      textAlign: TextAlign.left,
      name: txtName,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 18),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        icon: icon,
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 18),
      ),
      keyboardType: geaKeyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      inputFormatters: [],
      maxLength: maxLength,
      minLines: geaminLines,
      maxLines: geamaxLines,
      readOnly: readOnly,
      autofocus: false,
      validator:
          allowBlank ? null : FormBuilderValidators.compose([FormBuilderValidators.required()]),
      onChanged: onChanged,
      style: TextStyle(
          fontWeight: fontWeight, fontSize: 16),
    );
  }
}
