import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/features/add_new_regression/application/controllers/regression_controller.dart';
import 'package:regression/generated/codegen_keys.g.dart';

class DeleteRegressionConfirmationDialog extends ConsumerWidget {
  final Regression selectedRegressionForDeletion;
  const DeleteRegressionConfirmationDialog({
    super.key,
    required this.selectedRegressionForDeletion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(LocaleKeys.dialogDeleteRegressionConfirmation_title.tr()),
      content: Text(
        LocaleKeys.dialogDeleteRegressionConfirmation_body.tr(
          args: [
            selectedRegressionForDeletion.name,
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            LocaleKeys.cancel.tr(),
          ),
        ),
        FilledButton(
          onPressed: () {
            ref
                .read(regressionControllerProvider.notifier)
                .deleteRegression(selectedRegressionForDeletion.id);
            Navigator.of(context).pop();
          },
          child: Text(
            LocaleKeys.delete.tr(),
          ),
        )
      ],
    );
  }
}
