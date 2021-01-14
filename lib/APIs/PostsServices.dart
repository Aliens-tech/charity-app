import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';

class RequestServices {

  Future<List<Post>> getPosts(String token,String post_type) async {

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token
    };
    List<Post> posts = [];

    var data =
    await http.get(BASE_URL + '/posts/$post_type/', headers: headers);
    var jsonData = json.decode(data.body);
    for (var p in jsonData) {
      Post post = Post.response('R', p["title"], p["description"], p["categories"],p["created_at"],p["price"],p["image_item"]);
      posts.add(post);
    }
    return posts;
  }







  Future<List<Post>>getOffersByPrice(String token) async {

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token
    };
    List<Post> offers = [];

    var data =
    await http.get(BASE_URL + '/posts/offers/', headers: headers);
    var jsonData = json.decode(data.body);
    for (var o in jsonData) {
      Post offer = Post.response('O', o["title"], o["description"], o["categories"],o["created_at"],o["price"],o["image_item"]);
      offers.add(offer);
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

  }
}


