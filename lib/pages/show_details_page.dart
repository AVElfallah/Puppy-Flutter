// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:puppy_app/controller/show_details_provider.dart';
import 'package:puppy_app/utils/constants.dart';

import '../models/posts_viewed.dart';
import '../widgets/dog_information_dialog.dart';

class ShowDetailsPage extends StatefulWidget {
  const ShowDetailsPage({Key? key}) : super(key: key);

  @override
  State<ShowDetailsPage> createState() => _ShowDetailsPageState();
}

class _ShowDetailsPageState extends State<ShowDetailsPage> {
  var provListen;
  var provFunctions;
  ShowDetails? swd;
  List<PostsViewed>? contentList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    swd = ModalRoute.of(context)!.settings.arguments as ShowDetails;
    setProvider(context);
    contentList = provListen.contentList;
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar:
          AppBar(title: Text(provListen.pageName), centerTitle: true, actions: [
        IconButton(
          onPressed: () {
            var dia = AlertDialog(
              title: const Text(
                'Are you sure you want to delete all posts?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.black87, fontSize: 22),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    provFunctions.deleteAllPosts();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.black54, fontSize: 22),
                  ),
                ),
              ],
            );
            showDialog(context: context, builder: (_) => dia);
          },
          icon: const Icon(FontAwesomeIcons.trashCan),
        ),
      ]),
      body: RefreshIndicator(
        onRefresh: provFunctions.updatePage,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: contentList?.length ?? 0,
          itemBuilder: ((context, index) {
            return InkWell(
              onTap: () {
                var dia = DogINFODailog(dog: contentList![index]);
                showDialog(context: context, builder: (_) => dia);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.all(30),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.40,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(24),
                  border: const Border.fromBorderSide(BorderSide(width: 2)),
                ),
                child: Column(
                  children: [
                    Text(
                      contentList![index].post!.name!,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 210,
                      child: Image.network(
                        contentList![index].post!.imageUrl!,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: swd == ShowDetails.latest
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            PostsViewed p = contentList![index];

                            provFunctions.removePost(p);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.trash,
                            color: Colors.black,
                          ),
                        ),
                        swd == ShowDetails.latest
                            ? IconButton(
                                onPressed: () {
                                  PostsViewed p = contentList![index];

                                  provFunctions.addToFav(p);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.heartCirclePlus,
                                  color: Colors.red.shade500,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

//set provider Method to determine which page is being viewed
  void setProvider(BuildContext context) {
    if (swd == ShowDetails.latest) {
      provListen = context.watch<ShowDetailsLatestViewedProvider>();
      provFunctions = context.read<ShowDetailsLatestViewedProvider>();
      provFunctions.updatePage();
    } else if (swd == ShowDetails.favorite) {
      provListen = context.watch<ShowDetailsFavoriteProvider>();
      provFunctions = context.read<ShowDetailsFavoriteProvider>();
      provFunctions.updatePage();
    } else {
      throw 'Unknown ShowDetails';
    }
  }
}
