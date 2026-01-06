import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @actionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// No description provided for @actionOpenInNewWindow.
  ///
  /// In en, this message translates to:
  /// **'Open in new window'**
  String get actionOpenInNewWindow;

  /// No description provided for @actionOpenInNewWindows.
  ///
  /// In en, this message translates to:
  /// **'Open in new windows'**
  String get actionOpenInNewWindows;

  /// No description provided for @actionOpenInNewTab.
  ///
  /// In en, this message translates to:
  /// **'Open in new tab'**
  String get actionOpenInNewTab;

  /// No description provided for @actionOpenInNewTabs.
  ///
  /// In en, this message translates to:
  /// **'Open in new tabs'**
  String get actionOpenInNewTabs;

  /// No description provided for @actionPinToSidebar.
  ///
  /// In en, this message translates to:
  /// **'Pin to sidebar'**
  String get actionPinToSidebar;

  /// No description provided for @actionUnpinFromSidebar.
  ///
  /// In en, this message translates to:
  /// **'Unpin from sidebar'**
  String get actionUnpinFromSidebar;

  /// No description provided for @actionQuickLook.
  ///
  /// In en, this message translates to:
  /// **'Quick look'**
  String get actionQuickLook;

  /// No description provided for @actionCompress.
  ///
  /// In en, this message translates to:
  /// **'Compress'**
  String get actionCompress;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @actionPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get actionPaste;

  /// No description provided for @actionPasteItems.
  ///
  /// In en, this message translates to:
  /// **'Paste {count} items here'**
  String actionPasteItems(int count);

  /// No description provided for @actionPasteItem.
  ///
  /// In en, this message translates to:
  /// **'Paste \"{name}\" here'**
  String actionPasteItem(String name);

  /// No description provided for @actionMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get actionMove;

  /// No description provided for @actionMoveItems.
  ///
  /// In en, this message translates to:
  /// **'Move {count} items here'**
  String actionMoveItems(int count);

  /// No description provided for @actionMoveItem.
  ///
  /// In en, this message translates to:
  /// **'Move \"{name}\" here'**
  String actionMoveItem(String name);

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionDeletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get actionDeletePermanently;

  /// No description provided for @actionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// No description provided for @actionProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get actionProperties;

  /// No description provided for @actionSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get actionSelectAll;

  /// No description provided for @actionToggleShowHiddenFiles.
  ///
  /// In en, this message translates to:
  /// **'Toggle show hidden files'**
  String get actionToggleShowHiddenFiles;

  /// No description provided for @actionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get actionUnknown;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogDelete;

  /// No description provided for @dialogDeleteContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} items?'**
  String dialogDeleteContent(int count);

  /// No description provided for @dialogDeletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get dialogDeletePermanently;

  /// No description provided for @dialogDeletePermanentlyContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} items permanently?'**
  String dialogDeletePermanentlyContent(int count);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @root.
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get root;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinned;

  /// No description provided for @cloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get cloud;

  /// No description provided for @yours.
  ///
  /// In en, this message translates to:
  /// **'Yours'**
  String get yours;

  /// No description provided for @drives.
  ///
  /// In en, this message translates to:
  /// **'Drives'**
  String get drives;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePage;

  /// No description provided for @keySpace.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get keySpace;

  /// No description provided for @keyShift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get keyShift;

  /// No description provided for @keyAlt.
  ///
  /// In en, this message translates to:
  /// **'Alt'**
  String get keyAlt;

  /// No description provided for @keyCtrl.
  ///
  /// In en, this message translates to:
  /// **'Ctrl'**
  String get keyCtrl;

  /// No description provided for @keyWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get keyWindows;

  /// No description provided for @keySuper.
  ///
  /// In en, this message translates to:
  /// **'Super'**
  String get keySuper;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
