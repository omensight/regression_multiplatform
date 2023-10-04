import 'package:drift/drift.dart';
import 'dart:convert';

class DoubleListConverter extends TypeConverter<List<double>, String> {
  @override
  List<double> fromSql(String fromDb) {
    final parsedData = List<double>.from(json.decode(fromDb));
    return parsedData;
  }

  @override
  String toSql(List<double> value) {
    return json.encode(value);
  }
}
