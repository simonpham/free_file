import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final String? cancelText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.localize;
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        SecondaryButton(
          text: cancelText ?? s.dialogCancel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        PrimaryButton(
          text: confirmText ?? s.dialogDelete,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
