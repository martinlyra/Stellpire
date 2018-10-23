
import 'dart:async';
import 'dart:convert';

import 'package:pdx_data_tools/pdx_data_tools.dart';
import 'package:Stellpire/src/pdx_stellaris/species_trait.dart';
import 'package:Stellpire/src/web_io/resource.dart';

final GameDataService gameDataService = GameDataService();

/* TODO: Issue, the loader code is a mess and could need
 * a rewrite in the future
 */
class GameDataService {
  bool _initialized = false;

  List<Future> _loadingResources = List();

  Map<String, Map<String, Object>> _gameData = Map();

  GameDataService();

  Future whenInitialized() async {
    while(!_initialized)
      await Future.delayed(Duration(milliseconds: 50), () {});
  }

  Future<Null> initialize() async {
    var configFile = await Resource.fetch("ref/config.json");

    var config = json.decode(configFile.content);

    var versionConf = config["Versions"];
    var version = versionConf["Default"];

    await _loadVersionData(version).then(await (loadingData) async
    {
      for (var key in loadingData.keys) {
        var data = await loadingData[key] as Map<String, Future<Object>>;
        var loadedData = Map<String, Object>();

        for (var file in data.keys) {
          loadedData[file] = await data[file];
        }
        _gameData[key] = loadedData;
      }

      _initialized = true;
    });
  }

  List<T> _buildDataObjects<T>
      (Map<String,Object> objectData,
      Function(String, Map) builder
      ) {
    var out = List();

    for (var file in objectData.keys) {
      var data = objectData[file] as Map;
      for (var key in data.keys)
        out.add(builder(key, data[key]));
    }
    return out;
  }

  void _loadLocalization(String basePath, Map localizationMap) {
    for (var language in (localizationMap).keys) {
      for (var file in localizationMap[language]) {
        _loadingResources.add(Resource.fetch("${basePath}/${file}").then(
                (file) {
              localization.addLocaleFromYaml(language, file.content);
            }
        ));
      }
    }
  }

  Future<Map<String, Future<Map>>> _loadVersionData(String targetVersion) async
  {
    var basePath = "ref/${targetVersion}";
    var manifest = jsonDecode((await Resource
        .fetch("${basePath}/version_manifest.json")).content);

    _loadLocalization(basePath, manifest['Localization']);

    var loadingData = Map<String, Future<Map>>();
    var loaderTargets = manifest["LoaderTargets"];
    for (var targetKey in (loaderTargets as Map).keys)
    {
      var target = loaderTargets[targetKey];
      var path = "${basePath}/${target["folder"]}";
      var files = target["files"] as List;
      var resources = Map<String, Future<Object>>();

      for (var file in files) {
        var url = "${path}/${file}\n";

        resources[file] = Resource.fetch(url).then(
                (resource) {
              return PdxDataCodec.parse(resource.content);
            }
        );
      }

      _loadingResources.addAll(resources.values);

      loadingData[targetKey] = Future(() async {
        for (var loading in resources.values)
          await loading;
        return resources;
      });
    }
    return loadingData;
  }

  List<SpeciesTrait> buildTraitObjects() {
    return _buildDataObjects(_gameData['traits'],
        (key, data) =>
        SpeciesTrait.deserialize(key, data)
    );
  }

  Map<String, Object> get(String key)
  {
    return _gameData[key];
  }

  bool get initialized => _initialized;
}