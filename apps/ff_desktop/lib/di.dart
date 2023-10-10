import 'package:get_it/get_it.dart';
import 'package:local_entity_provider/local_entity_provider.dart';

import 'package:ff_desktop/features/features.dart';

final injector = GetIt.instance;

class Injector {
  static Future<void> setup() async {
    injector.registerLazySingleton<LocalEntityProvider>(
      () => LocalEntityProvider(),
    );

    injector.registerLazySingleton<ExploreViewModel>(
      () => ExploreViewModel(),
    );
  }
}
