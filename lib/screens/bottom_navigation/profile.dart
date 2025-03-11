import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheelsec/others/constants.dart';
import 'package:wheelsec/others/global_functions.dart';

import '../../appwrite/auth.dart';
import '../../main.dart';
import 'bottom_nav.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      body: Column(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            height: 160.0,
            color: const Color(0xFFD1E0F5),
            padding: const EdgeInsets.fromLTRB(
              hPadding, spacingSix,
              hPadding, spacingEight,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFC34A3D),
                  radius: 24.0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      getInitial(userName),
                      style: TextStyle(
                        color: onSecondary,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: spacingFive,),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            onTap: () {
              _editProfile(context);
            },
            leading: SvgPicture.asset("assets/icons/profile.svg"),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                "My profile",
                style: TextStyle(
                  color: onSurface,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: SvgPicture.asset("assets/icons/arrow_right.svg",),
            contentPadding: const EdgeInsets.symmetric(
              vertical: spacingThree,
              horizontal: hPadding,
            ),
            horizontalTitleGap: spacingFour,
          ), // My profile
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFF7F7F7),
          ),
          ListTile(
            onTap: () {
              _changePassword(context);
            },
            leading: SvgPicture.asset("assets/icons/security.svg"),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                "Change password",
                style: TextStyle(
                  color: onSurface,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: SvgPicture.asset("assets/icons/arrow_right.svg",),
            contentPadding: const EdgeInsets.symmetric(
              vertical: spacingThree,
              horizontal: hPadding,
            ),
            horizontalTitleGap: spacingFour,
          ), // Change password
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFF7F7F7),
          ),
          ListTile(
            onTap: () {
              _logOut(context);
            },
            leading: SvgPicture.asset("assets/icons/log_out.svg"),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                "Log out",
                style: TextStyle(
                  color: error,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: spacingThree,
              horizontal: hPadding,
            ),
            horizontalTitleGap: spacingFour,
          ), // Log out
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) {
    Navigator.pushNamed(context, "/edit profile");
  }

  void _changePassword(BuildContext context) {
    Navigator.pushNamed(context, "/new password");
  }

  void _logOut(BuildContext context) {
    _auth.signOut();
    labelBox.delete("loggedIn");
    boxDetails.delete("details");
    codeBox.delete("uniqueCode");
    Navigator.of(context).pushNamedAndRemoveUntil("/walkthrough", (route) => false);
  }
}
