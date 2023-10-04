import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:regression/features/add_new_regression/presentation/screens/add_regression_form_screen.dart';
part 'routes.g.dart';

@TypedGoRoute<AddNewRegressionRoute>(path: '/')
class AddNewRegressionRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddRegressionFormScreen();
  }
}
