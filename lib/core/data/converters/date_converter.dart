import 'package:drift/drift.dart';

class DateConverter extends TypeConverter<DateTime, String> {
  @override
  DateTime fromSql(String fromDb) {
    return DateTime.parse(fromDb).toLocal();
  }

  @override
  String toSql(DateTime value) {
    return value.toUtc().toIso8601String();
  }
}
