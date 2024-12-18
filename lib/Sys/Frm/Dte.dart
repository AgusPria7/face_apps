import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Frm.dart';
import 'package:face_apps/sys.dart';

class Dte extends StatefulWidget {
  String name,label;
  bool? allowBlank;
  final bool disabled;

  dynamic time;
  String theme;
  DateTime? value;
  ValueChanged<DateTime?>? onChanged;
  InputDecoration? decoration = const InputDecoration();
  FormFieldValidator<DateTime>? validator;
  Dte(
      {required this.name,
        required this.label,
        this.theme = 'M',
        this.value,
        this.onChanged,
        this.allowBlank,
        this.disabled = false,
        this.validator,
        this.decoration});

  @override
  Dte_State createState() => Dte_State();
}

class Dte_State extends State<Dte> {
  late String txtName;

  @override
  Widget build(BuildContext context) {
    var txtName = widget.name;
    Frm.setInitialValues({txtName: widget.value});
    return FormBuilderDateTimePicker(
      name: txtName,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.calendar_month),
      ),
      inputType: InputType.date,
      format: DateFormat('dd MMMM yyyy'),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      validator: widget.validator,
      onChanged: widget.onChanged,
      valueTransformer: (val) {
        return val.toString();
      },
      style: TextStyle(fontSize: 16, color: sys.theme),
      //onChanged: widget.onChanged,
    );
  }
}
