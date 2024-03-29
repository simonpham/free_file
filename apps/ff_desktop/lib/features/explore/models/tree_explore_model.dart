import 'package:core/core.dart';
import 'package:core_ui/constants/constants.dart';
import 'package:ff_desktop/features/explore/explore.dart';
import 'package:flutter/foundation.dart';
import 'package:local_entity_provider/local_entity_provider.dart';
import 'package:utils/utils.dart';

class TreeExploreViewModel extends ChangeNotifier
    implements TreeExploreInterface {
  final int level;

  LocalEntityProvider get _local => injector.get<LocalEntityProvider>();

  final Directory _directory;
  bool _isExpandable = false;
  SvgGenImage? _customIcon;
  SvgGenImage? _customSelectedIcon;

  List<TreeExploreViewModel>? _directories;
  List<File>? _files;

  TreeExploreViewModel(
    this._directory, {
    required this.level,
    SvgGenImage? customIcon,
    SvgGenImage? customSelectedIcon,
  }) {
    _isExpandable = _local.hasSubDirectories(_directory);
    _customIcon = customIcon;
    _customSelectedIcon = customSelectedIcon;
  }

  @override
  SvgGenImage? get customIcon => _customIcon;

  @override
  SvgGenImage? get customSelectedIcon => _customSelectedIcon;

  @override
  bool get isExpandable => _isExpandable;

  @override
  bool get isExpanded => _directories != null;

  @override
  Directory get directory => _directory;

  @override
  List<TreeExploreViewModel> get directories => _directories ?? const [];

  @override
  List<File> get files => _files ?? const [];

  @override
  Future<void> toggle() async {
    if (!_isExpandable) {
      return;
    }

    if (_directories != null && _files != null) {
      _files = null;
      _directories = null;
      notifyListeners();
      return;
    }

    final List<TreeExploreViewModel> directories = [];
    final List<File> files = [];
    _directories = directories;
    _files = files;
    final entities = await _local.list(_directory.path);
    for (final entity in entities) {
      if (entity.hiddenStatus.isHidden) {
        // TODO: Support toggle show hidden files.
        continue;
      }

      try {
        if (entity is Directory) {
          directories.add(TreeExploreViewModel(entity, level: level + 1));
          continue;
        }

        if (entity is File) {
          files.add(entity);
          continue;
        }
      } catch (err, trace) {
        printError(err, trace);
      }
    }
    notifyListeners();
  }
}
