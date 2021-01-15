import 'dart:io';

import 'package:multi_image_picker/multi_image_picker.dart';

class Post {
  int id;
  double price;
  String postType;
  String title;
  String description;
  String created_at;
  String updated_at;
  String user;
  List<Asset> images;
  String image_item;
  List<int> requested_categories;
  String responsed_categories;

  Post(this.postType, this.title, this.description, this.requested_categories,
      {this.images});

  Post.request(this.postType, this.title, this.description,
      this.requested_categories, this.created_at, this.price,
      {this.images});

  Post.response(this.postType, this.title, this.description,
      this.responsed_categories, this.created_at, this.price, this.image_item);
}
