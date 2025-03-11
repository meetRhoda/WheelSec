import 'package:get/get.dart';

class FormController {
  String?  validateEmail(String value) {
    if(!GetUtils.isEmail(value)) {
      return "Please provide a valid email";
    }

    return null;
  }

  String?  validatePassword(String value) {
    if(value.length < 8) {
      return "Password must be at least 8 characters long";
    }

    return null;
  }

}