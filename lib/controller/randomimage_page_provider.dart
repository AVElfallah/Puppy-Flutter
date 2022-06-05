import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:puppy_app/controller/database_helper.dart';
import 'package:puppy_app/models/dog_cashs.dart';
import 'package:puppy_app/models/posts_viewed.dart';

import '../utils/constants.dart';

class RandomImagePageProvider extends ChangeNotifier {
  late Dog currentDog = Dog(
    name: ' ',
    imageUrl: '',
    fact: ' ',
  );

  bool isFav = false;
  String _getDogName(String s) {
    //get dog name from url
    var str = s.split('/')[4];

    return (!str.contains('-') ? str : str.replaceAll('-', ' ')).toUpperCase();
  }

  void updateCurrentDog() async {
    //get new random dog
    currentDog = await _fetchDog();
    PostsViewed post = PostsViewed.withoutDate(
      post: currentDog,
      isFavorite: false,
      isViewed: true,
    );
    isFav = false;
    //insert new dog to last viewed
    _crPostID = await DBHelper().insertPost(post) as int;

    notifyListeners();
  }

  int _crPostID = 0;
  void favoritChange() async {
    isFav = !isFav;
    notifyListeners();
    await DBHelper().updatePost(
      PostsViewed(
        post: currentDog,
        isFavorite: isFav,
        isViewed: true,
      ),
      _crPostID,
    );
  }

  Future<Dog> _fetchDog() async {
    Dog _currentDog = Dog(
      name: ' ',
      imageUrl: '',
      fact: ' ',
    );
    //  get image
    await http.get(Uri.parse(randImageUrl)).then(
      (response) {
        var str = jsonDecode(response.body)['message'];
        _currentDog.imageUrl = str;

        _currentDog.name = _getDogName(str);
      },
    );
    //get fact
    await http.get(Uri.parse(randFact)).then(
      (response) {
        var str = jsonDecode(response.body)['facts'][0];
        _currentDog.fact = str;
      },
    );

    return _currentDog;
  }
}
