import 'package:core/models/directory.dart';
import 'package:core/models/file.dart';
import 'package:ff_desktop/di.dart';
import 'package:ff_desktop/features/explore/explore.dart';
import 'package:flutter/foundation.dart';
import 'package:local_entity_provider/local_entity_provider.dart';

class TreeExploreViewModel extends ChangeNotifier
    implements TreeExploreInterface {
  final int level;

  LocalEntityProvider get _local => injector.get<LocalEntityProvider>();

  final Directory _directory;

  List<TreeExploreViewModel>? _directories;
  List<File>? _files;

  TreeExploreViewModel(
    this._directory, {
    required this.level,
  });

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
      if (entity is Directory) {
        directories.add(TreeExploreViewModel(entity, level: level + 1));
        continue;
      }

      if (entity is File) {
        files.add(entity);
        continue;
      }
    }
    notifyListeners();
  }
}
