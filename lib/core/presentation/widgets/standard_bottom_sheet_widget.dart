import 'package:flutter/material.dart';

class StandardBottomSheetWidget extends StatelessWidget {
  final String title;
  final Widget body;
  const StandardBottomSheetWidget({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        body,
      ],
    );
  }
}
