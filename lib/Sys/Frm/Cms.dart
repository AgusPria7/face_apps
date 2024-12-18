import 'package:flutter/material.dart';
import 'package:face_apps/Sys/Frm/CmsX.dart';
import 'package:face_apps/Sys/Frm/Frm.dart';

class Cms extends StatefulWidget {
  String name, label;
  List data;
  bool allowBlank;
  InputDecoration? decoration = const InputDecoration();
  List<dynamic>? value;
  int maxLength;
  Cms(
      {required this.name,
      required this.label,
      this.value,
      this.maxLength = 20,
      this.allowBlank = true,
      required this.data,
      this.decoration});

  @override
  _CmsState createState() => _CmsState();
}

class _CmsState extends State<Cms> {
  @override
  Widget build(BuildContext context) {
    var txtName = widget.name;

    Frm.setInitialValues({txtName: widget.value});
    return FormBuilderField(
      name: txtName,
      onChanged: (value) {
      },
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      builder: (FormFieldState<dynamic> field) {
        return MultiSelectX(
          titleText: widget.label,
          dataSource: widget.data,
          textField: 'display_field',
          valueField: 'value_field',
          filterable: true,
          required: widget.allowBlank,
          initialValue: widget.value,
          maxLength: widget.maxLength,
          value: field.value,
          change: (value) {
            var v = '[';
            for (var i = 0; i < value.length; i++) {
              v = v + '"' + value[i].toString() + '"';
              if (i < (value.length - 1)) {
                v = v + ',';
              }
            }
            v = v + ']';
            field.didChange(v);
          },
        );
      },
    );
  }
}
