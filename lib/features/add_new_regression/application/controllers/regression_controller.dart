import 'package:flutter/material.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/presentation/providers/database_providers.dart';
import 'package:regression/core/presentation/providers/repository_providers.dart';
import 'package:regression/features/add_new_regression/domain/usecases/add_regression_usecase.dart';
import 'package:regression/features/add_new_regression/domain/usecases/add_regression_variable_usecase.dart';
import 'package:regression/features/regressions_list/domain/usecases/delete_single_regression_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'regression_controller.g.dart';

@riverpod
AddRegressionUsecase addRegressionUsecase(
  AddRegressionUsecaseRef ref,
) =>
    AddRegressionUsecase(
        regressionRepository: ref.watch(regressionRepositoryProvider));

@riverpod
Regression? selectedEditingRegression(
    SelectedEditingRegressionRef ref, String? regressionId) {
  return null;
}

@riverpod
DeleteSingleRegressionUsecase deleteSingleRegressionUsecase(
    DeleteSingleRegressionUsecaseRef ref) {
  return DeleteSingleRegressionUsecase(
      regressionDataSource: ref.watch(regressionRepositoryProvider));
}

@riverpod
AddRegressionVariableUsecase addRegressionVariableUsecase(
    AddRegressionVariableUsecaseRef ref) {
  return AddRegressionVariableUsecase(
    dataVariableRepository: ref.watch(dataVariableRepositoryProvider),
    regressionDependentVariableRepository:
        ref.watch(regressionDependentVariableRepositoryProvider),
    regressionVariableDataSource:
        ref.watch(regressionVariableDataSourceProvider),
  );
}

@riverpod
class EditingRegressionId extends _$EditingRegressionId {
  @override
  String? build() {
    return null;
  }

  Future<void> updateId(String id) async {
    state = id;
  }
}

@riverpod
GlobalKey<FormState> addRegressionGlobalKey(AddRegressionGlobalKeyRef ref) =>
    GlobalKey();

@riverpod
Raw<TextEditingController> nameController(NameControllerRef ref) =>
    TextEditingController();

@riverpod
Raw<TextEditingController> dependentLabelController(
        DependentLabelControllerRef ref) =>
    TextEditingController();

@riverpod
class IndependentVariablesLabelsController
    extends _$IndependentVariablesLabelsController {
  @override
  List<TextEditingController> build() => [TextEditingController()];
}

@riverpod
class SelectedRegressionType extends _$SelectedRegressionType {
  @override
  RegressionType build() {
    return RegressionType.linear;
  }

  void update(RegressionType regressionType) => state = regressionType;
}

@riverpod
class RegressionController extends _$RegressionController {
  @override
  Future<Regression?> build() async {
    return null;
  }

  Future<void> addNewRegression() async {
    final formState = ref.read(addRegressionGlobalKeyProvider);
    if (formState.currentState?.validate() ?? false) {
      final regressionName = ref.read(nameControllerProvider).text;
      final regressionType = ref.read(selectedRegressionTypeProvider);
      final insertRegressionResult = await ref
          .read(addRegressionUsecaseProvider)(regressionName, regressionType);
      insertRegressionResult.fold(
        (l) => state = AsyncError(l, StackTrace.current),
        (r) async {
          final dependentVariableLabel =
              ref.read(dependentLabelControllerProvider).text;

          await ref.read(addRegressionVariableUsecaseProvider)(
            isDependent: true,
            ownerRegressionId: r.id,
            variableLabel: dependentVariableLabel,
          );

          final independentVariablesLabels = ref
              .read(independentVariablesLabelsControllerProvider)
              .map((e) => e.text);
          for (String independentLabel in independentVariablesLabels) {
            await ref.read(addRegressionVariableUsecaseProvider)(
              ownerRegressionId: r.id,
              variableLabel: independentLabel,
            );
          }
          state = AsyncData(r);
        },
      );
    }
  }

  Future<void> deleteRegression(String id) async {
    await ref.read(deleteSingleRegressionUsecaseProvider)(id: id);
  }
}
