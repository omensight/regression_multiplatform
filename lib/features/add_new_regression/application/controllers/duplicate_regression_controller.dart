import 'package:flutter/material.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/presentation/providers/repository_providers.dart';
import 'package:regression/features/regressions_list/domain/usecases/duplicate_regression_usecase.dart';
import 'package:regression/features/regressions_list/domain/usecases/retrieve_single_regression_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'duplicate_regression_controller.g.dart';

@riverpod
DuplicateRegressionUsecase duplicateRegressionUsecase(
    DuplicateRegressionUsecaseRef ref) {
  return DuplicateRegressionUsecase(
      regressionRepository: ref.watch(regressionRepositoryProvider));
}

@riverpod
RetrieveSingleRegressionUsecase retrieveSingleRegressionUsecase(
    RetrieveSingleRegressionUsecaseRef ref) {
  return RetrieveSingleRegressionUsecase(
      regressionRepository: ref.watch(regressionRepositoryProvider));
}

@riverpod
class SelectedRegressionForDuplication
    extends _$SelectedRegressionForDuplication {
  @override
  Regression? build() {
    return null;
  }

  Future<void> update(String regressionId) async {
    final regressionResult =
        await ref.read(retrieveSingleRegressionUsecaseProvider)(regressionId);
    state = regressionResult.getRight().match(() => null, (value) => value);
  }
}

@riverpod
GlobalKey<FormState> duplicateRegressionKey(DuplicateRegressionKeyRef ref) {
  return GlobalKey();
}

@riverpod
Raw<TextEditingController> duplicateRegressionNameController(
    DuplicateRegressionNameControllerRef ref) {
  final initialName =
      ref.watch(selectedRegressionForDuplicationProvider)?.name ?? '';

  var controller = TextEditingController();
  controller.text = '$initialName (1)';
  return controller;
}

@riverpod
class DuplicateRegressionDialogController
    extends _$DuplicateRegressionDialogController {
  @override
  AsyncValue<Regression> build() => const AsyncValue.loading();

  Future<void> duplicateRegression() async {
    final selectedRegressionIdForDuplication =
        ref.read(selectedRegressionForDuplicationProvider)?.id;
    if ((ref.read(duplicateRegressionKeyProvider).currentState?.validate() ??
            false) &&
        selectedRegressionIdForDuplication != null) {
      final duplicatedName =
          ref.read(duplicateRegressionNameControllerProvider).text;
      final duplicateResult =
          await ref.read(duplicateRegressionUsecaseProvider)(
        duplicatedName: duplicatedName,
        originalRegressionId: selectedRegressionIdForDuplication,
      );
      state = duplicateResult.fold(
          (l) => AsyncError(l, StackTrace.current), (r) => AsyncValue.data(r));
    }
  }
}
