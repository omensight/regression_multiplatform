import 'package:flutter/material.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/presentation/providers/repository_providers.dart';
import 'package:regression/features/regressions_list/domain/usecases/retrieve_regressions_stream_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'regressions_list_controller.g.dart';

@Riverpod()
Stream<List<Regression>> regressionsList(RegressionsListRef ref) {
  return RetrieveRegressionsStreamUsecase(
      regressionRepository: ref.watch(
    regressionRepositoryProvider,
  ))();
}

@riverpod
MenuController menuController(MenuControllerRef ref, String regressionId) =>
    MenuController();
