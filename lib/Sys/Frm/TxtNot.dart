// import 'package:flutter/material.dart';
// import 'package:html_editor_enhanced/html_editor.dart';
//
// import 'package:mrp/Sys/Frm/Frm.dart';
// import 'package:mrp/sys.dart';
//
// class TxtNot extends StatefulWidget {
//   String name, label;
//   bool? allowBlank;
//   InputDecoration? decoration = const InputDecoration();
//   List<dynamic>? value;
//   int maxLength;
//   HtmlEditorController controller;
//   TxtNot(
//       {required this.name,
//         required this.label,
//         required this.controller,
//         this.value,
//         this.maxLength = 20,
//         this.allowBlank,
//         this.decoration});
//
//   @override
//   _TxtNotState createState() => _TxtNotState();
// }
//
// class _TxtNotState extends State<TxtNot> {
//   @override
//   Widget build(BuildContext context) {
//     var txtName = widget.name;
//     if (sys.txtPrevix != '') {
//       var txtName = sys.txtPrevix + initCap(widget.name);
//     }
//     //print(widget.value);
//     return FormBuilderField(
//       name: txtName,
//       validator: FormBuilderValidators.compose([
//         FormBuilderValidators.required(context),
//       ]),
//       onChanged: (val){
//         print('sssss $val');
//       },
//       builder: (FormFieldState<dynamic> field) {
//         return HtmlEditor(
//           controller: widget.controller, //required
//           htmlEditorOptions: HtmlEditorOptions(
//             hint: "Your text here...",
//             //initalText: "text content initial, if any",
//           ),
//           otherOptions: OtherOptions(
//             height: 400,
//           ),
//         );
//       },
//     );
//   }
// }
