import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        SecondaryButton(
          text: cancelText,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        PrimaryButton(
          text: confirmText,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
