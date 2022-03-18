// ignore_for_file: file_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ignore: sized_box_for_whitespace
          const SizedBox(
            height: 120,
          ),
          SizedBox(
            height: 300,
            width: 600,
            child: Lottie.asset("assets/motor.json"),
          ),
          // const Text('Async Moteur',
          //     style: TextStyle(
          //         fontFamily: 'Amarante',
          //         fontSize: 40,
          //         color: Color(0xff827ddc),
          //         fontWeight: FontWeight.bold)),
          DefaultTextStyle(
            style: const TextStyle(
                fontFamily: 'Amarante',
                fontSize: 40,
                color: Color(0xff1A374D),
                fontWeight: FontWeight.bold),
            child: AnimatedTextKit(
                pause: const Duration(milliseconds: 3000),
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Async Motor',
                    speed: const Duration(milliseconds: 100),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
