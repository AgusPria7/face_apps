import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:face_apps/sys.dart';
import 'package:path_provider/path_provider.dart';

class Req {
  static Future<List<dynamic>> read(String url, int offset, int limit,
      String searchText, List<Map> filterField, Map extraParams) async {
    print(jsonEncode(filterField));
    Map params = {
      "user_id": sys.lUser_id,
      "start": offset.toString(),
      "limit": limit.toString(),
      "query": searchText,
      "filter": jsonEncode(filterField)
    };

    if (extraParams.isNotEmpty) {
      params.addAll(extraParams);
    }

    return list(url, params);
  }

  static load(String url, pk) async {
    var responseJson = post(url, {"nPk": pk.toString()});
    // check data[] kosong tidak..
    return responseJson;
  }

  static Future<List<dynamic>> list(String url, Map param) async {
    param['ximmix'] = sys.SITE_KEY;
    print("Calling API: " + sys.SITE_URL + url);
    print("Calling parameters: $param");
    try {
      var response =
          await http.post(Uri.parse(sys.SITE_URL + url), body: param);
      print(response.body.toString());
      switch (response.statusCode) {
        case 200:
          var responseJson = json.decode(response.body);
          return responseJson;
        case 400:
          throw BadRequestException(response.body.toString());
        case 401:
        case 403:
          throw UnauthorisedException(response.body.toString());
        case 500:
        default:
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

//-------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------
//  request
  static post(String url, Map<String, dynamic> param) async {
    // final Map<String, dynamic> param = Map.of(paramX);
    //  param['ximmix'] = sys.SITE_KEY;
    print("Calling API: " + sys.SITE_URL + url);
    print("Calling parameters: $param");
    try {
      var response =
          await http.post(Uri.parse(sys.SITE_URL + url), body: param);
      // print(response.statusCode);
      switch (response.statusCode) {
        case 200:
          try {
            print (response.body);
            var responseJson = json.decode(response.body);
            return responseJson;
          } catch (e) {
            var responseJson = {'success': false, 'message': response.body};
            return responseJson;
          }
        default:
          try {
            print (response.body);
            var responseJson = json.decode(response.body);
            return responseJson;
          } catch (e) {
            var responseJson = {'success': false, 'message': response.body};
            return responseJson;
          }
        //throw FetchDataException('Error occured while Communication with Server with StatusCode: ${response.statusCode}');
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  static upload(String url, String msgNo, File selectedfile, String filename,
      List<dynamic> fileAttach) async {
    print("Calling API: " + sys.SITE_URL + url);
    var request = http.MultipartRequest('POST', Uri.parse(sys.SITE_URL + url));
    request.fields['user_id'] = sys.lUser_id;
    request.fields['txtMsg_no'] = msgNo;
    request.files.add(await http.MultipartFile.fromPath(
        'file', selectedfile.path,
        filename: filename));
    request.send().then((result) async {
          http.Response.fromStream(result).then((response) {
            if (response.statusCode == 200) {
              print("RESPONSE:" + response.body);
              var res = json.decode(response.body);
              fileAttach.add({
                'name': res['fname'],
                'src': res['src'],
                'fullpath': res['fullpath'],
                'type': res['type']
              });
            } else {
              print('Ada kesalahan.');
              return null;
            }
          });
        })
        .catchError((err) => print(err.toString()))
        .whenComplete(() {});
  }

  static Future<dynamic> urlToFile(String imageUrl, String name) async {
    var urlImage = sys.BASE_URL + 'FiLe/' + imageUrl + '/' + name;
    // print(urlImage);
    http.Response response = await http.get(Uri.parse(urlImage));
    if (response.statusCode == 404) {
      return null;
    }

    Directory tempDir = (await getApplicationDocumentsDirectory());
    String tempPath = tempDir.path;
    File file = File('$tempPath' + '/' + name);

    if (file.existsSync()) {
      file.delete(recursive: true);
      PaintingBinding.instance!.imageCache!.clear();
    }

    await file.writeAsBytes(response.bodyBytes,
        mode: FileMode.write, flush: true);
    return file;
  }
}

class SysException implements Exception {
  final _message;
  final _prefix;

  SysException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends SysException {
  FetchDataException([String message = ''])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends SysException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends SysException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends SysException {
  InvalidInputException([String message = ''])
      : super(message, "Invalid Input: ");
}
