import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';
import 'package:puppy_app/controller/database_helper.dart';
import 'package:puppy_app/controller/home_page_provider.dart';
import 'package:puppy_app/models/posts_viewed.dart';
import 'package:puppy_app/widgets/image_card.dart';

class DogINFODailog extends StatefulWidget {
  final PostsViewed dog;
  const DogINFODailog({Key? key, required this.dog}) : super(key: key);

  @override
  State<DogINFODailog> createState() => _DogINFODailogState();
}

class _DogINFODailogState extends State<DogINFODailog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(width: 2, color: Colors.black)),
      title: Text(
        widget.dog.post!.name!,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ImageCardDog(imgUrl: widget.dog.post!.imageUrl),
            const Divider(
              color: Colors.black,
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
                    onPressed: () async {
                      widget.dog.isFavorite = !widget.dog.isFavorite!;
                      await DBHelper().updatePost(widget.dog, widget.dog.id!);
                      await Provider.of<HomePageProvider>(context,
                              listen: false)
                          .updatePage();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: widget.dog.isFavorite! ? Colors.red : Colors.white,
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
                              widget.dog.post!.imageUrl!)
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
            Center(
              child: Text(
                widget.dog.post!.fact!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
      ),
    );
  }
}
