import 'package:hive/hive.dart';

part 'unique_code.g.dart';

@HiveType(typeId: 2)
class UniqueCode {
  UniqueCode({
    required this.branch,
    required this.address,
  });

  @HiveField(0)
  String branch;

  @HiveField(1)
  String address;
}
