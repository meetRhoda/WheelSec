import 'dart:async';
import 'package:http/http.dart' as http;

class NetworkUtils {
  static Future<bool> isNetworkAvailable() async {
    try {
      final response = await http.head(Uri.parse('https://www.example.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false; // Error occurred, assume not connected
    }
  }
}

Future<bool> checkConnectivity({int timeoutInSec = 7}) async {
  try {
    // Set a timeout for the network check
    bool isConnected = await NetworkUtils.isNetworkAvailable()
        .timeout(Duration(seconds: timeoutInSec), onTimeout: () {
      return false; // Return false if the operation times out
    });
    return isConnected;
  } catch (e) {
    return false;
  }
}