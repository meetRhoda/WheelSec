import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wheelsec/others/constants.dart';

import '../../appwrite/auth.dart';
import '../../custom_widgets/show_flush_bar.dart';
import '../../hive/label.dart';
import '../../main.dart';
import '../../others/form_controller.dart';
import '../../others/network_utils.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final Auth _auth = Auth();
  final _storage = const FlutterSecureStorage();
  final OverlayPortalController _overlayController = OverlayPortalController();
  final FormController _formController = FormController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _heading = "Log in";
  final String _subHeading = "Welcome back!";

  @override
  Widget build(BuildContext context) {
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
            hPadding, 0, hPadding, spacingNine,
          ),
          child: Form(
            onChanged: () => setState(() {
              _infoFilled();
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _heading,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                  ),
                ), // Heading
                const SizedBox(height: spacingThree,),
                Text(
                  _subHeading,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ), // SubHeading
                const SizedBox(height: spacingSix,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 8.0,),
                    TextFormField(
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0,
                        ),
                        filled: true,
                        fillColor: surface,
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: hintColor,
                          height: 1.6,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: formBorderColor,),
                          borderRadius: const BorderRadius.all(Radius.circular(textFieldRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                          borderRadius: const BorderRadius.all(Radius.circular(textFieldRadius)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: error),
                          borderRadius: const BorderRadius.all(Radius.circular(textFieldRadius)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: error),
                          borderRadius: const BorderRadius.all(Radius.circular(textFieldRadius)),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      validator: (value) {
                        if(value!.isNotEmpty) {
                          return _formController.validateEmail(value.trim());
                        }
                        return null;
                      },
                    ),
                  ],
                ), // Email
                const SizedBox(height: spacingSix,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 8.0,),
                    TextFormField(
                      controller: _passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0,
                        ),
                        filled: true,
                        fillColor: surface,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: hintColor,
                          height: 1.6,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: formBorderColor,),
                          borderRadius: const BorderRadius.all(Radius.circular(textFieldRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                          borderRadius: const BorderRadius.all(Radius.circular(textFieldRadius)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: error),
                          borderRadius: const BorderRadius.all(Radius.circular(textFieldRadius)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: error),
                          borderRadius: const BorderRadius.all(Radius.circular(textFieldRadius)),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      validator: (value) {
                        if(value!.isNotEmpty) {
                          return _formController.validatePassword(value);
                        }
                        return null;
                      },
                    ),
                  ],
                ), // Password
                const SizedBox(height: spacingEight,),
                ElevatedButton(
                  onPressed: _infoFilled() ? (){
                    _logIn(context);
                  }: null,
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: onPrimary,
                    minimumSize: const Size.fromHeight(56.0),
                  ),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ), // Log in
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _logIn(BuildContext context) async {
    _overlayController.show();
    bool isConnected = await checkConnectivity(); // Check internet Connectivity
    if(isConnected) {
      // Create account
      String response = await _auth.signInUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Send OTP
      if (response == "success") {
        _overlayController.hide();
        _goHome();
      } else if (response == "verify") {
        String? userId = await _storage.read(key: "userId");
        String otpResponse = await _auth.sendOTP(
          userId: userId.toString(),
          email: _emailController.text,
        );

        if (otpResponse == "success") {
          _overlayController.hide();
          _goVerifyOTP();
        } else {
          _showError("Sign in failed", otpResponse);
        }
      } else {
        _showError("Sign in failed", response);
      }
    } else {
      _showError(
        "Connection Error",
        "Unable to connect to the internet. Please check your network settings and try again.",
      );
    }
  }

  void _showError(String title, String response) {
    _overlayController.hide();

    showFlushBar(
      context: context,
      title: title,
      message: response,
      state: "error",
    );
  }

  bool _infoFilled() {
    if(_formController.validateEmail(_emailController.text.trim()) != null ||
        _formController.validatePassword(_passwordController.text) != null) {
      return false;
    } else {
      return true;
    }
  }

  void _goVerifyOTP() {
    Navigator.of(context).pushReplacementNamed(
      "/verify email",
      arguments: {"email": _emailController.text.trim()},
    );
  }

  void _goHome() {
    labelBox.put("loggedIn", Label(loggedIn: true));
    Navigator.pushNamedAndRemoveUntil(context, "/bottom nav", (route) => false);
  }
}
