import 'dart:io';

import 'package:multi_image_picker/multi_image_picker.dart';

class Post {
  int id;
  String postType;
  String title;
  String description;
  String created_at;
  String updated_at;
  String user;
  List<Asset> images;
  List<dynamic> categories;


  Post(this.postType, this.title, this.description, this.categories, {this.images});

  Map<String, String> toJson() => {
    'post_type': postType,
    'title': title,
    'description': description,
    'categories': categories.toString(),
  };

}
