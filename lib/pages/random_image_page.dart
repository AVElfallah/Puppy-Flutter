import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:puppy_app/models/dog_cashs.dart';
import 'package:puppy_app/widgets/bottomnavbar.dart';
import 'package:puppy_app/widgets/image_card.dart';
import 'package:image_downloader/image_downloader.dart';

import '../controller/randomimage_page_provider.dart';

class RandomImagePage extends StatefulWidget {
  const RandomImagePage({Key? key}) : super(key: key);

  @override
  State<RandomImagePage> createState() => _RandomImagePageState();
}

class _RandomImagePageState extends State<RandomImagePage> {
  late Dog crDog;

  @override
  void initState() {
    super.initState();

    Provider.of<RandomImagePageProvider>(context, listen: false)
        .updateCurrentDog();
  }

  @override
  Widget build(BuildContext context) {
    bool isFav = context.watch<RandomImagePageProvider>().isFav;

    crDog =
        Provider.of<RandomImagePageProvider>(context, listen: true).currentDog;
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        title: const Text('Puppy Random Image&Fact'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<RandomImagePageProvider>(context, listen: false)
              .updateCurrentDog();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: crDog.imageUrl != ''
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        crDog.name!,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.purple.shade900,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ImageCardDog(
                      imgUrl: crDog.imageUrl,
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.only(bottom: 1),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        border: Border.all(
                          color: Colors.purple.shade900,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(29),
                      ),
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              context
                                  .read<RandomImagePageProvider>()
                                  .favoritChange();
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: isFav ? Colors.red : Colors.white,
                              size: 40,
                              shadows: const [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.red,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            tooltip: 'Add To Favorites',
                          ),
                          IconButton(
                            onPressed: () async {
                              const downloadSnackBar = SnackBar(
                                content: Text('Downloading image ...'),
                                duration: Duration(minutes: 10),
                              );
                              const doneSnackBar = SnackBar(
                                content: Text('Download complete! ...'),
                                duration: Duration(milliseconds: 700),
                              );
                              var showSnackBar = ScaffoldMessenger.of(context)
                                ..showSnackBar(downloadSnackBar);

                              await ImageDownloader.downloadImage(
                                      crDog.imageUrl!)
                                  .then((value) {
                                showSnackBar
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(doneSnackBar);
                              });
                            },
                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 40,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.blue,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            tooltip: 'Download',
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Fact',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        crDog.fact!,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        crIndex: 2,
      ),
    );
  }
}
