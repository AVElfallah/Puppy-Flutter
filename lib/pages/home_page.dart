import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:provider/provider.dart';

import 'package:puppy_app/controller/home_page_provider.dart';

import 'package:puppy_app/models/posts_viewed.dart';
import 'package:puppy_app/utils/constants.dart';
import 'package:puppy_app/widgets/dog_information_dialog.dart';
import 'package:puppy_app/widgets/image_card.dart';
import '../widgets/bottomnavbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<PostsViewed> listOFLatest, listOFFav;
  late InfiniteScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = InfiniteScrollController();

    context.read<HomePageProvider>().updatePage();
  }

  @override
  Widget build(BuildContext context) {
    listOFLatest = context.watch<HomePageProvider>().latestDogs;
    listOFFav = context.watch<HomePageProvider>().favDogs;
    return Scaffold(
        backgroundColor: Colors.orange.shade100,
        appBar: AppBar(
          title: const Text('Puppy App'),
          centerTitle: true,
        ),
        body: listOFLatest.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  context.read<HomePageProvider>().updatePage();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Latest view',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          const Icon(Icons.view_carousel),
                          const Spacer(
                            flex: 2,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(
                                    '/showdetails',
                                    arguments: ShowDetails.latest,
                                  )
                                  .whenComplete(
                                    () async => context
                                        .read<HomePageProvider>()
                                        .updatePage(),
                                  );
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: InfiniteCarousel.builder(
                          itemCount:
                              listOFLatest.length > 5 ? 5 : listOFLatest.length,
                          itemExtent: 220,
                          center: true,
                          anchor: 20,
                          velocityFactor: .5,
                          onIndexChanged: (index) {},
                          controller: controller,
                          axisDirection: Axis.horizontal,
                          loop: true,
                          itemBuilder: (context, ix, realIndex) {
                            return InkWell(
                              onTap: () {
                                var dia = DogINFODailog(dog: listOFLatest[ix]);
                                showDialog(
                                    context: context, builder: (_) => dia);
                              },
                              child: ImageCardDog(
                                imgUrl: listOFLatest[ix].post!.imageUrl,
                              ),
                            );
                          },
                        ),
                      ),
                      listOFFav.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 30, top: 20),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        'Favorite dogs',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                    const Icon(FontAwesomeIcons.heart),
                                    const Spacer(
                                      flex: 2,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(
                                              '/showdetails',
                                              arguments: ShowDetails.favorite,
                                            )
                                            .whenComplete(
                                              () => context
                                                  .read<HomePageProvider>()
                                                  .updatePage(),
                                            );
                                      },
                                      child: Text(
                                        'See all',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 300,
                                  child: InfiniteCarousel.builder(
                                    itemCount: listOFFav.length > 5
                                        ? 5
                                        : listOFFav.length,
                                    itemExtent: 220,
                                    center: true,
                                    anchor: 20,
                                    velocityFactor: .5,
                                    onIndexChanged: (index) {},
                                    controller: controller,
                                    axisDirection: Axis.horizontal,
                                    loop: true,
                                    itemBuilder: (context, ix, realIndex) {
                                      return InkWell(
                                        onTap: () {
                                          var dia =
                                              DogINFODailog(dog: listOFFav[ix]);
                                          showDialog(
                                              context: context,
                                              builder: (_) => dia);
                                        },
                                        child: ImageCardDog(
                                          imgUrl: listOFFav[ix].post!.imageUrl,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ]),
                            )
                          : const Text('Favorits Not Found'),
                    ],
                  ),
                ),
              )
            : Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Text('No Data Found'),
                      SizedBox(
                        width: 20,
                      ),
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ],
                  ),
                )),
        bottomNavigationBar: const BottomNavBar(
          crIndex: 0,
        ));
  }
}
