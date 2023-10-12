import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:regression/features/add_new_regression/presentation/screens/add_regression_form_screen.dart';
import 'package:regression/features/regressions_list/presentation/screens/edit_regressions_list/regressions_list_screen.dart';
part 'routes.g.dart';

final regressionGoRouter = GoRouter(routes: $appRoutes);

@TypedGoRoute<AddNewRegressionRoute>(path: '/add_new_regression')
class AddNewRegressionRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddRegressionFormScreen();
  }
}

@TypedGoRoute<RegressionsListRoute>(path: '/')
class RegressionsListRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RegressionsListScreen();
  }
}
