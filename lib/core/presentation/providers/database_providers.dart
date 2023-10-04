import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:regression/core/data/data_sources/data_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_data_source.dart';
import 'package:regression/core/data/data_sources/regression_dependent_variable_data_source.dart';
import 'package:regression/core/data/data_sources/regression_variable_data_source.dart';
import 'package:regression/core/data/database/regression_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:regression/core/presentation/field_validators/field_validators.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'database_providers.g.dart';

@Riverpod(keepAlive: true)
Future<QueryExecutor> queryExecutor(QueryExecutorRef ref) async {
  final documentsDirectory = Platform.isWindows
      ? await getApplicationDocumentsDirectory()
      : await getLibraryDirectory();
  final databasePath = join(documentsDirectory.path, 'regression.sqlite');
  return NativeDatabase(File(databasePath));
}

@Riverpod(keepAlive: true)
RegressionDatabase regressionDatabase(RegressionDatabaseRef ref) {
  final executor = ref.watch(queryExecutorProvider).when(
        data: (data) => data,
        error: (error, stackTrace) => NativeDatabase.memory(),
        loading: () => NativeDatabase.memory(),
      );
  return RegressionDatabase(executor: executor);
}

@riverpod
RegressionDataSource regressionDataSource(RegressionDataSourceRef ref) {
  final attachedDatabase = ref.watch(regressionDatabaseProvider);
  return RegressionDataSource(attachedDatabase);
}

@riverpod
DataVariableDataSource dataVariableDataSource(DataVariableDataSourceRef ref) {
  return DataVariableDataSource(ref.watch(regressionDatabaseProvider));
}

@riverpod
RegressionDependentVariableDataSource regressionDependentVariableDataSource(
    RegressionDependentVariableDataSourceRef ref) {
  return RegressionDependentVariableDataSource(
      ref.watch(regressionDatabaseProvider));
}

@riverpod
RegressionVariableDataSource regressionVariableDataSource(
    RegressionVariableDataSourceRef ref) {
  return RegressionVariableDataSource(ref.watch(regressionDatabaseProvider));
}

@riverpod
FieldValidator fieldValidator(FieldValidatorRef ref) => FieldValidator();
