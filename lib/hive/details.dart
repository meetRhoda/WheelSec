import 'package:hive/hive.dart';

part 'details.g.dart';

@HiveType(typeId: 1)
class Details {
  Details({
    required this.name,
    required this.email,
    required this.branch,
    required this.address,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String branch;

  @HiveField(3)
  String address;
}
