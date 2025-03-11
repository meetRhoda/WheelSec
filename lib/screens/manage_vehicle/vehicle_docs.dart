import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:wheelsec/others/constants.dart';

class VehicleDocs extends StatefulWidget {
  final List documents;
  const VehicleDocs({super.key, required this.documents});

  @override
  State<VehicleDocs> createState() => _VehicleDocsState();
}

class _VehicleDocsState extends State<VehicleDocs> {
  final DateTime _today = DateTime.now();
  late List _vehicleDocs;

  // Track the index of the loading document
  int? _loadingDocIndex;

  @override
  void initState() {
    _vehicleDocs = widget.documents;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          hPadding, hPadding,
          hPadding, hPadding,
        ),
        child: Column(
          children: _vehicleDocs.asMap().entries.map((entry) {
            int index = entry.key;
            var doc = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: spacingSix),
              child: IgnorePointer(
                // Only ignore tapping for non-loading documents when a document is loading
                ignoring: _loadingDocIndex != null && _loadingDocIndex != index,
                child: Opacity(
                  // Dim opacity for non-loading documents
                  opacity: _loadingDocIndex != null && _loadingDocIndex != index ? 0.3 : 1.0,
                  child: GestureDetector(
                    onTap: () {
                      // Set loading state for this specific document
                      setState(() {
                        _loadingDocIndex = index;
                      });

                      _previewFile(doc["url"]).whenComplete(() {
                        // Reset loading state
                        setState(() {
                          _loadingDocIndex = null;
                        });
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/attachment.svg",
                          colorFilter: ColorFilter.mode(
                            _expired(doc["expiryDate"]) ? error : success,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: spacingThree,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc["name"],
                                style: TextStyle(
                                  color: onSurface,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                _checkExpiration(doc["expiryDate"]),
                                style: TextStyle(
                                  color: onSurfaceVariant,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Show loading indicator or download icon based on loading state
                        _loadingDocIndex == index
                            ? SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: CircularProgressIndicator(
                                color: primary,
                                strokeWidth: 2.5,
                              ),
                            )
                            : SvgPicture.asset("assets/icons/cloud_download.svg"),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<bool> _previewFile(String imageUrl) async {
    bool response = false;
    // Preload the image
    await precacheImage(
      CachedNetworkImageProvider(imageUrl),
      context,
    ).then((_) {
      // Image is fully loaded, now show the dialog
      _filePopup(imageUrl);
      response = true;

    }).catchError((_) {
      response = true;
    });
    return response;
  }

  void _filePopup(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) {
            return const Center(
              child: Icon(Icons.error, color: Colors.red),
            );
          },
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       completer.complete(true);
        //       Navigator.of(context).pop();
        //     },
        //     child: Text('Close'),
        //   ),
        // ],
      ),
    );
  }

  String _checkExpiration(String inputDate) {
    DateTime expDate = DateTime.parse(inputDate);
    String today = _today.toString().split(' ')[0];
    DateTime fToday = DateTime.parse(today);

    // Format the date in dd/MM/yyyy format
    String formattedDate = DateFormat('dd/MM/yyyy').format(expDate);

    if (expDate.isBefore(fToday)) {
      return "Expired on $formattedDate";
    } else {
      return "Expires on $formattedDate";
    }
  }

  bool _expired(String inputDate) {
    DateTime expDate = DateTime.parse(inputDate);
    String today = _today.toString().split(' ')[0];
    DateTime fToday = DateTime.parse(today);

    return expDate.isBefore(fToday);
  }
}