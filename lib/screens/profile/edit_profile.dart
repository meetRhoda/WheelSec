import 'package:flutter/material.dart';
import '../../hive/details.dart';
import '../../main.dart';
import '../../others/constants.dart';
import '../../others/form_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final FormController _formController = FormController();

  @override
  void initState() {
    _getUserDetails();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _branchController.dispose();
    _addressController.dispose();

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
          "My profile",
          style: TextStyle(
            color: onSurfaceContainer,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          hPadding, spacingOne,
          hPadding, spacingSix,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: spacingFive,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Full name",
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.375,
                    fontWeight: FontWeight.w400,
                    color: onSurface,
                  ),
                ), // Full name
                const SizedBox(height: 8.0,),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inactiveForm,
                    hintText: "Full name",
                    hintStyle: TextStyle(
                      color: hintColor,
                      height: 1.6,
                    ),
                    border: const UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: formBorderColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: error, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: error, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 18.0,
                    ),
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ), // Full name
            const SizedBox(height: spacingSix,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email address",
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.375,
                    fontWeight: FontWeight.w400,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 8.0,),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inactiveForm,
                    hintText: "Email address",
                    hintStyle: TextStyle(
                      color: hintColor,
                      height: 1.6,
                    ),
                    border: const UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: formBorderColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: error, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: error, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 18.0,
                    ),
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  validator: (value) {
                    if(value!.isNotEmpty) {
                      return _formController.validateEmail(value);
                    }
                    return null;
                  },
                ),
              ],
            ), // Email address
            const SizedBox(height: spacingSix,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "State",
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.375,
                    fontWeight: FontWeight.w400,
                    color: onSurface,
                  ),
                ), // State
                const SizedBox(height: 8.0,),
                TextFormField(
                  controller: _branchController,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inactiveForm,
                    hintText: "State",
                    hintStyle: TextStyle(
                      color: hintColor,
                      height: 1.6,
                    ),
                    border: const UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: formBorderColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: formBorderColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 18.0,
                    ),
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ), // State
            const SizedBox(height: spacingSix,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.375,
                    fontWeight: FontWeight.w400,
                    color: onSurface,
                  ),
                ), // Location
                const SizedBox(height: 8.0,),
                TextFormField(
                  controller: _addressController,
                  keyboardType: TextInputType.streetAddress,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inactiveForm,
                    hintText: "Location",
                    hintStyle: TextStyle(
                      color: hintColor,
                      height: 1.6,
                    ),
                    border: const UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: formBorderColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: formBorderColor, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 18.0,
                    ),
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ), // Location
            const SizedBox(height: spacingNine,),
          ],
        ),
      ),
    );
  }

  void _getUserDetails() {
    Details details = boxDetails.get("details");
    _nameController.text = details.name;
    _emailController.text = details.email;
    _branchController.text = details.branch;
    _addressController.text = details.address;
  }
}
