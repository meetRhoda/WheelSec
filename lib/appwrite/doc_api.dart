import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import '../hive/unique_code.dart';
import '../main.dart';
import '../others/constants.dart';

class DocAPI {
  Future<String> checkUniqueCode(String code) async {
    final client = Client()
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID);

    final databases = Databases(client);
    String response = "failure";

    try {
      final documentList = await databases.listDocuments(
        databaseId: appWriteDatabaseID,
        collectionId: codesCollectionId,
        queries: [
          Query.equal("code", [code])
        ]
      );

      Map docsMap = documentList.toMap();
      List codes = docsMap["documents"];
      if(codes.isNotEmpty) {
        Map location = codes[0];
        Map details = location["data"];
        codeBox.put("uniqueCode", UniqueCode(branch: details["branch"], address: details["address"]));
        response = "success";
      }
    } on AppwriteException catch(e) {
      response = "Error: ${e.message ?? "Unknown error"}";
    }
    return response;
  }

  // Get all vehicles
  Future<List> getVehicles() async {
    final client = Client()
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID);

    final databases = Databases(client);
    List result = [];

    try {
      final documentList = await databases.listDocuments(
        databaseId: appWriteDatabaseID,
        collectionId: vehiclesCollectionId,
      );

      Map docsMap = documentList.toMap();
      List vehicles = docsMap["documents"];
      if(vehicles.isNotEmpty) {
        result = vehicles;
      }
    } on AppwriteException catch(e) {
      log(e.message.toString());
    }
    return result;
  }

  // Get all reported vehicles
  Future<List> getReportedVehicles({required List vehicleIDs}) async {
    final client = Client()
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID);

    final databases = Databases(client);
    List result = [];

    List<String>? idQueries = [];
    for (String id in vehicleIDs) {
      idQueries.add(Query.equal("\$id", id));
    }

    try {
      final documentList = await databases.listDocuments(
        databaseId: appWriteDatabaseID,
        collectionId: vehiclesCollectionId,
        queries: [
          Query.or(idQueries),
        ],
      );

      Map docsMap = documentList.toMap();
      List vehicles = docsMap["documents"];
      if(vehicles.isNotEmpty) {
        result = vehicles;
      }
    } on AppwriteException catch(e) {
      log(e.message.toString());
    }
    return result;
  }

  // Get all reports
  Future<List> getReports() async {
    final client = Client()
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID);

    final databases = Databases(client);
    List result = [];

    try {
      final documentList = await databases.listDocuments(
        databaseId: appWriteDatabaseID,
        collectionId: reportCollectionId,
      );

      Map docsMap = documentList.toMap();
      List reports = docsMap["documents"];
      if(reports.isNotEmpty) {
        result = reports;

        // Extract reports
        List formattedReports = [];
        for (Map data in result) {
          formattedReports.add(data["data"]);
        }

        // Extract vehicle IDs
        List vehicleIds = [];
        for (Map report in formattedReports) {
          vehicleIds.add(report["vehicleId"]);
        }

        await getReportedVehicles(vehicleIDs: vehicleIds).then((allReports) {
          result = allReports;
        });
      }
    } on AppwriteException catch(e) {
      log(e.message.toString());
    }
    return result;
  }

  // Search vehicle
  Future<List> searchVehicles(String keyword) async {
    final client = Client()
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID);

    final databases = Databases(client);
    List result = [];

    try {
      final documentList = await databases.listDocuments(
        databaseId: appWriteDatabaseID,
        collectionId: vehiclesCollectionId,
        queries: [
          Query.or([
            Query.search("manufacturer", keyword),
            Query.search('model', keyword),
            Query.search("plateNo", keyword),
            Query.equal('manufacturer', keyword),
            Query.equal('model', keyword),
            Query.equal('plateNo', keyword),
            Query.contains('manufacturer', keyword),
            Query.contains('model', keyword),
            Query.contains('plateNo', keyword),
          ]),
        ]
      );

      Map docsMap = documentList.toMap();
      List vehicles = docsMap["documents"];
      if(vehicles.isNotEmpty) {
        result = vehicles;
      }
    } on AppwriteException catch(e) {
      log(e.message.toString());
    }
    return result;
  }

  // Search reports
  Future<List> searchReports(String userId, String keyword) async {
    final client = Client()
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID);

    final databases = Databases(client);
    List result = [];

    try {
      final documentList = await databases.listDocuments(
          databaseId: appWriteDatabaseID,
          collectionId: reportCollectionId,
          queries: [
            Query.equal("reporter", userId),
            Query.or([
              Query.search("vehicleName", keyword),
              Query.search("plateNo", keyword),
              Query.equal('vehicleName', keyword),
              Query.equal('plateNo', keyword),
              Query.contains('vehicleName', keyword),
              Query.contains('plateNo', keyword),
            ]),
          ]
      );

      Map docsMap = documentList.toMap();
      List reports = docsMap["documents"];
      if(reports.isNotEmpty) {
        result = reports;

        // Extract reports
        List formattedReports = [];
        for (Map data in result) {
          formattedReports.add(data["data"]);
        }

        // Extract vehicle IDs
        List vehicleIds = [];
        for (Map report in formattedReports) {
          vehicleIds.add(report["vehicleId"]);
        }

        await getReportedVehicles(vehicleIDs: vehicleIds).then((allReports) {
          result = allReports;
        });
      }
    } on AppwriteException catch(e) {
      log(e.message.toString());
    }
    return result;
  }

  // Update vehicle
  Future<String> updateVehicle({required String img, required String status, required String manufacturer,
    required String model, required String updateDate, required String plateNo,
    required String type, required String docs, required String vehicleId}) async {
    Map data = {
      "img": img,
      "status": status,
      "manufacturer": manufacturer,
      "model": model,
      "updateDate": updateDate,
      "plateNo": plateNo,
      "type": type,
      "docs": docs,
    };

    final client = Client()
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID);

    final databases = Databases(client);

    try {
      await databases.updateDocument(
          databaseId: appWriteDatabaseID,
          collectionId: vehiclesCollectionId,
          documentId: vehicleId,
          data: data
      );

      return "success";
    } on AppwriteException catch(e) {
      return e.message.toString();
    }
  }

  // Report vehicle
  Future<String> reportVehicle({required String userId, required String manufacturer,
    required String model, required String plateNo, required String vehicleId}) async {
    Map data = {
      "reporter": userId,
      "vehicleId": vehicleId,
      "vehicleName" : "$manufacturer $model",
      "plateNo": plateNo,
    };

    final client = Client()
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID);

    final databases = Databases(client);

    try {
      await databases.createDocument(
          databaseId: appWriteDatabaseID,
          collectionId: reportCollectionId,
          documentId: ID.unique(),
          data: data
      );

      return "success";
    } on AppwriteException catch(e) {
      return e.message.toString();
    }
  }
}