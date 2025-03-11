import 'package:firebase_core/firebase_core.dart';
import 'package:wheelsec/hive/unique_code.dart';
import 'package:wheelsec/screens/bottom_navigation/scan_plate_no.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wheelsec/screens/bottom_navigation/bottom_nav.dart';
import 'package:wheelsec/screens/forgot_password_flow/forgot_password.dart';
import 'package:wheelsec/screens/forgot_password_flow/new_password.dart';
import 'package:wheelsec/screens/forgot_password_flow/password_success.dart';
import 'package:wheelsec/screens/forgot_password_flow/verify_forgot.dart';
import 'package:wheelsec/screens/manage_vehicle/search_vehicle.dart';
import 'package:wheelsec/screens/manage_vehicle/vehicle_details.dart';
import 'package:wheelsec/screens/onboarding/account_set.dart';
import 'package:wheelsec/screens/onboarding/create_account.dart';
import 'package:wheelsec/screens/onboarding/log_in.dart';
import 'package:wheelsec/screens/onboarding/splash_screen.dart';
import 'package:wheelsec/screens/onboarding/verify_email.dart';
import 'package:wheelsec/screens/onboarding/walkthrough.dart';
import 'package:wheelsec/screens/profile/edit_profile.dart';

import 'appwrite/auth.dart';
import 'hive/details.dart';
import 'hive/label.dart';
import 'notification_service.dart';
import 'others/global_functions.dart';

late Box codeBox;
late Box labelBox;
late Box boxDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notification service
  NotificationService();
  await Hive.initFlutter();
  Hive.registerAdapter(LabelAdapter());
  labelBox = await Hive.openBox<Label>('label');
  Hive.registerAdapter(DetailsAdapter());
  boxDetails = await Hive.openBox<Details>("detailsBox");
  Hive.registerAdapter(UniqueCodeAdapter());
  codeBox = await Hive.openBox<UniqueCode>("uniqueCode");
  WidgetsFlutterBinding.ensureInitialized();
  Auth();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WheelSec",
      theme: ThemeData(
          fontFamily: "PolySans"
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/walkthrough": (context) => const Walkthrough(),
        "/create account": (context) => const CreateAccount(),
        "/verify email": (context) => const VerifyEmail(),
        "/account set": (context) => const AccountSet(),
        "/log in": (context) => const LogIn(),
        "/forgot password": (context) => const ForgotPassword(),
        "/verify forgot": (context) => const VerifyForgot(),
        "/edit profile": (context) => const EditProfile(),
        "/new password": (context) => const NewPassword(),
        "/password success": (context) => const PasswordSuccess(),
        "/bottom nav": (context) => const BottomNav(),
        "/search vehicle": (context) => const SearchVehicle(),
        "/scan": (context) => const ScanPlateNo(),
        "/vehicle details": (context) => const VehicleDetails(),
      },
    );
  }
}
