class Photo_item{
  final int userId;
  final int id;
  final String title;

  Photo_item({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Photo_item.fromJson(Map<String, dynamic>json ){
    return Photo_item(userId: json['userId'], id: json['id'], title: json['title']);
  }
}

/*
{
"userId": 1,
"id": 1,
"title": "quidem molestiae enim"
},

 */