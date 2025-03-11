import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheelsec/others/constants.dart';

class AccountSet extends StatelessWidget {
  const AccountSet({super.key});
  final String _heading = "Account is set!";
  final String _subHeading = "We’re happy to have you here.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
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
                    SvgPicture.asset("assets/illustrations/success.svg"),
                    const SizedBox(height: spacingSix,),
                    Text(
                      _heading,
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _subHeading,
                      style: TextStyle(
                        color: onSurfaceVariant,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  _goHome(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                    foregroundColor: onPrimary,
                    minimumSize: const Size.fromHeight(60)),
                child: const Text(
                  "Go to home",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ), // Go to home
            ],
          ),
        ),
      ),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, "/bottom nav", (route) => false);
  }
}
