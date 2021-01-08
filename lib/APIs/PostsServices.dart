import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:opinionat/constants.dart';
import 'package:opinionat/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<dynamic> CreatePost(String token, Post post) async {
    String body = json.encode(post);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Token $token"
    };
    var response =
        await http.post(BASE_URL + '/posts/', body: body, headers: headers);
    return response;
  }
}
