import 'package:drift/drift.dart';
import 'package:regression/core/data/entities/regression.dart';

class RegressionTypeConverter extends TypeConverter<RegressionType, int> {
  @override
  RegressionType fromSql(int fromDb) => RegressionType.values[fromDb];

  @override
  int toSql(RegressionType value) => RegressionType.values.indexOf(value);
}
