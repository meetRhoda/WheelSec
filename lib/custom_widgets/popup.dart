import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheelsec/appwrite/auth.dart';
import 'package:wheelsec/appwrite/doc_api.dart';
import 'package:wheelsec/custom_widgets/show_flush_bar.dart';
import 'package:wheelsec/others/constants.dart';
import 'package:wheelsec/screens/bottom_navigation/bottom_nav.dart';

import '../appwrite/notification_api.dart';
import '../others/global_functions.dart';
import '../others/network_utils.dart';

class Popup extends StatelessWidget {
  final Auth _auth = Auth();
  final DocAPI _docAPI = DocAPI();
  final NotificationAPI _notificationAPI = NotificationAPI();
  final String title, content, actionOne, actionTwo, report;
  final OverlayPortalController overlayController;
  final BuildContext detailsContext;
  final Map details;
  Popup({
    super.key, required this.title, required this.content,
    required this.actionOne, required this.actionTwo,
    required this.overlayController, required this.detailsContext,
    required this.report, required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        content,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text(
            actionOne,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: error,
            ),
          ),
        ),
        CupertinoDialogAction(
            onPressed: () async {
              Navigator.of(context).pop();
              overlayController.show();
              bool isConnected = await checkConnectivity(); // Check internet Connectivity
              if(isConnected) {
                final userDetails = await _auth.getUser();
                String userId = userDetails["id"];

                // Update vehicle status
                String response = await _docAPI.updateVehicle(
                  img: details["img"], status: report,
                  manufacturer: details["manufacturer"], model: details["model"],
                  updateDate: details["updateDate"], plateNo: details["plateNo"],
                  type: details["type"], docs: details["docs"], vehicleId: details["\$id"],
                );

                if (response == "success") {
                  // Report vehicle
                  String reportResponse = await _docAPI.reportVehicle(
                    userId: userId, manufacturer: details["manufacturer"],
                    model: details["model"], plateNo: details["plateNo"],
                    vehicleId: details["\$id"],
                  );

                  if (reportResponse == "success") {
                    _notificationAPI.sendNotification().whenComplete(() {
                      overlayController.hide();

                      Navigator.of(detailsContext).pushNamedAndRemoveUntil(
                          "/bottom nav",
                              (route) => false,
                          arguments: 1
                      );
                    });
                  }
                  else {
                    _showError("Report failed", response);
                  }
                } else {
                  _showError("Report failed", response);
                }
              } else {
                _showError(
                  "Connection Error",
                  "Unable to connect to the internet. Please check your network settings and try again.",
                );
              }
            },
            child: Text(
              actionTwo,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            )
        ),
      ],
    );
  }

  void _showError(String title, String response) {
    overlayController.hide();

    showFlushBar(
      context: detailsContext,
      title: title,
      message: response,
      state: "error",
    );
  }

  // void _goHistory() {
  //   Navigator.pushNamedAndRemoveUntil(detailsContext, "/bottom nav", (route) => false);
  // }
}
