import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: CustomFilePicker() //set the class here
    );
  }
}

class CustomFilePicker extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CustomFilePicker();
  }
}

class _CustomFilePicker extends State<CustomFilePicker> {

  late File selectedfile = File('');
  late String progress = '';
  Dio dio = new Dio();

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      allowMultiple: true,
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.first.path!);
    }

    // selectedfile = await FilePicker.getFile(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'pdf', 'mp4'],
    //allowed extension to choose
    // );

    //for file_pocker plugin version 2 or 2+


    setState(() {}); //update the UI so that file name is shown
  }

  uploadFile() async {
    String uploadurl = "http://172.25.4.118/file_upload.php";
    var request = http.MultipartRequest('POST', Uri.parse(uploadurl));
    request.files.add(await http.MultipartFile.fromPath('file',
        selectedfile.path, filename: basename(selectedfile.path)));
    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200)
        {
          print("Uploaded! ");
          print('response.body '+response.body);
        }
        return response.body;
      });
    }).catchError((err) => print(err.toString())).whenComplete(()
    {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select File and Upload"),
          backgroundColor: Colors.orangeAccent,
        ), //set appbar
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            child: Column(children: <Widget>[

              Container(
                margin: EdgeInsets.all(10),
                //show file name here
                child: progress == null ?
                Text("Progress: 0%") :
                Text(basename("Progress: $progress"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),),
                //show progress status here
              ),

              Container(
                margin: EdgeInsets.all(10),
                //show file name here
                child: selectedfile == null ?
                Text("Choose File") :
                Text(basename(selectedfile.path)),
                //basename is from path package, to get filename from path
                //check if file is selected, if yes then show file name
              ),

              Container(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      selectFile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    icon: Icon(Icons.folder_open),
                    label: Text("CHOOSE FILE"),
                  )
              ),

              //if selectedfile is null then show empty container
              //if file is selected then show upload button
              selectedfile == null ?
              Container() :
              Container(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      selectFile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    icon: Icon(Icons.folder_open),
                    label: Text("CHOOSE FILE"),
                  )
              )

            ],)
        )
    );
  }
}
