
import 'dart:async';
import 'dart:convert';

import 'package:Stellpire/game_data.dart';
import 'package:Stellpire/game_data_loader.dart';
import 'package:pdx_data_tools/pdx_data_tools.dart';
import 'package:Stellpire/src/pdx_stellaris/species_trait.dart';
import 'package:Stellpire/src/web_io/resource.dart';

final GameDataService gameDataService = GameDataService();

/* TODO: Issue, the loader code is a mess and could need
 * a rewrite in the future
 */
class GameDataService {
  bool _initialized = false;

  String defaultVersion;
  List available = [];

  Map<String, Future<GameData>> loadedData = {};

  GameDataService();

  Future whenInitialized() async {
    while(!_initialized)
      await Future.delayed(Duration(milliseconds: 50), () {});
  }

  Future<Null> initialize() async {
    var configFile = await Resource.fetch("ref/config.json");

    var config = json.decode(configFile.content);

    var versionConf = config["Versions"];
    defaultVersion = versionConf["Default"];
    available = versionConf["Available"];

    loadDefault().whenComplete(() => _initialized = true);
  }

  Future<GameData> _load(String version) async {
    return new GameDataFactory(
        version,
        await new GameDataLoader(version).load()
    ).build();
  }

  Future<GameData> loadDefault() async => loadVersion(defaultVersion);

  Future<GameData> loadVersion(String version) async {
    if (!loadedData.containsKey(version))
      loadedData[version] = _load(version);
    return loadedData[version];
  }

  bool get initialized => _initialized;
}