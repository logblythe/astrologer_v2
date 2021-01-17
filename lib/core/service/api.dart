import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:astrologer/core/constants/end_points.dart';
import 'package:astrologer/core/data_model/astrologer_model.dart';
import 'package:astrologer/core/data_model/image_model.dart';
import 'package:astrologer/core/data_model/user_history.dart';
import 'package:astrologer/core/data_model/user_model.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Api {
  var client = http.Client();
  String token;

  Future<UserHistory> fetchUserHistory({String deviceId}) async {
    var response = await client.get("$userHistory/abcd",
        headers: {"Content-Type": "application/json"});
    UserHistory history = UserHistory.fromJson(jsonDecode(response.body));
    return history;
  }

  Future<UserModel> registerUser(
      UserModel user, String deviceId, String deviceToken) async {
    try {
      http.Response response = await client.post(register,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              user.toMapForApi(deviceId: deviceId, deviceToken: deviceToken)));
      print('hello ${jsonDecode(response.body)}');
      switch (response.statusCode) {
        case 200:
          return UserModel.fromJson(jsonDecode(response.body));
        case 409:
          return UserModel.fromError(jsonDecode(response.body));
        default:
          return UserModel.error(
              error: "Something went wrong. Please try again");
      }
    } catch (e) {
      return UserModel.error(error: e.toString());
    }
  }

  Future<Map<String, dynamic>> askQuestion(
      int userId, String question, double questionPrice,
      {int prevQuestionId}) async {
    try {
      var response = await client.post(
        askQuestionUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            'engQuestion': question,
            'userId': userId,
            'prevEngQuesId': prevQuestionId,
            'questionPrice': questionPrice,
          },
        ),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  fetchAstrologers() async {
    try {
      var response = await client.get(
        fetchAstrologersUrl,
        headers: {
          "Content-Type": "application/json",
        },
      );
      List<dynamic> astrologers = jsonDecode(response.body);
      return astrologers.map((json) => AstrologerModel.fromJson(json)).toList();
    } catch (e) {
      print('FETCH ASTROLOGER the response exception $e}');
//      return AstrologerModel.withError(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchQuestionPrice() async {
    try {
      var response = await client.get(
        fetchQuestionPriceUrl,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print(
          'response fetch question price ${response.statusCode} \n ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print('FETCH QUESTION PRICE the response exception $e}');
      return null;
    }
  }

  Future<ImageModel> upload(File imageFile) async {
    Map<String, String> headers = {};
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(uploadProfile);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    var contents = new StringBuffer();
    var completer = new Completer<ImageModel>();
    // listen for response
    response.stream.transform(utf8.decoder).listen(
      (value) {
        contents.write(value);
      },
      onDone: () {
        var jsonData = json.decode(contents.toString());
        completer.complete(ImageModel.fromJson(jsonData));
      },
    );
    return completer.future;
  }
}
