import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regression/core/data/entities/data_variable.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/domain/failures/crud_failures.dart';
import 'package:regression/features/add_new_regression/application/controllers/regression_controller.dart';

import '../../../../core/core_mocks.dart';
import '../../mocks.dart';

void main() {
  NativeDatabase? memoryExecutor;
  setUp(() {
    memoryExecutor = NativeDatabase.memory();
    registerFallbackValue(RegressionType.linear);
  });
  tearDown(() => memoryExecutor?.close());
  test(
    'Test the initial regression is null',
    () async {
      final container = ProviderContainer();
      final subscription = container.listen(
          regressionControllerProvider, (previous, newValue) {});
      expectLater(subscription.read().value, isNull);
    },
  );

  test(
    'Test the regression is updated once it have been inserted',
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final addRegressionUsecase = MockAddRegressionUsecase();
      when(() => addRegressionUsecase.call(any(), any()))
          .thenAnswer((invocation) => Future(() => Right(Regression(
                id: 'cool_id',
                name: 'name',
                creationDateTime: DateTime.now(),
                regressionType: RegressionType.linear,
              ))));
      final globalKey = createMockGlobalFormStateKey();
      final addRegressionVariableUsecase = MockAddRegressionVariableUsecase();
      when(
        () => addRegressionVariableUsecase.call(
          isDependent: any(named: 'isDependent'),
          ownerRegressionId: any(named: 'ownerRegressionId'),
          variableLabel: any(named: 'variableLabel'),
        ),
      ).thenAnswer(
        (invocation) => Future(
          () => const Right(
            DataVariable(label: 'label', data: []),
          ),
        ),
      );
      final container = ProviderContainer(overrides: [
        addRegressionUsecaseProvider.overrideWithValue(addRegressionUsecase),
        addRegressionGlobalKeyProvider.overrideWithValue(globalKey),
        addRegressionVariableUsecaseProvider
            .overrideWithValue(addRegressionVariableUsecase),
      ]);
      final subscription = container.listen(
          regressionControllerProvider, (previous, newValue) {});
      await container
          .read(regressionControllerProvider.notifier)
          .addNewRegression();
      await Future.delayed(const Duration(milliseconds: 100));
      verify(() => addRegressionUsecase.call(any(), any())).called(1);
      expect(subscription.read().value?.id, 'cool_id');
    },
  );

  test(
    'Test the regression is being retrieved',
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final addRegressionUsecase = MockAddRegressionUsecase();
      when(() => addRegressionUsecase.call(any(), any()))
          .thenAnswer((invocation) => Future(() => Right(Regression(
                id: 'cool_id',
                name: 'name',
                creationDateTime: DateTime.now(),
                regressionType: RegressionType.linear,
              ))));
      final addRegressionVariableUsecase = MockAddRegressionVariableUsecase();
      when(
        () => addRegressionVariableUsecase.call(
          isDependent: any(named: 'isDependent'),
          ownerRegressionId: any(named: 'ownerRegressionId'),
          variableLabel: any(named: 'variableLabel'),
        ),
      ).thenAnswer(
        (invocation) => Future(
          () => const Right(
            DataVariable(label: 'label', data: []),
          ),
        ),
      );
      final globalKey = createMockGlobalFormStateKey();

      final container = ProviderContainer(overrides: [
        addRegressionUsecaseProvider.overrideWithValue(addRegressionUsecase),
        addRegressionGlobalKeyProvider.overrideWithValue(globalKey),
        addRegressionVariableUsecaseProvider
            .overrideWithValue(addRegressionVariableUsecase),
      ]);
      final subscription = container.listen(
          regressionControllerProvider, (previous, newValue) {});
      await container
          .read(regressionControllerProvider.notifier)
          .addNewRegression();
      await Future.delayed(const Duration(milliseconds: 100));
      verify(() => addRegressionUsecase.call(any(), any())).called(1);
      expect(subscription.read().value?.id, 'cool_id');
    },
  );

  test(
    'Test the create regression fails due name duplication',
    () async {
      final addRegressionUsecase = MockAddRegressionUsecase();
      when(() => addRegressionUsecase.call(any(), any())).thenAnswer(
          (invocation) =>
              Future(() => Left(CreateDuplicatedNameFailure(entityName: 'a'))));
      final globalKey = createMockGlobalFormStateKey();
      final container = ProviderContainer(overrides: [
        addRegressionUsecaseProvider.overrideWithValue(addRegressionUsecase),
        addRegressionGlobalKeyProvider.overrideWithValue(globalKey),
      ]);
      final subscription = container.listen(
          regressionControllerProvider, (previous, newValue) {});
      await container
          .read(regressionControllerProvider.notifier)
          .addNewRegression();
      await Future.delayed(const Duration(milliseconds: 100));
      verify(() => addRegressionUsecase.call(any(), any())).called(1);
      expect(subscription.read().error, isA<CreateDuplicatedNameFailure>());
    },
  );

  test(
    'Test the regression is only created if the key is valid',
    () async {
      final addRegressionUsecase = MockAddRegressionUsecase();
      when(() => addRegressionUsecase.call(any(), any())).thenAnswer(
          (invocation) =>
              Future(() => Left(CreateDuplicatedNameFailure(entityName: 'a'))));
      final globalKey = createMockGlobalFormStateKey(isValid: false);
      final container = ProviderContainer(overrides: [
        addRegressionUsecaseProvider.overrideWithValue(addRegressionUsecase),
        addRegressionGlobalKeyProvider.overrideWithValue(globalKey),
      ]);

      await container
          .read(regressionControllerProvider.notifier)
          .addNewRegression();
      await Future.delayed(const Duration(milliseconds: 100));
      verifyNever(() => addRegressionUsecase.call(any(), any()));
    },
  );

  test(
    'Test the regression creating the dependent variable',
    () async {
      final addRegressionUsecase = MockAddRegressionUsecase();
      when(() => addRegressionUsecase.call(any(), any())).thenAnswer(
        (invocation) => Future(
          () => Right(
            Regression(
              name: 'name',
              creationDateTime: DateTime.now(),
              regressionType: RegressionType.linear,
            ),
          ),
        ),
      );

      final addRegressionVariableUsecase = MockAddRegressionVariableUsecase();
      when(
        () => addRegressionVariableUsecase.call(
          isDependent: any(named: 'isDependent'),
          ownerRegressionId: any(named: 'ownerRegressionId'),
          variableLabel: any(named: 'variableLabel'),
        ),
      ).thenAnswer(
        (invocation) => Future(
          () => const Right(
            DataVariable(label: 'label', data: []),
          ),
        ),
      );
      final globalKey = createMockGlobalFormStateKey();
      final container = ProviderContainer(overrides: [
        addRegressionUsecaseProvider.overrideWithValue(addRegressionUsecase),
        addRegressionGlobalKeyProvider.overrideWithValue(globalKey),
        addRegressionVariableUsecaseProvider
            .overrideWithValue(addRegressionVariableUsecase),
      ]);

      await container
          .read(regressionControllerProvider.notifier)
          .addNewRegression();
      await Future.delayed(const Duration(milliseconds: 100));
      verify(
        () => addRegressionVariableUsecase(
          isDependent: true,
          ownerRegressionId: any(named: 'ownerRegressionId'),
          variableLabel: any(named: 'variableLabel'),
        ),
      ).called(1);
    },
  );

  test(
    'Test the regression creating an independent variable',
    () async {
      final addRegressionUsecase = MockAddRegressionUsecase();
      when(() => addRegressionUsecase.call(any(), any())).thenAnswer(
        (invocation) => Future(
          () => Right(
            Regression(
              name: 'name',
              creationDateTime: DateTime.now(),
              regressionType: RegressionType.linear,
            ),
          ),
        ),
      );
      final addRegressionVariableUsecase = MockAddRegressionVariableUsecase();
      when(
        () => addRegressionVariableUsecase.call(
          isDependent: any(named: 'isDependent'),
          ownerRegressionId: any(named: 'ownerRegressionId'),
          variableLabel: any(named: 'variableLabel'),
        ),
      ).thenAnswer(
        (invocation) => Future(
          () => const Right(
            DataVariable(label: 'label', data: []),
          ),
        ),
      );
      final globalKey = createMockGlobalFormStateKey();
      final container = ProviderContainer(overrides: [
        addRegressionUsecaseProvider.overrideWithValue(addRegressionUsecase),
        addRegressionGlobalKeyProvider.overrideWithValue(globalKey),
        addRegressionVariableUsecaseProvider
            .overrideWithValue(addRegressionVariableUsecase),
      ]);

      await container
          .read(regressionControllerProvider.notifier)
          .addNewRegression();
      await Future.delayed(const Duration(milliseconds: 100));
      verify(
        () => addRegressionVariableUsecase(
          isDependent: true,
          ownerRegressionId: any(named: 'ownerRegressionId'),
          variableLabel: any(named: 'variableLabel'),
        ),
      ).called(1);

      verify(
        () => addRegressionVariableUsecase(
          isDependent: false,
          ownerRegressionId: any(named: 'ownerRegressionId'),
          variableLabel: any(named: 'variableLabel'),
        ),
      ).called(1);
    },
  );
}
