import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheelsec/others/constants.dart';

class Walkthrough extends StatelessWidget {
  const Walkthrough({super.key});
  final String _heading = "Welcome to WheelSec";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            hPadding, hPadding,
            hPadding, hPadding,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/logo.svg"),
                  const SizedBox(height: spacingFive,),
                  Text(
                    _heading,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: onPrimary,
                    ),
                  ),
                ],
              ),
              ),
              Expanded(
                child: SvgPicture.asset("assets/illustrations/car.svg"),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        _goCreateAccount(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                          foregroundColor: primary,
                          minimumSize: const Size.fromHeight(60)),
                      child: const Text(
                        "Create new account",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ), // Create new account
                    const SizedBox(height: spacingFive,),
                    TextButton(
                      onPressed: (){
                        _goLogIn(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                          foregroundColor: onPrimary,
                          minimumSize: const Size.fromHeight(60)),
                      child: const Text(
                        "Log in instead",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ), // Create new account
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goCreateAccount(BuildContext context) {
    Navigator.pushNamed(context, "/create account");
  }

  void _goLogIn(BuildContext context) {
    Navigator.pushNamed(context, "/log in");
  }
}
