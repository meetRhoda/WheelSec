import 'package:flutter/material.dart';
import 'package:wheelsec/appwrite/auth.dart';
import 'package:wheelsec/others/constants.dart';

import '../../custom_widgets/show_flush_bar.dart';
import '../../others/form_controller.dart';
import '../../others/network_utils.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final Auth _auth = Auth();
  final OverlayPortalController _overlayController = OverlayPortalController();
  final FormController _formController = FormController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _oldPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Change password",
          style: TextStyle(
            color: onSurfaceContainer,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    hPadding, spacingOne,
                    hPadding, spacingSix,
                  ),
                  child: Form(
                    onChanged: () => setState(() {
                      _infoFilled();
                    }),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: spacingFive,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Old password",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            const SizedBox(height: 8.0,),
                            TextFormField(
                              controller: _oldPasswordController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0,
                                ),
                                filled: true,
                                fillColor: surface,
                                hintText: "Old password",
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
                        ), // Old password
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
                              textInputAction: TextInputAction.next,
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
                        const SizedBox(height: spacingSix,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Confirm password",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            const SizedBox(height: 8.0,),
                            TextFormField(
                              controller: _confirmPasswordController,
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
                                hintText: "Re-enter password",
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
                                  if(value == _passwordController.text) {
                                    return null;
                                  } else {
                                    return "Password does not match";
                                  }
                                }
                                return null;
                              },
                            ),
                          ],
                        ), // Confirm password
                        const SizedBox(height: spacingNine,),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: spacingFive,
                  horizontal: hPadding,
                ),
                child: ElevatedButton(
                  onPressed: _infoFilled() ? (){
                    _changePassword(_oldPasswordController.text, _passwordController.text);
                  } : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: onPrimary,
                    minimumSize: const Size.fromHeight(56.0),
                  ),
                  child: const Text(
                    "Change password",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ), // Change password
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _infoFilled() {
    if(_oldPasswordController.text.isEmpty
        || _formController.validatePassword(_passwordController.text) != null
    || _confirmPasswordController.text != _passwordController.text
    ) {
      return false;
    } else {
      return true;
    }
  }

  void _goSuccess(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/password success");
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

  Future<void> _changePassword(String oldPassword, password) async {
    _overlayController.show();
    bool isConnected = await checkConnectivity(); // Check internet Connectivity
    if(isConnected) {
      final response = await _auth.changePassword(oldPassword, password);
      if (response == "success") {
        _overlayController.hide();
        _showSnack(
          "Password changed",
          "Your password has been successfully changed!",
          "success"
        );
      } else {
        _showSnack("Password change failed", response, "error");
      }
    }
    else {
      _showSnack(
          "Connection Error",
          "Unable to connect to the internet. Please check your network settings and try again.",
          "error"
      );
    }
  }
}
