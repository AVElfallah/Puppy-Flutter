import 'package:puppy_app/models/dog_cashs.dart';

class PostsViewed {
  Dog? post;
  int? id;
  bool? isFavorite, isViewed;

  String? date;

  PostsViewed({this.post, this.isFavorite, this.id, this.date, this.isViewed});

  factory PostsViewed.fromJson(Map map) {
    var dog = Dog(
      name: map['name'],
      imageUrl: map['image'],
      fact: map['fact'],
    );
    var pos = PostsViewed(
      date: map['date'],
      isFavorite: map['isFav'] == 1,
      isViewed: map['isViewed'] == 1,
      post: dog,
      id: map['id'],
    );

    return pos;
  }

  factory PostsViewed.withoutDate({
    Dog? post,
    bool? isFavorite,
    bool? isViewed,
  }) {
    var d = DateTime.now();
    var date = '${d.day}/${d.month}/${d.year}';

    return PostsViewed(
      post: post,
      isFavorite: isFavorite,
      isViewed: isViewed,
      date: date,
    );
  }
}
