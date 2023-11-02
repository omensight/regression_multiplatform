import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regression/core/constants.dart';
import 'package:regression/core/presentation/providers/database_providers.dart';
import 'package:regression/features/edit_data/application/controllers/data_editor_controller.dart';
import 'package:regression/features/edit_data/presentation/screens/data_editor/widgets/data_editor_action_widget.dart';
import 'package:regression/features/edit_data/presentation/screens/data_editor/widgets/data_table_widget.dart';

class DataEditorScreen extends ConsumerWidget {
  final String regressionId;
  const DataEditorScreen({super.key, required this.regressionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failureConverter = ref.watch(regressionFailureConverterProvider);
    final data = ref.watch(dataEditorControllerProvider(regressionId));
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(krSmallPadding),
          child: data.when(
            data: (data) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DataTableWidget(regressionId: regressionId),
                DataEditorActionWidget(regressionId: regressionId)
              ],
            ),
            error: (error, stackTrace) {
              return;
            },
            loading: () => const CircularProgressIndicator(),
          )),
    );
  }
}
