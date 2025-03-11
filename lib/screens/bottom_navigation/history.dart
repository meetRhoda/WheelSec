import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheelsec/appwrite/auth.dart';
import 'package:wheelsec/others/global_functions.dart';
import 'package:wheelsec/others/shimmer_effect.dart';
import 'package:wheelsec/screens/manage_vehicle/search_report.dart';
import '../../appwrite/doc_api.dart';
import '../../others/constants.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final DocAPI _docAPI = DocAPI();
  late Future<List<dynamic>> _vehicles;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _vehicles = _getReports();

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double btmPadding = MediaQuery.of(context).padding.bottom;
    btmPadding = btmPadding + spacingEight + btmNavHeight;

    return Shimmer(
      linearGradient: shimmerGradient,
      child: Scaffold(
          backgroundColor: surface,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: const Padding(
              padding: EdgeInsets.only(bottom: spacingTwo),
              child: Text(
                "Reports history",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () => _goSearch(),
              icon: SvgPicture.asset("assets/icons/search.svg"),
            ),
            leadingWidth: 44.0,
            centerTitle: true,
            backgroundColor: surfaceContainer,
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_outlined))
            ],
          ),
          body: FutureBuilder<List<dynamic>>(
            future: _vehicles,
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
                return const ListTile(
                  title: Text(
                    "Error loading data",
                    style: TextStyle(color: Colors.red, fontSize: 16.0),
                  ),
                );
              }
              else if (snapshot.hasData) {
                List<dynamic> result = snapshot.data!;
                return ListView.separated(
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
                );
              }
              else {
                // No data state
                return const ListTile(
                  title: Text("No data available"),
                );
              }
            },
          ),
      ),
    );
  }

  Future<List<dynamic>> _getReports() async {
    final result = _docAPI.getReports();
    return result;
  }

  void _goSearch() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) => const SearchReport(),
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

  void _goDetails(BuildContext context, Map details) {
    Navigator.of(context).pushReplacementNamed(
      "/vehicle details",
      arguments: details,
    );
  }
}
