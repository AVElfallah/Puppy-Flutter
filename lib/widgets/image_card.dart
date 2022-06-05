import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageCardDog extends StatefulWidget {
  ImageCardDog({Key? key, this.imgUrl}) : super(key: key);

  String? imgUrl;

  @override
  State<ImageCardDog> createState() => _ImageCardDogState();
}

class _ImageCardDogState extends State<ImageCardDog>
    with TickerProviderStateMixin {
  late double mqW, mqH;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    mqW = MediaQuery.of(context).size.width;
    mqH = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 1900,
      ),
      margin: const EdgeInsets.all(
        8,
      ),
      width: isPortrait ? mqW : mqW * .6,
      height: isPortrait ? mqH * .50 : mqH * .9,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(
          25,
        ),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          25,
        ),
        image: DecorationImage(
          image: NetworkImage(
            widget.imgUrl!,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
