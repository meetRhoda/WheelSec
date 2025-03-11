import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheelsec/custom_widgets/popup.dart';
import 'package:wheelsec/others/constants.dart';
import 'package:wheelsec/others/global_functions.dart';

class VehicleInfo extends StatelessWidget {
  final Map details;
  VehicleInfo({super.key, required this.details});

  final Map slogans = {
    "Abia": "God's Own State",
    "Adamawa": "Land of Beauty",
    "Akwa Ibom": "Land of Promise",
    "Anambra": "Light of the Nation",
    "Bauchi": "Pearl of Tourism",
    "Bayelsa": "Glory of All Lands",
    "Benue": "Food Basket of the Nation",
    "Borno": "Home of Peace",
    "Cross River": "The Paradise",
    "Delta": "The Big Heart",
    "Ebonyi": "Salt of the Nation",
    "Edo": "Heart Beat of Nigeria",
    "Ekiti": "Land of Honour",
    "Enugu": "Coal City State",
    "Gombe": "Jewel in the Savannah",
    "Imo": "Land of Hope",
    "Jigawa": "The New Frontier of Sustainable Development",
    "Kaduna": "Centre of Learning",
    "Kano": "Centre of Commerce",
    "Katsina": "Home of Hospitality",
    "Kebbi": "Land of Equity and Justice",
    "Kogi": "Confluence State",
    "Kwara": "State of Harmony",
    "Lagos": "Centre of Excellence",
    "Nasarawa": "Home of Solid Minerals",
    "Niger": "Power State",
    "Ogun": "Gateway State",
    "Ondo": "Sunshine State",
    "Osun": "State of the Living Spring",
    "Oyo": "Pace Setter State",
    "Plateau": "Home of Peace and Tourism",
    "Rivers": "Treasure Base of the Nation",
    "Sokoto": "The Seat of the Caliphate",
    "Taraba": "Nature's Gift to the Nation",
    "Yobe": "The Young Shall Grow",
    "Zamfara": "Farming is Our Pride",
    "FCT Abuja": "Centre of Unity"
  };

  @override
  Widget build(BuildContext context) {
    Map plateNoInfo = jsonDecode(details["plateNo"]);
    String state = plateNoInfo["state"];
    String plateNo = plateNoInfo["no"];
    String status = details["status"];

    return Scaffold(
      backgroundColor: surface,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          0, hPadding,
          0, hPadding,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: hPadding),
              child: Stack(
                children: [
                  SvgPicture.asset("assets/illustrations/license_plate.svg"),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          state.toUpperCase(),
                          style: GoogleFonts.robotoSlab(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          slogans[state].toUpperCase(),
                          style: GoogleFonts.robotoSlab(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 30, bottom: 0,
                    left: 0, right: 0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            plateNo.substring(0, 3).toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF2343FD),
                              fontFamily: "LicensePlateUSA",
                              fontSize: 60.0,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: spacingSix),
                            child: Text(
                              " – ",
                              style: TextStyle(
                                color: Color(0xFF2343FD),
                                fontSize: 60.0,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                          Text(
                            plateNo.substring(plateNo.length - 5, plateNo.length).toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF2343FD),
                              fontFamily: "LicensePlateUSA",
                              fontSize: 60.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ), // Plate number
            const SizedBox(height: spacingFive),
            Container(
              height: 56.0,
              color: dividerBkg,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0, right: 0, bottom: 0,
                    child: SvgPicture.asset("assets/illustrations/vehicle.svg"),
                  ),
                  Positioned(
                    left: hPadding,
                    top: 0, bottom: 0,
                    child: Center(
                      child: Text(
                        "KEY INFORMATION",
                        style: TextStyle(
                          color: onSurface,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ), // Key Information
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(hPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vehicle type",
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ), // Vehicle type
                            const SizedBox(width: spacingThree,),
                            SvgPicture.asset("assets/icons/car.svg"),
                          ],
                        ), // Vehicle type & icon
                        Text(
                          details["type"],
                          style: TextStyle(
                            color: primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ), // Vehicle type info
                      ],
                    ),
                  ),
                ), // Vehicle type
                SizedBox(
                  height: 84.0,
                  child: VerticalDivider(
                    width: 1.0,
                    thickness: 1.0,
                    color: dividerColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(hPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ), // Vehicle type
                            const SizedBox(width: spacingThree,),
                            SvgPicture.asset(
                              "assets/icons/status.svg",
                              colorFilter: ColorFilter.mode(
                                status == "Clear" ? success : error,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ), // Status & icon
                        Text(
                          status,
                          style: TextStyle(
                            color: primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ), // Status info
                      ],
                    ),
                  ),
                ), // Status
              ],
            ), // Vehicle type & Status
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: dividerColor,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(hPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Manufacturer",
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ), // Vehicle type
                            const SizedBox(width: spacingThree,),
                            SvgPicture.asset("assets/icons/factory.svg"),
                          ],
                        ), // Manufacturer & icon
                        Text(
                          details["manufacturer"],
                          style: TextStyle(
                            color: primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ), // // Manufacturer info
                      ],
                    ),
                  ),
                ), // Manufacturer
                SizedBox(
                  height: 84.0,
                  child: VerticalDivider(
                    width: 1.0,
                    thickness: 1.0,
                    color: dividerColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(hPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Model",
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ), // Model
                            const SizedBox(width: spacingThree,),
                            SvgPicture.asset("assets/icons/tag.svg"),
                          ],
                        ), // Model & icon
                        Text(
                          details["model"],
                          style: TextStyle(
                            color: primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ), // Model info
                      ],
                    ),
                  ),
                ), // Model
              ],
            ), // Manufacturer & Model
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: dividerColor,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(hPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Last updated",
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ), // Vehicle type
                            const SizedBox(width: spacingThree,),
                            SvgPicture.asset("assets/icons/calendar_dot.svg"),
                          ],
                        ), // // Last updated & icon
                        Text(
                          formatDateTime(details["updateDate"]),
                          style: TextStyle(
                            color: primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ), // // Last updated date
                      ],
                    ),
                  ),
                ), // Last updated
                SizedBox(
                  height: 84.0,
                  child: VerticalDivider(
                    width: 1.0,
                    thickness: 1.0,
                    color: dividerColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(hPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Plate number",
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ), // Plate number
                            const SizedBox(width: spacingThree,),
                            SvgPicture.asset("assets/icons/id_card.svg"),
                          ],
                        ), // Plate number & icon
                        Text(
                          plateNo,
                          style: TextStyle(
                            color: primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ), // Plate number info
                      ],
                    ),
                  ),
                ), // Plate number
              ],
            ), // Last updated & Plate number
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}
