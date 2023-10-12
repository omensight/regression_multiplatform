import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regression/core/constants.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/presentation/providers/database_providers.dart';
import 'package:regression/core/presentation/widgets/standard_space_widget.dart';
import 'package:regression/features/add_new_regression/application/controllers/regression_controller.dart';
import 'package:regression/generated/codegen_keys.g.dart';

class AddRegressionFormScreen extends ConsumerWidget {
  const AddRegressionFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      regressionControllerProvider,
      (previous, next) {},
    );
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.titleCreateANewRegression.tr())),
      body: SingleChildScrollView(
        child: Form(
          key: ref.watch(addRegressionGlobalKeyProvider),
          child: Padding(
            padding: const EdgeInsets.all(krPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocaleKeys.indicatorBasicInformation.tr()),
                const StandardSpaceWidget.vertical(),
                TextFormField(
                  validator:
                      ref.watch(fieldValidatorProvider).requiredFieldValidator,
                  controller: ref.watch(nameControllerProvider),
                  decoration: InputDecoration(
                    labelText: LocaleKeys.labelRegressionName.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const StandardSpaceWidget.vertical(),
                DropdownButtonFormField<RegressionType>(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  value: ref.watch(selectedRegressionTypeProvider),
                  items: RegressionType.values
                      .map((e) => switch (e) {
                            RegressionType.linear => DropdownMenuItem(
                                value: RegressionType.linear,
                                child: Text(
                                    LocaleKeys.regressionTypes_linear.tr())),
                            RegressionType.power => DropdownMenuItem(
                                value: RegressionType.power,
                                child: Text(
                                    LocaleKeys.regressionTypes_power.tr())),
                          })
                      .toList(),
                  onChanged: (RegressionType? value) {
                    if (value != null) {
                      ref
                          .read(selectedRegressionTypeProvider.notifier)
                          .update(value);
                    }
                  },
                ),
                const StandardSpaceWidget.vertical(),
                Text(LocaleKeys.indicatorVariables.tr()),
                const StandardSpaceWidget.vertical(),
                TextFormField(
                  controller: ref.watch(dependentLabelControllerProvider),
                  decoration: InputDecoration(
                    labelText: LocaleKeys.labelDependentVariable.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const StandardSpaceWidget.vertical(),
                ...ref
                    .watch(independentVariablesLabelsControllerProvider)
                    .map(
                      (e) => TextFormField(
                        controller: e,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.labelIndependentVariable.tr(),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    )
                    .toList(),
                const StandardSpaceWidget.vertical(),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(regressionControllerProvider.notifier)
                              .addNewRegression();
                        },
                        child: Text(LocaleKeys.add.tr())))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
