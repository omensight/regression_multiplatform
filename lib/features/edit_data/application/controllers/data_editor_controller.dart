import 'package:flutter/material.dart';
import 'package:regression/core/presentation/providers/repository_providers.dart';
import 'package:regression/features/edit_data/domain/usecases/add_empty_data_row_usecase.dart';
import 'package:regression/features/edit_data/domain/usecases/retrieve_initial_data_usecase.dart';
import 'package:regression/features/edit_data/domain/usecases/retrieve_initial_variables_labels_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'data_editor_controller.g.dart';

@riverpod
RetrieveInitialRegressionDataUsecase initialRegressionDataVariables(
    InitialRegressionDataVariablesRef ref) {
  return RetrieveInitialRegressionDataUsecase(
      dataVariableRepository: ref.watch(dataVariableRepositoryProvider));
}

@riverpod
AddEmptyDataRowUsecase addEmptyDataRowUsecase(AddEmptyDataRowUsecaseRef ref) {
  return AddEmptyDataRowUsecase();
}

@riverpod
RetrieveinitialVariablesLabelsUsecase retrieveinitialVariablesLabelsUsecase(
    RetrieveinitialVariablesLabelsUsecaseRef ref) {
  return RetrieveinitialVariablesLabelsUsecase(
      dataVariableRepository: ref.watch(dataVariableRepositoryProvider));
}

@riverpod
(int, int) matrixDimensions(MatrixDimensionsRef ref, String regressionId) {
  return ref.watch(dataEditorControllerProvider(regressionId)).when(
        data: (data) => (data[0].length, data.length),
        error: (error, stackTrace) => (0, 0),
        loading: () => (0, 0),
      );
}

@riverpod
Raw<TextEditingController> cellController(
    CellControllerRef ref, int row, int column) {
  return TextEditingController();
}

@riverpod
class DataVariablesLablesList extends _$DataVariablesLablesList {
  @override
  FutureOr<List<String>> build(String regressionId) async {
    return (await ref
            .watch(retrieveinitialVariablesLabelsUsecaseProvider)(regressionId))
        .fold((l) => Future.error(l), (r) => Future.value(r));
  }
}

@riverpod
class DataEditorController extends _$DataEditorController {
  @override
  FutureOr<List<List<double>>> build(String regressionId) async {
    final initialRegressionDataVariables =
        await ref.watch(initialRegressionDataVariablesProvider)(regressionId);

    return initialRegressionDataVariables.fold(
        (l) => Future.error(l), (r) => Future.value(r));
  }

  Future<void> addEmptyData() async {
    final variablesLength = ref
        .read(dataVariablesLablesListProvider(regressionId))
        .when(
            data: (data) => data.length,
            error: (error, stackTrace) => 0,
            loading: () => 0);
    if (variablesLength != 0) {
      state = (await ref.read(addEmptyDataRowUsecaseProvider)(
              state.value ?? [], variablesLength))
          .fold(
        (l) => AsyncValue.error(l, StackTrace.current),
        (r) => AsyncValue.data(r),
      );
    }
  }
}
