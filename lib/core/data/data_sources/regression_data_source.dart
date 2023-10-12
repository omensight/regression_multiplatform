import 'package:drift/drift.dart';
import 'package:regression/core/data/constants.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:regression/core/data/entities/data_variables.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';
import 'package:regression/core/data/entities/regression_dependent_variables.dart';
import 'package:regression/core/data/entities/regression_variable.dart';
import 'package:regression/core/data/entities/regression_variables.dart';
import 'package:regression/core/data/entities/regressions.dart';
part 'regression_data_source.g.dart';

@DriftAccessor(tables: [
  Regressions,
  DataVariables,
  RegressionDependentVariables,
  RegressionVariables,
])
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

  Future<List<Regression>> findAll() {
    return select(regressions).get();
  }

  Stream<List<Regression>> watchAll() {
    return select(regressions).watch();
  }

  Future<int> deleteSingle(String id) {
    return (delete(regressions)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Regression> duplicate(String id, String newRegressionName) async {
    Regression? originalRegression = await find(id);
    Regression? duplicatedRegression;
    if (originalRegression != null) {
      await transaction(() async {
        duplicatedRegression = await insert(originalRegression.copyWith(
          id: krGeneratedPrimaryKey,
          name: newRegressionName,
        ));
        if (originalRegression.name == newRegressionName) {
          throw ArgumentError(
              'Two regressions with the same name is not allowed');
        }
        final existingDataVariablesIds = (await (select(regressionVariables)
                  ..where((tbl) =>
                      tbl.fkRegressionId.equals(originalRegression.id)))
                .get())
            .map((e) => e.fkDataVariableId)
            .toList();
        var originalDataVariables = await (select(dataVariables)
              ..where((tbl) => tbl.id.isIn(existingDataVariablesIds)))
            .get();

        final originalRegressionDependentVariable =
            await (select(regressionDependentVariables)
                  ..where((tbl) =>
                      tbl.fkRegressionId.equals(originalRegression.id)))
                .getSingleOrNull();

        for (var originalDataVariable in originalDataVariables) {
          final insertedDuplicatedDataVariable = await into(dataVariables)
              .insertReturning(originalDataVariable
                  .copyWith(id: krGeneratedPrimaryKey)
                  .toInsertable());
          if (duplicatedRegression != null) {
            final regressionVariable = RegressionVariable(
                fkRegressionId: duplicatedRegression!.id,
                fkDataVariableId: insertedDuplicatedDataVariable.id);
            await into(regressionVariables)
                .insert(regressionVariable.toInsertable());
          }

          if (originalRegressionDependentVariable != null &&
              originalRegressionDependentVariable.fkDataVariableId ==
                  originalDataVariable.id) {
            final regressionDependentVariable = RegressionDependentVariable(
                fkRegressionId: duplicatedRegression!.id,
                fkDataVariableId: insertedDuplicatedDataVariable.id);
            await into(regressionDependentVariables)
                .insertReturning(regressionDependentVariable.toInsertable());
          }
        }
      });
    }
    return duplicatedRegression!;
  }
}
