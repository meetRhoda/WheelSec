import 'package:flutter/material.dart';
import '../others/constants.dart';

class BottomNavBar extends StatelessWidget {
  final List<BottomNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double height;
  final double selectedFontSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final FontWeight selectedItemWeight;
  final FontWeight unSelectedItemWeight;
  final Color backgroundColor;

  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height = 82.0, // Default height, adjust as needed
    this.selectedFontSize = 12.0,
    this.selectedItemColor = const Color(0xFF1D3557),
    this.unselectedItemColor = const Color(0xFF8E8A94),
    this.selectedItemWeight = FontWeight.w600,
    this.unSelectedItemWeight = FontWeight.w400,
    this.backgroundColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    double btmSafeArea = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: surfaceContainer,
        boxShadow: const [
          BoxShadow(
            color: Color(0x66C8C8C8), // #C8C8C8 with 40% opacity
            offset: Offset(0, -1), // X: 0, Y: -1
            blurRadius: 8, // Blur radius of 8
            spreadRadius: 0, // Spread radius of 0
          ),
        ],
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 10.0, bottom: btmSafeArea,),
      height: height + btmSafeArea,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          BottomNavBarItem item = entry.value;
          bool isSelected = currentIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: isSelected ? item.activeIcon : item.icon,
                  ),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isSelected ? selectedItemWeight : unSelectedItemWeight,
                      fontSize: selectedFontSize,
                      color: isSelected ? selectedItemColor : unselectedItemColor,
                    ),
                  ),
                  const SizedBox(height: 8.0,),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BottomNavBarItem {
  final Widget activeIcon;
  final Widget icon;
  final String label;

  BottomNavBarItem({
    required this.activeIcon,
    required this.icon,
    required this.label,
  });
}