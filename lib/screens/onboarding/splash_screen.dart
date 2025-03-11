import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheelsec/others/constants.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String _tagLine = "Securing vehicles in Nigeria";

  @override
  void initState() {
    bool loggedIn = labelBox.containsKey("loggedIn");
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (loggedIn) {
        _goHome();
      } else {
        _goWalkthrough();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: spacingNine, horizontal: hPadding,
        ),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/logo.svg"),
                const Text(
                  "WheelSec",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Text(
                _tagLine,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goWalkthrough() {
    Navigator.pushNamedAndRemoveUntil(context, "/walkthrough", (route) => false);
  }

  void _goHome() {
    Navigator.pushNamedAndRemoveUntil(context, "/bottom nav", (route) => false);
  }
}
