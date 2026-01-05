import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock theme to avoid errors accessing context.theme
import 'package:theme/theme.dart';

void main() {
  testWidgets('ConfirmDialog shows title, content and buttons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => AppTheme(
            data: AppThemeData.defaultTheme,
            child: const ConfirmDialog(
              title: 'Test Title',
              content: 'Test Content',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('ConfirmDialog pops true on confirm', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return AppTheme(
              data: AppThemeData.defaultTheme,
              child: PrimaryButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (_) => const ConfirmDialog(
                      title: 'Test',
                      content: 'Content',
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // Tap confirm
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(result, true);
  });

  testWidgets('ConfirmDialog pops false on cancel', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return AppTheme(
              data: AppThemeData.defaultTheme,
              child: PrimaryButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (_) => const ConfirmDialog(
                      title: 'Test',
                      content: 'Content',
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // Tap cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(result, false);
  });
}
