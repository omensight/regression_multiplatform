import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regression/features/add_new_regression/presentation/screens/add_regression_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    ProviderScope(
      child: EasyLocalization(
          path: 'assets/langs',
          supportedLocales: const [Locale('en', 'US')],
          child: const RegressionApp()),
    ),
  );
}

class RegressionApp extends StatelessWidget {
  const RegressionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      home: const AddRegressionFormScreen(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}
