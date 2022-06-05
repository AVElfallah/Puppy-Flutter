import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key, this.crIndex}) : super(key: key);
  final int? crIndex;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'bottomNavigationBar',
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.paw),
            label: 'Breeds',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.dog),
            label: 'Random',
          ),
        ],
        currentIndex: crIndex!,
        selectedItemColor: Colors.deepOrange,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).popAndPushNamed('/');
              break;
            case 1:
              Navigator.of(context).popAndPushNamed('/breeds');
              break;
            case 2:
              Navigator.of(context).popAndPushNamed('/random');
              break;
          }
        },
      ),
    );
  }
}
