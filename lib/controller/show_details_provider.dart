import 'package:flutter/material.dart';
import 'package:puppy_app/controller/database_helper.dart';
import 'package:puppy_app/models/posts_viewed.dart';
import 'package:puppy_app/models/show_details_model.dart';

class ShowDetailsFavoriteProvider extends ChangeNotifier
    implements ShowDetailsPageCModel {
  @override
  Future<void> deleteAllPosts() async {
    await DBHelper().deleteAllFavPosts();

    updatePage();
  }

  @override
  Future<void> updatePage() async {
    var res = await DBHelper().readPost(
            'select * from viewed_posts where isFav=1 ORDER BY id DESC')
        as List<Map>;
    contentList = res
        .map(
          (e) => PostsViewed.fromJson(
            e,
          ),
        )
        .toList();
    notifyListeners();
  }

  @override
  Future<void> removePost(PostsViewed post) async {
    post.isFavorite = false;
    await DBHelper().updatePost(post, post.id!);
    updatePage();
  }

  @override
  List<PostsViewed>? contentList;

  @override
  String? pageName = 'Favorites';
}

class ShowDetailsLatestViewedProvider extends ChangeNotifier
    implements ShowDetailsPageCModel {
  @override
  Future<void> deleteAllPosts() async {
    await DBHelper().deleteAllLatestViewedPosts();
    updatePage();
  }

  Future<void> addToFav(PostsViewed post) async {
    post.isFavorite = true;
    await DBHelper().updatePost(post, post.id!);
    updatePage();
  }

  @override
  Future<void> updatePage() async {
    var res = await DBHelper().readPost(
            'select * from viewed_posts where isViewed=1 ORDER BY id DESC')
        as List<Map>;
    contentList = res
        .map(
          (e) => PostsViewed.fromJson(
            e,
          ),
        )
        .toList();

    notifyListeners();
  }

  @override
  Future<void> removePost(PostsViewed post) async {
    post.isViewed = false;
    await DBHelper().updatePost(post, post.id!);
    updatePage();
  }

  @override
  List<PostsViewed>? contentList;

  @override
  String? pageName = 'Latest Viewed';
}
