import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wheelsec/others/constants.dart';

import '../../appwrite/auth.dart';
import '../../custom_widgets/show_flush_bar.dart';
import '../../hive/label.dart';
import '../../main.dart';
import '../../others/network_utils.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final Auth _auth = Auth();
  final _storage = const FlutterSecureStorage();
  final OverlayPortalController _overlayController = OverlayPortalController();
  final TextEditingController _otpController = TextEditingController();
  String _uniqueCode = "";
  int _remainingTime = 30;
  Timer? _timer;
  final String _heading = "Enter OTP";

  @override
  void initState() {
    _startCountdown();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String email = args["email"];
    String subHeading = "OTP code has been sent to $email";
    _uniqueCode = args["code"];

    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: surfaceContainer,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: onSurfaceContainer,),
        ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            hPadding, spacingOne,
            hPadding, spacingSix,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _heading,
                style: TextStyle(
                  color: onSurface,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ), // Heading
              const SizedBox(height: spacingOne,),
              Text(
                subHeading,
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.375,
                  fontWeight: FontWeight.w400,
                  color: onSurfaceVariant,
                ),
              ), // SubHeading
              const SizedBox(height: spacingSeven,),
              PinCodeTextField(
                appContext: context,
                controller: _otpController,
                length: 6,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8.0),
                  fieldHeight: 56.0,
                  fieldWidth: (MediaQuery.sizeOf(context).width / 6.0) - 12.0,
                  selectedBorderWidth: 1.5,
                  activeBorderWidth: 1.0,
                  inactiveBorderWidth: 1.0,
                  activeFillColor: primary,
                  selectedFillColor: primary,
                  inactiveFillColor: formBorderColor,
                  selectedColor: primary,
                  activeColor: primary,
                  inactiveColor: formBorderColor,
                ),
                textStyle: TextStyle(
                  color: onSurface,
                  fontWeight: FontWeight.w500,
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Verification code not complete";
                  }

                  return null;
                },
              ),
              const SizedBox(height: spacingFive,),
              ElevatedButton(
                onPressed: _infoFilled() ? (){
                  _verifyEmail(context);
                } : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                    foregroundColor: onPrimary,
                    minimumSize: const Size.fromHeight(60)),
                child: const Text(
                  "Verify code",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ), // Verify code
              const SizedBox(height: spacingSeven,),
              if (_remainingTime != 0) RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Resend code in ",
                      style: TextStyle(
                        color: onSurfaceVariant,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "$_remainingTime",
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]
                ),
              ), // Resend code timer
              if (_remainingTime == 0) GestureDetector(
                onTap: () {
                  _resendOTP(context, email);
                },
                behavior: HitTestBehavior.opaque,
                child: Text(
                  "Resend code",
                  style: TextStyle(
                    color: onSurface,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ), // Resend code
            ],
          ),
        ),
      ),
    );
  }

  void _logOut() async {
    await _auth.signOut();
  }

  void _verifyEmail(BuildContext context) async {
    _overlayController.show();
    bool isConnected = await checkConnectivity(); // Check internet Connectivity
    if (isConnected) {
      _logOut();
      String? userId = await _storage.read(key: "userId");
      String response = await _auth.verifyOTP(
        userId: userId.toString(), otp: _otpController.text,
      );

      if (response == "success") {
        _overlayController.hide();
        _goAccountSet();
      } else {
        _showSnack("Verification failed", response, "error");
      }
    } else {
      _showSnack(
          "Connection Error",
          "Unable to connect to the internet. Please check your network settings and try again.",
          "error"
      );
    }
  }

  void _resendOTP(BuildContext context, String userEmail) async {
    _overlayController.show();
    bool isConnected = await checkConnectivity(); // Check internet Connectivity
    if(isConnected) {
      String? userId = await _storage.read(key: "userId");
      // Send OTP
      String otpResponse = await _auth.sendOTP(
        userId: userId.toString(),
        email: userEmail,
      );

      if (otpResponse == "success") {
        _otpController.clear();
        _overlayController.hide();
        _startCountdown();
        _showSnack(
            "Verification code sent",
            "The verification code has been resent. Kindly check your inbox or spam folder.",
            "success"
        );
      } else {
        _showSnack("Account creation failed", otpResponse, "error");
        setState(() {
          _remainingTime = 0;
        });
      }
    } else {
      _showSnack(
          "Connection Error",
          "Unable to connect to the internet. Please check your network settings and try again.",
          "error"
      );
    }
  }

  void _startCountdown() {
    setState(() {
      _remainingTime = 30; // Reset countdown
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel(); // Stop the timer when countdown is complete
      }
    });
  }

  void _showSnack(String title, String response, String state) {
    _overlayController.hide();

    showFlushBar(
      context: context,
      title: title,
      message: response,
      state: state,
    );
  }

  void _goAccountSet() {
    labelBox.put("loggedIn", Label(loggedIn: true));
    Navigator.pushNamedAndRemoveUntil(
      context, "/account set", (route) => false,
      arguments: {"code": _uniqueCode},
    );
  }

  bool _infoFilled() {
    if(_otpController.text.length < 6) {
      return false;
    } else {
      return true;
    }
  }
}
