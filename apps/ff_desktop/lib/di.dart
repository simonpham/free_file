import 'package:get_it/get_it.dart';
import 'package:local_entity_provider/local_entity_provider.dart';

final injector = GetIt.instance;

class Injector {
  static Future<void> setup() async {
    injector.registerLazySingleton<LocalEntityProvider>(
      () => LocalEntityProvider(),
    );
  }
}
