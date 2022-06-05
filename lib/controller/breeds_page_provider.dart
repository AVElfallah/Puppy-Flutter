import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:puppy_app/utils/constants.dart';

class BreedsPageProvider extends ChangeNotifier {
  Future<http.Response> _getDogsList() {
    return http.get(
      Uri.parse(breedsListUrl),
    );
  }

  List<String> breedsList = [];
  List<String> names = [];
  Future<String> getRandomImageByName(String breedName) async {
    try {
      var url = Uri.parse('https://dog.ceo/api/breed/$breedName/images/random');
      var response = await http.get(url);
      var data = json.decode(response.body)['message'];
      return data;
    } catch (e) {
      throw 'Error';
    }
  }

  Future<List<String>> getListOfBreeds() async {
    breedsList.clear();
    names.clear();
    var response = await _getDogsList();
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['message'] as Map;
      names = data.keys.toList() as List<String>;
    } else {
      return [];
    }

    return names;
  }

  String cruntBreedName = 'affenpinscher';
  String cruntBreedImage = '';
  void setBreed(String? value) {
    cruntBreedName = value ?? 'affenpinscher';
    notifyListeners();
  }

  void setImage() {
    getRandomImageByName(cruntBreedName).then((value) {
      cruntBreedImage = value;
      notifyListeners();
    });
  }
}
