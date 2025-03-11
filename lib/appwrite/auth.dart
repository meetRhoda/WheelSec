import 'dart:io' show Platform;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wheelsec/hive/unique_code.dart';
import '../hive/details.dart';
import '../main.dart';
import '../others/constants.dart';

class Auth {
  final _storage = const FlutterSecureStorage();
  Client client = Client();
  late final Account account;

  Auth() {
    init();
  }

  // Initialize the Appwrite client
  void init() {
    client
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID)
        .setSelfSigned();
    account = Account(client);
  }

//Create new user with email & password
  Future<String> createUser({required String email, required String password, required String fullName}) async {
    try {
      String generatedId = ID.unique();

      await account.create(
        userId: generatedId,
        email: email,
        password: password,
        name: fullName
      );

      await _storage.write(key: "userId", value: generatedId);
      return "success";
    } on AppwriteException catch(e) {
      return e.type.toString();
    }
  }

//Sign in user with email & password
  Future<String> signInUser({required String email, required String password}) async {
    String response = "failure";
    try {
      await account.createEmailPasswordSession(
        email: email, password: password,
      );

      final user = await account.get();

      if (Platform.isAndroid) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await account.createPushTarget(
          targetId: "alert",
          identifier: fcmToken!,
          providerId: fcmProviderID,
        );
      }

      if (user.emailVerification) {
        final user = await account.get();

        String branch = "";
        String address = "";
        Map prefs = await getPrefs();
        if (prefs.isNotEmpty) {
          branch = prefs["branch"];
          address = prefs["address"];
        }
        boxDetails.put(
          "details",
          Details(
            name: user.name,
            email: user.email,
            branch: branch,
            address: address,
          ),
        );

        response = "success";
      } else {
        response = "verify";
      }
      return response;
    } on AppwriteException catch (e) {
      return e.message.toString();
    }
  }

// Send verification mail to the user
  Future<String> sendOTP({required String userId, required String email}) async {
    try {
      await account.createEmailToken(
        userId: userId,
        email: email,
        phrase: false, // optional
      );
      return "success";
    } on AppwriteException catch (e) {
      return e.message.toString();
    }
  }

// Verify OTP
  Future<String> verifyOTP({required String userId, required String otp}) async {
    try {
      await account.createSession(
          userId: userId,
          secret: otp
      );

      if (Platform.isAndroid) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await account.createPushTarget(
          targetId: "alert",
          identifier: fcmToken!,
          providerId: fcmProviderID,
        );
      }

      UniqueCode savedCode = codeBox.get("uniqueCode");
      String branch = savedCode.branch;
      String address = savedCode.address;
      Map details = {
        "branch": branch,
        "address": address
      };

      final user = await account.get();
      await updatePrefs(pref: details);
      boxDetails.put(
        "details",
        Details(
          name: user.name,
          email: user.email,
          branch: branch,
          address: address,
        ),
      );

      return "success";
    } on AppwriteException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // Get user's details
  Future<Map> getUser() async {
    try {
      final user = await account.get();
      Map userDetails = {
        "id": user.$id,
        "name": user.name,
        "email": user.email,
      };
      return userDetails;
    } catch (e) {
      return {};
    }
  }

  // Change password
  Future<String> changePassword(String oldPassword, String password) async {
    try {
      await account.updatePassword(
        password: password,
        oldPassword: oldPassword, // (optional)
      );
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

// Get user preferences
  Future<Map> getPrefs() async {
    try {
      final prefs = await account.getPrefs();
      return prefs.data;
    } catch (e) {
      return {};
    }
  }

// Update user preferences
  Future<User?> updatePrefs({required Map pref}) async {
    try {
      final user = await account.updatePrefs(
          prefs: pref
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await account.deleteSession(sessionId: 'current');
  }
}