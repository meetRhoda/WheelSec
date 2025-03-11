import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheelsec/others/constants.dart';
import 'package:wheelsec/screens/bottom_navigation/profile.dart';
import '../../custom_widgets/bottom_nav_bar.dart';
import '../../hive/details.dart';
import '../../main.dart';
import 'history.dart';
import 'home.dart';

String userName = "";
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  final screens = [
    const Home(),
    const History(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _getUserDetails();

    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pageIndex = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
    if (pageIndex == 1) {
      setState(() {
        currentIndex = 1;
      });
    }
  }

  @override
  void dispose() {
    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      body: Stack(
        children: [
          screens[currentIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavBar(
              height: btmNavHeight,
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              selectedFontSize: 12.0,
              selectedItemColor: primary,
              backgroundColor: surfaceContainer,
              items: [
                BottomNavBarItem(
                  activeIcon: SvgPicture.asset(
                    "assets/icons/home_solid.svg",
                    colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                    height: 24.0,
                    width: 24.0,
                  ),
                  icon: SvgPicture.asset(
                    "assets/icons/home.svg",
                    height: 24.0,
                    width: 24.0,
                  ),
                  label: "Home",
                ),
                BottomNavBarItem(
                  activeIcon: SvgPicture.asset(
                    "assets/icons/history_solid.svg",
                    colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                    height: 24.0,
                    width: 24.0,
                  ),
                  icon: SvgPicture.asset(
                    "assets/icons/history.svg",
                    height: 24.0,
                    width: 24.0,
                  ),
                  label: "History",
                ),
                BottomNavBarItem(
                  activeIcon: SvgPicture.asset(
                    "assets/icons/profile_solid.svg",
                    colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                    height: 24.0,
                    width: 24.0,
                  ),
                  icon: SvgPicture.asset(
                    "assets/icons/profile.svg",
                    height: 24.0,
                    width: 24.0,
                  ),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getUserDetails() {
    Details details = boxDetails.get("details");
    userName = details.name;
  }
}
