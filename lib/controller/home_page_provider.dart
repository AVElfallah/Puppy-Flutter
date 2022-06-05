import 'package:flutter/material.dart';
import 'package:puppy_app/controller/database_helper.dart';

import 'package:puppy_app/models/posts_viewed.dart';

class HomePageProvider extends ChangeNotifier {
  List<PostsViewed> latestDogs = [];
  List<PostsViewed> favDogs = [];
  Future<void> _getListOFLatestDogs() async {
    var res = await DBHelper().readPost(
            'select * from viewed_posts where isViewed=1 ORDER BY id DESC')
        as List<Map>;

    latestDogs = res
        .map(
          (e) => PostsViewed.fromJson(
            e,
          ),
        )
        .toList();
    notifyListeners();
  }

  Future<void> _getListOFFavDogs() async {
    var res = await DBHelper().readPost(
            'select * from viewed_posts where isFav=1 ORDER BY id DESC')
        as List<Map>;
    favDogs = res
        .map(
          (e) => PostsViewed.fromJson(
            e,
          ),
        )
        .toList();
    notifyListeners();
  }

  Future<void> updatePage() async {
    await _getListOFLatestDogs().then((value) => notifyListeners());
    await _getListOFFavDogs().then((value) => notifyListeners());
  }
}
