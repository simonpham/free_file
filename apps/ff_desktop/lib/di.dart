import 'package:ff_desktop/models/models.dart';
import 'package:get_it/get_it.dart';
import 'package:local_entity_provider/local_entity_provider.dart';
import 'package:theme/theme_model.dart';

final injector = GetIt.instance;

class Injector {
  static Future<void> setup() async {
    injector.registerLazySingleton<ThemeModel>(
      () => ThemeModel(),
    );

    injector.registerLazySingleton<LocalEntityProvider>(
      () => LocalEntityProvider(),
    );

    injector.registerLazySingleton<TabViewModel>(
      () => TabViewModel(),
    );
  }
}
