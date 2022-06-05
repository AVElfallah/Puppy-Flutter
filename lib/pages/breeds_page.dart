import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:puppy_app/controller/breeds_page_provider.dart';
import 'package:puppy_app/widgets/image_card.dart';

import '../widgets/bottomnavbar.dart';

class BreedsPage extends StatefulWidget {
  const BreedsPage({Key? key}) : super(key: key);

  @override
  State<BreedsPage> createState() => _BreedsPageState();
}

class _BreedsPageState extends State<BreedsPage> {
  @override
  Widget build(BuildContext context) {
    var imgURL = context.watch<BreedsPageProvider>().cruntBreedImage;
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        title: const Text('Breeds'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: context.watch<BreedsPageProvider>().getListOfBreeds(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var it = (snapshot.data as List<String>)
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                    ),
                  ),
                )
                .toList();
            var vl = context.watch<BreedsPageProvider>().cruntBreedName;
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select Breed',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: DropdownButton<String>(
                    hint: const Text('Not Selected'),
                    dropdownColor: Colors.orangeAccent.shade100,
                    elevation: 30,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(20),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    menuMaxHeight: 340,
                    items: it,
                    value: vl,
                    onChanged: (value) {
                      context.read<BreedsPageProvider>().setBreed(value);
                      context.read<BreedsPageProvider>().setImage();
                    },
                  ),
                ),
                imgURL != ''
                    ? ImageCardDog(
                        imgUrl: imgURL,
                      )
                    : const Center(child: Text('NO IMAGE FOUND')),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(
        crIndex: 1,
      ),
    );
  }
}
