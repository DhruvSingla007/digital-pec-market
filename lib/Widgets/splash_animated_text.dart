import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SplashAnimatedText extends StatelessWidget {

  final String text;

  const SplashAnimatedText({Key? key, required this.text}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    const colorizeTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 35,
      fontFamily: "Acme",
      //letterSpacing: 3,
    );

    return SizedBox(
      width: 250.0,
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            text,
            textStyle: colorizeTextStyle,
            textAlign: TextAlign.center,
            colors: colorizeColors,
          ),
        ],
        isRepeatingAnimation: true,
      ),
    );
  }
}
