import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regression/routes.dart';

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
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      routerConfig: regressionGoRouter,
      theme: ThemeData(
          useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFf7f7f7)),
    );
  }
}
