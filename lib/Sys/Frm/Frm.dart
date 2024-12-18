export 'package:face_apps/Sys/Frm/Txt.dart';
export 'package:face_apps/Sys/Frm/Num.dart';
export 'package:face_apps/Sys/Frm/Chk.dart';
export 'package:face_apps/Sys/Frm/Cmb.dart';
export 'package:face_apps/Sys/Frm/Dte.dart';
export 'package:face_apps/Sys/Frm/TxtSrc.dart';
export 'package:face_apps/Sys/Frm/MList.dart';
export 'package:flutter_form_builder/flutter_form_builder.dart';
export 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:face_apps/Sys/Frm/FrmHeader.dart';
import 'package:face_apps/Sys/req.dart';
import 'package:face_apps/sys.dart';

void _doNothing(dynamic _) {}
void _doNothing2(dynamic _, dynamic __) {}

class Frm extends StatefulWidget {
  String? pk;
  String title, url;
  String? readUrl;
  List<Widget>? items1;
  List<Widget>? items2;
  List<Widget>? actions;
  Widget? bottom;
  Map<String, dynamic>? itemsHid;
  final formKey;
  bool deleteBtn;
  bool saveBtn;
  bool firebase;
  Widget? leading;
  final Function(dynamic) floatingActionButton;
  final Function(Map<String, dynamic> values, bool isEditing) onSave;
  final Function(Map<String, dynamic> values) afterSave;
  final Function(Map<dynamic, dynamic> values) onInit;
  final Function(Map<String, dynamic> values) onLoad;
  final Function(dynamic) setItems;
  Frm(
      {this.pk,
        required this.title,
        required this.url,
        this.readUrl,
        this.leading,
        this.itemsHid,
        this.items1,
        this.items2,
        this.actions,
        this.bottom,
        required this.formKey,
        this.firebase = false,
        this.deleteBtn = true,
        this.saveBtn = true,
        this.floatingActionButton = _doNothing,
        this.afterSave = _doNothing,
        this.onSave = _doNothing2,
        this.onInit = _doNothing,
        this.onLoad = _doNothing,
        this.setItems = _doNothing});

  static void setValue(context, String name, value) {
    FormBuilder.of(context)!.fields[name]!.didChange(value);
  }

  static void setDivision(context, String name, value) {
    FormBuilder.of(context)!.fields[name]!.didChange(value);
  }

  static void getValue(context, String name) {
    return FormBuilder.of(context)!.fields[name]!.value;
  }

  static setInitialValues(data) {
    _FrmState.setInitialValues(data);
  }

  static setXtype(data) {
    _FrmState.setXtype(data);
  }

  static setFkTxtSrc(data) {
    _FrmState.setFkTxtSrc(data);
  }

  @override
  _FrmState createState() => _FrmState();
}

class _FrmState extends State<Frm> {
  static bool isEditing = true;
  static Map<String, dynamic> initialValues = {};
  static Map xtype = {};
  static Map<String, dynamic> fkTxtSrc = {};

  /*
  * register for FK/pk TxtSrc
  * */
  static getValue(txt) {
    // return Widget.formKey.currentState?.fields[txt].value;
  }
  static setValue(txt, val) {
    // widget.formKey.currentState?.fields[txt].value=val;
  }
  /*
  * first setting from txt/field
  * */
  static setXtype(data) {
    if (!isEditing) {
      xtype.addAll(data);
    }
  }

  /*
  * first setting from txt/field
  * */
  static setInitialValues(data) {
    if (!isEditing) {
      initialValues.addAll(data);
    }
  }

  /*
  * register for FK/pk TxtSrc
  * */
  static setFkTxtSrc(data) {
    data.forEach((key, value) {
      if (value != '#') {
        fkTxtSrc[key] = value;
      }
    });
  }

  void setInternalField(key, value) {
    widget.formKey.currentState
        ?.setInternalFieldValue(key, value, isSetState: true);
  }

  @override
  void initState() {
    // List.generate(widget.items2.length, (index) {
    //   //print(widget.items2[index]);
    // });

    super.initState();
    //inisial value untuk TxtHid

    //setelah semua terbuild
    setState(() {
      isEditing = (widget.pk == null) ? false : true;
    });

    // WidgetsBinding.instance!.addPostFrameCallback((xx) {
    //   widget.onLoad(initialValues);
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pk == null) {
      return buildForm(context);
    } else {
      return FutureBuilder(
          future: load(widget.pk),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return buildForm(snapshot.data);
              return buildForm(context);
            } else {
              return Center(
                  child:
                  CircularProgressIndicator(backgroundColor: Colors.white));
            }
          });
    }
  }

  Widget buildForm(rec) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: widget.leading,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        bottomOpacity: 0.0,
        actions: widget.actions,
      ),
      floatingActionButton: Visibility(
        visible: !widget.saveBtn && !widget.deleteBtn,
        child: FloatingActionButton(
            onPressed: () {}, child: widget.floatingActionButton(rec)),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 2,
          child: FormBuilder(
            key: widget.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            initialValue: initialValues,
            child: Column(
              children: [
                widget.items1 == null
                    ? Container()
                    : FrmItems1(items1: widget.items1),
                Expanded(
                  child: (widget.items2 == null)
                      ? widget.setItems(rec)
                      : Container(
                    padding: EdgeInsets.all(10),
                    //width: 500,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.items2!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.saveBtn ? bottomBar() : widget.bottom,
    );
  }

  Future<void> load(pk) async {
    initialValues = {};
    var r;
    Map<dynamic, dynamic> data;
    r = await Req.load(widget.url + '/load', pk);
    data = r['data'];
    data.forEach((key, value) {
      //rubah format tanggal dan numeric
      // print(value);
      if (key.contains('_date')) {
        if (DateTime.tryParse(value.toString()) != null) {
          DateTime tempDate =
          new DateFormat("yyyy-MM-dd").parse(value.toString());
          initialValues[key] = tempDate;
          initialValues[key] = tempDate;
        }
      } else {
        initialValues[key] = value;
      }

      //untuk txtSrc isi pk
      if (widget.itemsHid != null) {
        if (widget.itemsHid!.containsKey(key)) {
          Frm.setFkTxtSrc({key: value});
        }
      }
    });
    //---panggil diclient

    // Map<String, dynamic> initialParam = await widget.onLoad(initialValues);
    //
    // if (initialParam != null) {
    //   initialValues = initialParam;
    // }
    r = widget.onInit(initialValues);
    return r;
  }

  void setItemsHid() {
    if (widget.itemsHid != null) {
      // print(widget.itemsHid);
      widget.itemsHid?.forEach((key, value) {
        setInternalField(key, value);
      });
    }
    fkTxtSrc.forEach((key, value) {
      setInternalField(key, value);
    });
  }

  void _onSave() async {
    setItemsHid();
    if (widget.formKey.currentState?.saveAndValidate() ?? false) {
//jika ada error bagian sini..masalah validasi kemungkinan besar karena value tak valid, liat di object cms
    } else {
      sys.notify('Ada field yang kosong.', Colors.red.shade500);
      print('validation failed');
      return;
    }

    if (widget.pk != null) {
      setInternalField('txtPk', widget.pk);
    }

    Map<String, dynamic> values = widget.formKey.currentState?.value;
    Map<String, dynamic>? xVal = await widget.onSave(values, isEditing);

    if (xVal != null) {
      values = xVal;
    } else {
      values = widget.formKey.currentState?.value;
    }

    _onSavePHP(values);
  }

  void _onSavePHP(Map<String, dynamic> values) async {
    var upsertUrl = widget.url + '/' + widget.readUrl!;
    Req.post(upsertUrl, values).then((data) {
      if (data['success'] == true) {
        sys.notify('Success', sys.theme);
        Navigator.pop(context);
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: 'FAILED',
          desc: data['message'],
        ).show();
      }
      widget.afterSave(data);
    });
  }

  Future<void> _onDelete(pk) async {
    Alert(
      context: context,
      type: AlertType.none,
      title: 'Delete?',
      desc: '',
      buttons: [
        DialogButton(
          child: Text(
            'Delete?',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            _onDeletePHP(pk);
          },
          color: Colors.red,
        ),
        DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => Navigator.pop(context))
      ],
    ).show();
  }

  void _onDeletePHP(pk) async {
    Req.post(widget.url + '/delete', {"nPk": pk}).then((data) {
      // print(data['success']);
      if (data['success'] == true) {
        Navigator.pop(context, true);
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: 'Delete',
          desc: data['message'],
        ).show();
      }
    });
  }

  Widget bottomBar() {
    return Container(
      // color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(
              //   child: Text('-'),
              // ),
              // Visibility(
              //   visible: (isEditing && widget.deleteBtn),
              //   child: Container(
              //     //padding:
              //     child: ElevatedButton.icon(
              //       key: const Key('delete'),
              //       onPressed: () {
              //         //--
              //         _onDelete(widget.pk);
              //       },
              //       style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              //           //foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              //           padding: MaterialStateProperty.all(
              //             const EdgeInsets.symmetric(
              //               horizontal: 24,
              //               vertical: 16,
              //             ),
              //           )),
              //       label: const Text("Delete"),
              //       icon: Icon(Icons.delete),
              //     ),
              //   ),
              // ),
              SizedBox(width: 10), //<---
              Visibility(
                visible: widget.saveBtn,
                child: ElevatedButton.icon(
                  key: const Key('submit'),
                  onPressed: () {
                    _onSave();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      )),
                  label: isEditing ? const Text("Save") : const Text("Submit"),
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                ),
              ),

              // Second child is button
            ]));
  }
}

class FrmItems1 extends StatelessWidget {
  List<Widget>? items1;
  FrmItems1({this.items1});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircularBackgroundPainter(),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: SizedBox(
                height: 200,
                child: Container(
                  padding: EdgeInsets.all(10),
                  //width: 500,
                ),
              )),
        ],
      ),
    );
  }
}
