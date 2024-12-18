import 'package:flutter/material.dart';

import 'Frm.dart';
class Chk extends StatelessWidget {
  final String name, label;
  final ValueChanged<bool?>? onChanged;
  Chk({required this.name, required this.label,this.onChanged});

  @override
  Widget build(BuildContext context) {
    var txtName = name;

    return FormBuilderCheckbox(
      name: txtName,
      initialValue: false,
      onChanged: onChanged,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
            ),
            // TextSpan(
            //   text: 'Terms and Conditions',
            //   style: TextStyle(color: Colors.blue),
            //   recognizer: TapGestureRecognizer()
            //     ..onTap = () {
            //      // print('launch url');
            //     },
            // ),
          ],
        ),
      ),

    );
  }
}
