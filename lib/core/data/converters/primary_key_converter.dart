import 'package:drift/drift.dart';
import 'package:regression/core/data/constants.dart';
import 'package:uuid/uuid.dart';

class PrimaryKeyConverter extends TypeConverter<String, String> {
  @override
  String fromSql(String fromDb) {
    return fromDb;
  }

  @override
  String toSql(String value) {
    return value == krGeneratedPrimaryKey ? const Uuid().v4() : value;
  }
}
