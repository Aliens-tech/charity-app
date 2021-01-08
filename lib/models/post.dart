class Post {
  int id;
  String postType;
  String title;
  String description;
  String created_at;
  String updated_at;
  String user;
  List<dynamic> categories;


  Post(this.postType, this.title, this.description, this.categories);

  Map<String, dynamic> toJson() => {
    'id': id,
    'post_type': postType,
    'title': title,
    'description': description,
    'created_at': created_at,
    'updated_at': updated_at,
    'user': user,
    'catgories': categories
  };

}
