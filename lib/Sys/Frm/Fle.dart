
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:http/http.dart' as http;

class Fle extends StatefulWidget {
  final value;

  Fle({this.value});

  @override
  _FleState createState() => _FleState();
}

class _FleState extends State<Fle> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _useCustomFileViewer = true;

  Future addAttach() async {
    var url = 'http://172.25.4.118/APR/xmx/MAprv/upload';
    var filepath = 'http://172.25.4.118/APR/File/aprv/';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('images',
        filepath, filename: 'hahaha'));
    var res = await request.send();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              FormBuilderFilePicker(
                name: 'files',
                decoration: const InputDecoration(labelText: 'Attachments'),
                maxFiles: null,
                allowMultiple: true,
                previewImages: true,
                onChanged: (val) {
                  // debugPrint(val.toString());
                },
                // selector: Row(
                //   children: const <Widget>[
                //     Icon(Icons.file_upload),
                //     Text('Upload'),
                //   ],
                // ),
                onFileLoading: (val) {
                },
                customFileViewerBuilder:
                _useCustomFileViewer ? customFileViewerBuilder : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                      setState(() {
                        addAttach();
                      });
                      }
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    child: Text(_useCustomFileViewer
                        ? 'Use Default File Viewer'
                        : 'Use Custom File Viewer'),
                    onPressed: () {
                      setState(
                              () => _useCustomFileViewer = !_useCustomFileViewer);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }

  Widget customFileViewerBuilder(
      List<PlatformFile>? files,
      FormFieldSetter<List<PlatformFile>> setter,
      ) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final file = files![index];
        return ListTile(
          title: Text(file.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              files.removeAt(index);
              setter.call([...files]);
            },
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.blueAccent,
      ),
      itemCount: files!.length,
    );
  }
}
