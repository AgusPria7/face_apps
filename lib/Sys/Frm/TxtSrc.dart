import 'package:flutter/material.dart';
import 'package:face_apps/Sys/Frm/Frm.dart';
import 'package:face_apps/Sys/Grd/Grd.dart';
import 'package:face_apps/sys.dart';

void _doNothing(dynamic _) {}

class TxtSrc extends StatelessWidget {
  final name, label, maxLength, keyboardType;
  final minValue;
  bool? allowBlank;
  String theme, value;
  String url;
  String readUrl;
  String rawName;
  final List<Map> filters;
  ValueChanged<dynamic>? onChanged;
  InputDecoration? decoration = const InputDecoration();
  final Function(Map<String, dynamic> values) onSelect;

  TxtSrc(
      {required this.name,
      required this.label,
      this.rawName = '',
      this.theme = 'M',
      this.value = '',
      this.maxLength,
      this.allowBlank,
      this.minValue,
      this.keyboardType,
      this.decoration,
      this.onChanged,
      this.onSelect = _doNothing,
      this.url = '',
      this.readUrl = 'readTxt',
      required this.filters});

  @override
  Widget build(BuildContext context) {
    var txtName = name;
    var txtNameRaw = txtName + '_raw';
    if (rawName != '') {
      txtNameRaw = rawName;
    }

    Frm.setFkTxtSrc({txtName: '#'});

    decoration = InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 18, color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: IconButton(
        icon: Icon(Icons.navigate_next),
        onPressed: () {},
      ),
    );
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
          child: FormBuilderTextField(
            initialValue: value,
            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
            style: TextStyle(fontSize: 16, color: sys.theme),
              name: txtNameRaw,
              decoration: decoration!,
              keyboardType: keyboardType,
              maxLength: maxLength),
        ),
      ),
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final Map<String, dynamic>? rec = await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => _grid(context)));
        if (rec != null) {
          if (onChanged != null) {
            onChanged!(value);
          }

          // FormBuilder.of(context)?.setInternalFieldValue(txtName, rec['pk']);

          Frm.setFkTxtSrc({txtName: rec['pk']});
          Frm.setValue(context, txtNameRaw, rec['title']);
          if (onSelect != _doNothing) {
            onSelect(rec);
          }
        }
      },
    );
  }

  Widget _grid(BuildContext context) {
    return Grd(
      title: label,
      url: url,
      readUrl: readUrl,
      onSelect: (rec) {
        Navigator.pop(context, rec);
      },
      listing: (rec) => ListTxtSrc(r: rec),
      filters: filters,
    );
  }

//-----
}

/*
Class Listing grid dari txtsrc
parent Grd
* */
class ListTxtSrc extends StatelessWidget {
  final r;

  ListTxtSrc({required this.r});

  @override
  Widget build(BuildContext context) {
    return Card(
      //elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Container(
        child: ListTile(
          trailing: Icon(Icons.navigate_next),
          // trailing: Icon(Icons.more_vert),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 10.0, vertical: -4.0),
          title: Text(
            r['title'],
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
            color: r['filter'] == '1' ? Colors.blue.shade700 : Colors.black),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(r['subtitle'] ?? '',
                            style: TextStyle(
                                fontSize: 13,))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
