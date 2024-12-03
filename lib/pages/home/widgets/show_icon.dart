import 'package:flutter/material.dart';
import 'package:weather_app/constants/constants.dart';

class ShowIcon extends StatelessWidget {
  const ShowIcon({super.key, required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    //Show a loading gif while waiting for image to load
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'https://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
      imageErrorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/no_image_icon.png',
        height: 96,
        width: 96,
      ),
    );
  }
}
