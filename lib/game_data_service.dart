
import 'dart:async';

final GameDataService gameDataService = GameDataService();

class GameDataService {
  bool _initialized = false;

  GameDataService();

  Future whenInitialized() async {
    while(!_initialized);
  }

  Future<Null> initialize() async {

  }

  bool get initialized => _initialized;
}