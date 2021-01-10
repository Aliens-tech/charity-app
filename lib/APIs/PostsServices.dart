import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';

class RequestServices {

  Future<List<Post>> getRequests(String token) async {

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token
    };
    List<Post> requests = [];

    var data =
    await http.get(BASE_URL + '/posts/requests/', headers: headers);
    var jsonData = json.decode(data.body);
    for (var r in jsonData) {
      Post request = Post('R', r["title"], r["description"], r[1]);
      requests.add(request);
    }
    return requests;
  }

  Future<List<Post>>getOffers(String token) async {

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token
    };
    List<Post> offers = [];

    var data =
    await http.get(BASE_URL + '/posts/offers/', headers: headers);
    var jsonData = json.decode(data.body);
    for (var o in jsonData) {
      Post request = Post('R', o["title"], o["description"], o[1]);
      offers.add(request);
    }
    return offers;


  }

  Future<dynamic> createPost(String token, Post post) async {
    dynamic request =  http.MultipartRequest("POST", Uri.parse(BASE_URL + '/posts/'));
    request.fields['title'] = post.title;
    request.fields['description'] = post.description;
    request.fields['categories'] = [1].toString();
    request.fields['post_type'] = post.postType;
    request.headers['authorization'] = 'Token '+ token;

    for (int i=0;i< post.images.length;i++){
      print(post.images.length);
      ByteData byteData = await post.images[i].getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      http.MultipartFile multipartFile = http.MultipartFile.fromBytes('images', imageData, filename: post.images[i].name);
      request.files.add(multipartFile);

    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("response "+responseString);

    // http.MultipartFile.fromPath('images', post.images.toString(), contentType: MediaType('application', 'x-tar')).then((value) {
    //   request.files.add(value);
    // });
    // request.send().then((response) {
    //   print(response.statusCode);
    //   if (response.statusCode == 200) {
    //     print("Uploaded!");
    //     return response;
    //   }
    // });
  }
}

// Future<dynamic> CreatePost(String token, Post post) async {
//   String body = json.encode(post);
//   Map<String, String> headers = {
//     "Content-Type": "application/json",
//     "Authorization": "Token $token"
//   };
//   var response =
//   await http.post(BASE_URL + '/posts/', body: body, headers: headers);
//   return response;
// }
