import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:face_apps/Sys/Frm/Frm.dart';

class Jam extends StatefulWidget {
  String name, label;
  bool? allowBlank;
  final bool disabled;

  dynamic time;
  String theme;
  DateTime? value;
  ValueChanged<DateTime?>? onChanged;
  InputDecoration? decoration = const InputDecoration();
  FormFieldValidator<DateTime>? validator;
  Jam(
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
  Jam_State createState() => Jam_State();
}

class Jam_State extends State<Jam> {
  late String txtName;

  @override
  Widget build(BuildContext context) {
    var txtName = widget.name;
    Frm.setInitialValues({txtName: widget.value});
    return FormBuilderDateTimePicker(
        name: txtName,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.access_time_outlined),
          labelText: widget.label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        inputType: InputType.time,
        format: DateFormat('HH:mm'),
        validator: widget.validator,
        onChanged: widget.onChanged,
        valueTransformer: (val) {
          String jam = '';
          if (val != null) {
            DateFormat dateFormat = DateFormat("HH:mm");
            jam = dateFormat.format(val);
          }
          return jam;
        },
        transitionBuilder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        }

        //onChanged: widget.onChanged,
        );
  }
}
