import 'dart:async';

import 'package:application/screens/bottom_navigation.dart';
import 'package:application/utils/color_utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  int _start = 1;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        print(_start);
        if (_start == 1) {
          timer.cancel();
            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 150),
                                  transitionsBuilder: ((context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child,)),
                                  pageBuilder: ((context, animation, secondaryAnimation) => const BottomNav(page: 4,))));
          
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    return Scaffold(
      backgroundColor: hexStringToColor("0E86D4"),
      body: Container(
        child: Center(
          child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Stack(children: [
                      Center(
                        child: Image(
                    image: AssetImage('assets/solo-cup-logo.png'),
                    height: 150,
                    width: 150,
                  ),
                      ),
                      
                    ]),
                  ),
        ),
      )
    );
  }
}
