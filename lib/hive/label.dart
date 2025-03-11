import 'package:hive/hive.dart';

part 'label.g.dart';

@HiveType(typeId: 0)
class Label {
  Label({
    required this.loggedIn,
  });

  @HiveField(0)
  bool loggedIn;
}
