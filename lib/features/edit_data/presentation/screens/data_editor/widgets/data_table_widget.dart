import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regression/features/edit_data/application/controllers/data_editor_controller.dart';

class DataTableWidget extends ConsumerWidget {
  final String regressionId;
  const DataTableWidget({
    super.key,
    required this.regressionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = ref.watch(matrixDimensionsProvider(regressionId));
    final labels = ref.watch(dataVariablesLablesListProvider(regressionId));
    return LayoutBuilder(
      builder: (context, constraints) {
        final labelsViews = TableRow(
            children: labels.when(
          data: (data) => data.map((label) => Text(label)).toList(),
          error: (error, stackTrace) => [],
          loading: () => [],
        ));
        final rows = List.generate(
          dimensions.$1,
          (rowIndex) => TableRow(
            children: List.generate(
              dimensions.$2,
              (columnIndex) => TextFormField(
                controller: ref.watch(
                  cellControllerProvider(rowIndex, columnIndex),
                ),
              ),
            ),
          ),
        );
        return Table(
          children: [
            labelsViews,
            ...rows,
          ],
        );
      },
    );
  }
}
