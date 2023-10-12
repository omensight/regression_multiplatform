import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regression/core/constants.dart';
import 'package:regression/core/domain/failures/regression_failure.dart';
import 'package:regression/core/presentation/providers/database_providers.dart';
import 'package:regression/core/presentation/widgets/standard_space_widget.dart';
import 'package:regression/features/add_new_regression/application/controllers/duplicate_regression_controller.dart';
import 'package:regression/generated/codegen_keys.g.dart';

class DuplicateRegressionDialog extends ConsumerStatefulWidget {
  final String selectedRegressionIdForDuplication;
  const DuplicateRegressionDialog({
    super.key,
    required this.selectedRegressionIdForDuplication,
  });

  @override
  ConsumerState<DuplicateRegressionDialog> createState() =>
      _DuplicateRegressionDialogState();
}

class _DuplicateRegressionDialogState
    extends ConsumerState<DuplicateRegressionDialog> {
  @override
  void initState() {
    ref
        .read(selectedRegressionForDuplicationProvider.notifier)
        .update(widget.selectedRegressionIdForDuplication);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(duplicateRegressionDialogControllerProvider, (previous, next) {
      next.when(
        data: (data) {
          Navigator.of(context).pop();
        },
        error: (error, stackTrace) => null,
        loading: () => null,
      );
    });
    return Wrap(
      children: [
        Form(
            key: ref.watch(duplicateRegressionKeyProvider),
            child: Padding(
              padding: EdgeInsets.only(
                  left: krPadding,
                  top: krPadding,
                  right: krPadding,
                  bottom: krPadding + MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.duplicateRegression.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const StandardSpaceWidget.vertical(),
                  TextFormField(
                    controller:
                        ref.watch(duplicateRegressionNameControllerProvider),
                    decoration: InputDecoration(
                      labelText: LocaleKeys.regressionDuplicateName.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  ref.watch(duplicateRegressionDialogControllerProvider).when(
                        data: (data) => const SizedBox.shrink(),
                        error: (error, stackTrace) {
                          return error is RegressionFailure
                              ? Text(
                                  ref
                                      .read(regressionFailureConverterProvider)
                                      .convert(error),
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                )
                              : const SizedBox.shrink();
                        },
                        loading: () => const SizedBox.shrink(),
                      ),
                  const StandardSpaceWidget.vertical(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        ref
                            .read(duplicateRegressionDialogControllerProvider
                                .notifier)
                            .duplicateRegression();
                      },
                      child: Text(
                        LocaleKeys.duplicate.tr(),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
