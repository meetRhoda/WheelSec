import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wheelsec/others/constants.dart';
import 'package:wheelsec/screens/manage_vehicle/vehicle_docs.dart';
import 'package:wheelsec/screens/manage_vehicle/vehicle_info.dart';
import '../../custom_widgets/popup.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({super.key});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final PageController _pageController = PageController(initialPage: 0);
  int _currentTab = 0;
  late List<Widget> _tabs;
  late Map _vehicleDetails;

  @override
  void didChangeDependencies() {
    _vehicleDetails = ModalRoute.of(context)?.settings.arguments as Map;
    _tabs = [
      VehicleInfo(
        details: _vehicleDetails
      ),
      VehicleDocs(
        documents: jsonDecode(_vehicleDetails["docs"])
      ),
    ];

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: surfaceContainer,
        leading: IconButton(
          onPressed: (){
            // Navigator.of(context).pop();
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/bottom nav",
                    (route) => false,
                arguments: 1
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Vehicle details",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_vehicleDetails["status"] == "Clear") {
                _reportAsStolen(context);
              } else {
                _reportAsClear(context);
              }
            },
            icon: SvgPicture.asset("assets/icons/alert.svg"),
          )
        ],
      ),
      body: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.6),
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                color: primary,
              ),
            ),
          );
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              stretch: true,
              expandedHeight: 320.0,
              toolbarHeight: 0,
              collapsedHeight: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: CachedNetworkImage(
                    imageUrl: _vehicleDetails["img"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Container(
                  height: 60.0,
                  color: dividerBkg,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ColoredBox(
                          color: _currentTab == 0 ? activeTabBkg : Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/info.svg",
                                  colorFilter: ColorFilter.mode(
                                    _currentTab == 0 ? primary : formBorderColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: spacingThree,),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    "Details",
                                    style: TextStyle(
                                      color: _currentTab == 0 ? primary : formBorderColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ColoredBox(
                          color: _currentTab == 1 ? activeTabBkg : Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/documents.svg",
                                  colorFilter: ColorFilter.mode(
                                    _currentTab == 1 ? primary : formBorderColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: spacingThree,),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    "Documents",
                                    style: TextStyle(
                                      color: _currentTab == 1 ? primary : formBorderColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ), // Actions
              ),
            ), // Vehicle image
            SliverLayoutBuilder(
              builder: (BuildContext context, SliverConstraints constraints) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - (320.0 - kToolbarHeight),           // SliverAppBar height (320) + bottom tab height (60)
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (int page) {
                        setState(() {
                          _currentTab = page;
                        });
                      },
                      children: _tabs,
                    ),
                  ),
                );
              },
            ) // Vehicle details
          ],
        ),
      )
    );
  }

  void _reportAsStolen(BuildContext buildContext) {
    String title = "Report as stolen";
    String content = "Please, confirm that this vehicle has been stolen. Note that false report is highly punishable and will put your job at risk.";
    String actionOne = "Cancel";
    String actionTwo = "Report";
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return Popup(
          title: title,
          content: content,
          actionOne: actionOne,
          actionTwo: actionTwo,
          overlayController: _overlayController,
          detailsContext: buildContext,
          report: "Stolen",
          details: _vehicleDetails,
        );
      },
    );
  }

  void _reportAsClear(BuildContext context) {
    String title = "Report as found";
    String content = "Please, confirm that this vehicle has been found. Note that false report is highly punishable and will put your job at risk.";
    String actionOne = "Cancel";
    String actionTwo = "Report";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Popup(
          title: title,
          content: content,
          actionOne: actionOne,
          actionTwo: actionTwo,
          overlayController: _overlayController,
          detailsContext: context,
          report: "Clear",
          details: _vehicleDetails,
        );
      },
    );
  }
}
