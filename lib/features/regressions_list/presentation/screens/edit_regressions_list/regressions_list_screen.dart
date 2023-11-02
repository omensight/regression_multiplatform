import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regression/core/constants.dart';
import 'package:regression/core/data/entities/regression.dart';
import 'package:regression/core/presentation/widgets/standard_space_widget.dart';
import 'package:regression/features/regressions_list/application/controllers/regressions_list_controller.dart';
import 'package:regression/features/regressions_list/presentation/screens/delete_regression_confirmation/delete_regression_confirmation_dialog.dart';
import 'package:regression/features/regressions_list/presentation/screens/duplicate_regression/duplicate_regression_dialog.dart';
import 'package:regression/generated/codegen_keys.g.dart';
import 'package:regression/routes.dart';

class RegressionsListScreen extends ConsumerWidget {
  const RegressionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regressions = ref.watch(regressionsListProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.appName.tr()),
          actions: [
            IconButton(
                onPressed: () {
                  AddNewRegressionRoute().push(context);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: switch (regressions) {
          AsyncData(value: final regressionsList) => Padding(
              padding: const EdgeInsets.only(
                left: krSmallPadding,
                right: krSmallPadding,
                top: krSmallPadding,
              ),
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const StandardSpaceWidget.vertical(space: krListSpace),
                itemCount: regressionsList.length,
                itemBuilder: (context, index) {
                  final currentRegression = regressionsList[index];
                  var regressionTypeColor =
                      switch (currentRegression.regressionType) {
                    RegressionType.linear => Colors.red,
                    RegressionType.power => Colors.blue,
                  };
                  return Material(
                    borderRadius: BorderRadius.circular(8.0),
                    child: InkWell(
                      onTap: () {
                        DataEditorRoute(regressionId: currentRegression.id)
                            .push(context);
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        height: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                    ),
                                    color: regressionTypeColor,
                                  ),
                                ),
                                const StandardSpaceWidget.horizontal(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentRegression.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      switch (
                                          currentRegression.regressionType) {
                                        RegressionType.linear => LocaleKeys
                                            .regressionTypes_linear
                                            .tr(),
                                        RegressionType.power =>
                                          LocaleKeys.regressionTypes_power.tr(),
                                      },
                                      style:
                                          TextStyle(color: regressionTypeColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  DateFormat.yMd().format(
                                      currentRegression.creationDateTime),
                                ),
                                MenuAnchor(
                                  controller: ref.watch(menuControllerProvider(
                                      currentRegression.id)),
                                  anchorTapClosesMenu: true,
                                  menuChildren: [
                                    MenuItemButton(
                                      leadingIcon: const Icon(Icons.delete),
                                      child: Text(LocaleKeys.delete.tr()),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              DeleteRegressionConfirmationDialog(
                                                  selectedRegressionForDeletion:
                                                      currentRegression),
                                        );
                                      },
                                    ),
                                    MenuItemButton(
                                      leadingIcon: const Icon(Icons.copy),
                                      child: Text(LocaleKeys.duplicate.tr()),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              DuplicateRegressionDialog(
                                            selectedRegressionIdForDuplication:
                                                currentRegression.id,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                  child: IconButton(
                                    onPressed: () {
                                      ref
                                          .read(menuControllerProvider(
                                              currentRegression.id))
                                          .open();
                                    },
                                    icon: const Icon(Icons.more_vert_rounded),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          AsyncValue<List<Regression>>() => null,
        });
  }
}
