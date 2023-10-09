// import 'package:core_ui/core_ui.dart';
// import 'package:flutter/material.dart';
// import 'package:theme/theme.dart';
// import 'package:utils/utils.dart';
//
// enum LanguagePickerState {
//   normal,
//   hover,
//   open,
// }
//
// extension on LanguagePickerState {
//   double get borderSize {
//     switch (this) {
//       case LanguagePickerState.normal:
//         return Spacing.d1;
//       case LanguagePickerState.hover:
//         return Spacing.d2;
//       case LanguagePickerState.open:
//         return Spacing.d2;
//     }
//   }
// }
//
// class LanguagePicker extends StatefulWidget {
//   const LanguagePicker({
//     super.key,
//   });
//
//   @override
//   State<LanguagePicker> createState() => _LanguagePickerState();
// }
//
// class _LanguagePickerState extends State<LanguagePicker> {
//   LanguagePickerState _state = LanguagePickerState.normal;
//
//   String get _language => SettingsBox().locale;
//
//   Color _getPopupBorderColor(bool isDark) {
//     return isDark ? kNeutralSwatch[5]!.withOpacity(0.5) : kNeutralSwatch[3]!;
//   }
//
//   Color _getBorderColor(bool isDark) {
//     switch (_state) {
//       case LanguagePickerState.normal:
//         return isDark ? kNeutralSwatch[5]! : kNeutralSwatch[3]!;
//       case LanguagePickerState.hover:
//         return isDark
//             ? kNeutralSwatch[4]!.withOpacity(0.5)
//             : kNeutralSwatch[4]!.withOpacity(0.25);
//       case LanguagePickerState.open:
//         return kPrimaryColor;
//     }
//   }
//
//   Future<void> showDropdown(
//     BuildContext context,
//   ) async {
//     _state = LanguagePickerState.open;
//     setState(() {});
//     final RenderBox? box = context.findRenderObject() as RenderBox?;
//     final Offset topLeft = box?.localToGlobal(Offset.zero) ?? Offset.zero;
//     final boxSize = box?.size ?? Size.zero;
//     final position = RelativeRect.fromLTRB(
//       topLeft.dx,
//       topLeft.dy + boxSize.height + Spacing.d8,
//       topLeft.dx + boxSize.width,
//       topLeft.dy + boxSize.height,
//     );
//
//     final isDark = ThemeConfigs().themeMode == ThemeMode.dark;
//
//     final result = await showMenu<String?>(
//       context: context,
//       position: position,
//       constraints: BoxConstraints(
//         minWidth: boxSize.width,
//         maxWidth: boxSize.width,
//       ),
//       shape: RoundedRectangleBorder(
//         side: BorderSide(
//           color: _getPopupBorderColor(isDark),
//           width: Spacing.d1,
//         ),
//         borderRadius: BorderRadius.circular(Spacing.d12),
//       ),
//       color: isDark ? kNeutralSwatch[6] : kNeutralSwatch[1],
//       surfaceTintColor: Colors.transparent,
//       items: [
//         for (final lang in kSupportedLanguages.keys)
//           PopupMenuItem(
//             enabled: false,
//             value: lang,
//             height: Spacing.d40,
//             padding: EdgeInsets.symmetric(
//               horizontal: Spacing.d8,
//             ),
//             child: SizedBox(
//               height: boxSize.height,
//               child: ListItem(
//                 height: boxSize.height,
//                 backgroundColor: lang == _language
//                     ? isDark
//                         ? kNeutralSwatch[7]
//                         : kNeutralSwatch[3]?.withOpacity(0.5)
//                     : Colors.transparent,
//                 onTap: () {
//                   Navigator.of(context).pop(lang);
//                 },
//                 hoverOverlayPadding: EdgeInsets.zero,
//                 enableAnimation: false,
//                 padding: EdgeInsets.zero,
//                 trailing: lang == _language
//                     ? Padding(
//                         padding: EdgeInsets.only(right: Spacing.d8),
//                         child: ImageView(
//                           Assets.checkSolid,
//                           size: Spacing.d20,
//                           color: context.typoColor,
//                         ),
//                       )
//                     : null,
//                 titlePadding: EdgeInsets.zero,
//                 title: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: Spacing.d8),
//                       child: ImageView(
//                         kSupportedLanguages[lang]?.$1 ?? '',
//                         size: Spacing.d20,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: Spacing.d12,
//                       ),
//                       child: Text(
//                         kSupportedLanguages[lang]?.$2 ?? lang,
//                         style: context.base2.copyWith(
//                           color: lang == _language
//                               ? context.typoColor
//                               : kNeutralSwatch[4],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//
//     if (result != null && kSupportedLanguages.containsKey(result)) {
//       SettingsBox().locale = result;
//     }
//     _state = LanguagePickerState.normal;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = ThemeConfigs().themeMode == ThemeMode.dark;
//     return Tappable(
//       enableHoverOverlay: false,
//       enableAnimation: false,
//       enableHover: true,
//       hoverOverlayBorderRadius: Spacing.d12,
//       onStateChanged: (state) {
//         switch (state) {
//           case TappableState.focus:
//           case TappableState.hover:
//             if (_state == LanguagePickerState.normal) {
//               _state = LanguagePickerState.hover;
//               setState(() {});
//             }
//             break;
//           case TappableState.normal:
//             if (_state == LanguagePickerState.hover) {
//               _state = LanguagePickerState.normal;
//             }
//             setState(() {});
//             break;
//           case TappableState.pressed:
//             break;
//         }
//       },
//       onTap: () {
//         showDropdown(context);
//       },
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(Spacing.d12),
//           border: Border.all(
//             color: _getBorderColor(isDark),
//             width: _state.borderSize,
//           ),
//         ),
//         child: AbsorbPointer(
//           child: ListItem(
//             enableHoverOverlay: false,
//             enableAnimation: false,
//             padding: EdgeInsets.symmetric(
//               vertical: Spacing.d12 + Spacing.d2,
//               horizontal: Spacing.d16,
//             ),
//             leading: ImageView(
//               kSupportedLanguages[_language]?.$1 ?? '',
//               size: Spacing.d24,
//             ),
//             title: Text(
//               kSupportedLanguages[_language]?.$2 ?? _language,
//               style: context.base2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
