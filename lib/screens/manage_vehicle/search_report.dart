import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wheelsec/appwrite/auth.dart';
import 'package:wheelsec/others/constants.dart';

import '../../appwrite/doc_api.dart';
import '../../others/global_functions.dart';
import '../../others/shimmer_effect.dart';

class SearchReport extends StatefulWidget {
  const SearchReport({super.key});

  @override
  State<SearchReport> createState() => _SearchReportState();
}

class _SearchReportState extends State<SearchReport> {
  final Auth _auth = Auth();
  final DocAPI _docAPI = DocAPI();
  late Future<List<dynamic>> _searchResult;
  bool _searching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double btmPadding = MediaQuery.of(context).padding.bottom;
    btmPadding = btmPadding + spacingEight + btmNavHeight;

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: surface,
        leading: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: hPadding,
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            autofocus: true,
            style: TextStyle(
              color: onSurfaceContainer,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0, horizontal: hPadding,
              ),
              prefixIcon: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: spacingFive, right: spacingFive),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(),
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
            onSubmitted: (String keyword) async {
              if(keyword.trim().isNotEmpty) {
                final userDetails = await _auth.getUser();
                String userId = userDetails["id"];

                setState(() {
                  _searching = true;
                });
                _searchResult = _docAPI.searchReports(userId, keyword);
              }
            },
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
          ),
        ), // Search box
        leadingWidth: double.infinity,
      ),
        body: !_searching
            ? Container()
            : Shimmer(
              linearGradient: shimmerGradient,
              child: FutureBuilder<List<dynamic>>(
                future: _searchResult,
                builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ShimmerLoading(
                      isLoading: true,
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          hPadding, hPadding,
                          hPadding, btmPadding,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                height: 200.0,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: const Color(0x44FFFFFF),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 88.0,
                                    height: 12.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ), // Make & model
                                  Container(
                                    width: 64.0,
                                    height: 12.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ), // Last update date
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: spacingNine,);
                        },
                        itemCount: 5,
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
                    // Handle errors
                    return const ShimmerLoading(
                      isLoading: false,
                      child: Center(
                        child: Text(
                          "Error finding vehicle",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    );
                  }
                  else if (snapshot.hasData) {
                    List<dynamic> result = snapshot.data!;
                    if (result.isNotEmpty) {
                      return ShimmerLoading(
                        isLoading: false,
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            hPadding, hPadding,
                            hPadding, btmPadding,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                _goDetails(context, result[index]["data"]);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          result[index]["data"]["img"],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: const Color(0x44FFFFFF),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${result[index]["data"]["manufacturer"]} ${result[index]["data"]["model"]}",
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ), // Make & model
                                      Text(
                                        formatDateTime(result[index]["data"]["updateDate"]),
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ), // Last update date
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: spacingNine,);
                          },
                          itemCount: result.length,
                        ),
                      );
                    } else {
                      return const ShimmerLoading(
                        isLoading: false,
                        child: Center(
                          child: Text(
                            "No vehicle found",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  else {
                    // No data state
                    return const ShimmerLoading(
                      isLoading: false,
                      child: Center(
                        child: Text(
                          "No vehicle found",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }

  void _goDetails(BuildContext context, Map details) {
    Navigator.of(context).pushNamed(
      "/vehicle details",
      arguments: details,
    );
  }
}
