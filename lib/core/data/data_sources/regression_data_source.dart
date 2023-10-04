import 'package:drift/drift.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/entities/regressions.dart';
part 'regression_data_source.g.dart';

@DriftAccessor(tables: [Regressions])
class RegressionDataSource extends DatabaseAccessor<RegressionDatabase>
    with _$RegressionDataSourceMixin {
  RegressionDataSource(super.attachedDatabase);

  Future<Regression> insert(Regression regression) {
    return into(regressions).insertReturning(regression.toInsertable());
  }

  Future<Regression?> find(String id) {
    return (select(regressions)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Regression?> findByName(String name) {
    return (select(regressions)
          ..where(
              (tbl) => tbl.name.collate(Collate.noCase).equals(name.trim())))
        .getSingleOrNull();
  }
}
