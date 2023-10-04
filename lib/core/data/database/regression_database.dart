import 'package:drift/drift.dart';
import 'package:regression/core/data/converters/date_converter.dart';
import 'package:regression/core/data/converters/double_list_converter.dart';
import 'package:regression/core/data/converters/primary_key_converter.dart';
import 'package:regression/core/data/converters/regression_type_converter.dart';
import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_dependent_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/regression_dependent_variable.dart';
import 'package:regression/core/data/entities/regression_dependent_variables.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/data/entities/regression_variable.dart';
import 'package:regression/core/data/entities/regression_variables.dart';
import 'package:regression/core/data/entities/regressions.dart';
import 'package:regression/core/data/entities/data_variables.dart';
part 'regression_database.g.dart';

@DriftDatabase(tables: [
  Regressions,
  DataVariables,
  RegressionDependentVariables,
  RegressionVariables
], daos: [
  RegressionDataSource,
  DataVariableDataSource,
  RegressionDependentVariableDataSource,
])
class RegressionDatabase extends _$RegressionDatabase {
  RegressionDatabase({required QueryExecutor executor}) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('pragma foreign_keys = ON');
        },
      );
}
