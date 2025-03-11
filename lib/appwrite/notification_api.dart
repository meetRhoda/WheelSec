import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/enums.dart';
import 'package:dart_appwrite/models.dart';
import 'package:wheelsec/others/constants.dart';

class NotificationAPI {
  // Send push notification
  Future<void> sendNotification() async {
    Client client = Client();
    Messaging messaging = Messaging(client);

    client
        .setEndpoint(appWriteURL)
        .setProject(appWriteProjectID)
        .setKey(appWriteKey);

    await messaging.createPush(
      messageId: ID.unique(),
      title: "Final Alert",
      body: "This is a self push notification",
      targets: ["alert"],
      critical: true,
      priority: MessagePriority.high,
    );
  }
}
