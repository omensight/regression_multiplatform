import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regression/core/constants.dart';
import 'package:regression/features/edit_data/application/controllers/data_editor_controller.dart';

class DataEditorActionWidget extends ConsumerWidget {
  const DataEditorActionWidget({
    super.key,
    required this.regressionId,
  });

  final String regressionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(krRadius),
      ),
      padding: const EdgeInsets.only(
        left: krSmallPadding,
        right: krSmallPadding,
        top: 4.0,
        bottom: 4.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              ref
                  .read(dataEditorControllerProvider(regressionId).notifier)
                  .addEmptyData();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.playlist_add_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.clear_sharp),
          ),
        ],
      ),
    );
  }
}
