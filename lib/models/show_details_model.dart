import 'package:puppy_app/models/posts_viewed.dart';

abstract class ShowDetailsPageCModel {
  String? pageName;
  List<PostsViewed>? contentList;
  Future<void> updatePage();

  Future<void> removePost(PostsViewed post);
  Future<void> deleteAllPosts();
}
