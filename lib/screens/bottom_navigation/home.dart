import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelsec/others/constants.dart';
import 'package:wheelsec/screens/manage_vehicle/search_vehicle.dart';

import '../../others/global_functions.dart';
import 'bottom_nav.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: surface,
        leading: Row(
          children: [
            const SizedBox(width: hPadding,),
            CircleAvatar(
              backgroundColor: const Color(0xFFC34A3D),
              radius: 18.0,
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
          ],
        ),
        leadingWidth: double.maxFinite,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: spacingFive, horizontal: hPadding,
        ),
        child: Column(
          children: [
            Text(
              "Welcome back",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ), // Welcome back
            const SizedBox(height: spacingOne,),
            Text(
              _getDate(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurfaceVariant,
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
              ),
            ), // Current date
            const SizedBox(height: spacingSix,),
            Hero(
              tag: "search",
              child: Material(
                type: MaterialType.transparency,
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: onSurfaceContainer,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: hPadding,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: spacingFive),
                      child: SvgPicture.asset("assets/icons/search.svg"),
                    ),
                    suffixIconConstraints: const BoxConstraints.tightFor(),
                    filled: true,
                    fillColor: const Color(0xFFF0F3F6),
                    hintText: "Search for vehicle...",
                    hintStyle: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      height: 1.6,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFEFEFEF),),
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                      borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                    ),
                  ),
                  onTap: () {
                    _goSearch();
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ), // Search box
            const SizedBox(height: spacingEight,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/animation/scan.json"),
                const SizedBox(height: spacingSix,),
                FilledButton(
                  onPressed: () => _goScan(),
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: onPrimary,
                    padding: const EdgeInsets.fromLTRB(
                      hPadding, spacingThree,
                      hPadding, spacingFour,
                    )
                  ),
                  child: const Text(
                    "Start scanning",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: stickyBtnSpacing,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _goSearch() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) => const SearchVehicle(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(animation),
            child: child,
          );
        },
      ),
    );

  }

  void _goScan() {
    Navigator.of(context).pushNamed("/scan");
  }

  String _getDate() {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(date);
    return formattedDate;
  }
}
