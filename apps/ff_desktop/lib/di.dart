import 'package:core/core.dart';
import 'package:ff_desktop/services/services.dart';
import 'package:file_explorer/file_explorer.dart';
import 'package:local_entity_provider/local_entity_provider.dart';
import 'package:theme/theme.dart';

class Injector {
  static Future<void> setup() async {
    injector.registerLazySingleton<EventBus>(() => EventBus());

    injector.registerLazySingleton<ThemeModel>(() => ThemeModel());

    injector.registerLazySingleton<LocalEntityProvider>(
      () => LocalEntityProvider(),
    );

    injector.registerLazySingleton<TabViewModel>(() => TabViewModel());

    final windowService = WindowService();
    injector.registerLazySingleton<WindowService>(() => windowService);
    injector.registerLazySingleton<WindowServiceInterface>(
      () => windowService,
    );
  }
}
