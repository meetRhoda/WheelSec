import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wheelsec/others/constants.dart';

class VerifyForgot extends StatefulWidget {
  const VerifyForgot({super.key});

  @override
  State<VerifyForgot> createState() => _VerifyForgotState();
}

class _VerifyForgotState extends State<VerifyForgot> {
  final String _heading = "Enter OTP";
  final String _subHeading = "OTP code has been sent to ogunesanrhoda@gmail.com";

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
      body: Padding(
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
              _subHeading,
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
              length: 5,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8.0),
                fieldHeight: 56.0,
                fieldWidth: (MediaQuery.sizeOf(context).width / 5.0) - 16.0,
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
              onPressed: (){
                _newPassword(context);
              },
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
            RichText(
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
                    text: "30",
                    style: TextStyle(
                      color: onSurface,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]
              ),
            ), // Resend code
          ],
        ),
      ),
    );
  }

  void _newPassword(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context, "/new password", ModalRoute.withName("/walkthrough"),
    );
  }
}
