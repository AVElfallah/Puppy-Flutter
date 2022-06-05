import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puppy_app/controller/breeds_page_provider.dart';
import 'package:puppy_app/controller/home_page_provider.dart';
import 'package:puppy_app/controller/randomimage_page_provider.dart';
import 'package:puppy_app/controller/show_details_provider.dart';
import 'package:puppy_app/pages/breeds_page.dart';
import 'package:puppy_app/pages/home_page.dart';
import 'package:puppy_app/pages/random_image_page.dart';
import 'package:puppy_app/pages/show_details_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RandomImagePageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BreedsPageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomePageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShowDetailsFavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShowDetailsLatestViewedProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    context.read<HomePageProvider>().updatePage();
    return MaterialApp(
      title: 'Puppy App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/random': (context) => const RandomImagePage(),
        '/breeds': (context) => const BreedsPage(),
        '/showdetails': (context) => const ShowDetailsPage(),
      },
    );
  }
}
