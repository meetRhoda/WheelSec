import 'package:flutter/material.dart';

import '../../others/constants.dart';
import '../../others/form_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final String _heading = "Forgot password";
  final String _subHeading = "Enter email address used during registration.";

  final FormController _formController = FormController();
  final TextEditingController _emailController = TextEditingController();

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
      body: Form(
        onChanged: () => setState(() {

        }),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            hPadding, 0, hPadding, spacingNine,
          ),
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
                  "Email address",
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
                    hintText: "Enter email address",
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
            const SizedBox(height: spacingEight,),
            ElevatedButton(
              onPressed: (){
                _goVerify(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: onPrimary,
                minimumSize: const Size.fromHeight(56.0),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ), // Continue
          ],
        ),
      ),
    );
  }

  void _goVerify(BuildContext context) {
    Navigator.pushNamed(context, "/verify forgot");
  }
}
