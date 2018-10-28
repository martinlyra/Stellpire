import 'dart:async';
import 'dart:convert';

import 'package:Stellpire/src/web_io/resource.dart';
import 'package:pdx_data_tools/pdx_data_tools.dart';

class GameDataLoader {
  final String _version;
  final List<Future> _loadingResources = [];
  bool _finished = false;

  bool get isFinished => _finished;

  GameDataLoader(this._version);

  Future<Map> load() async {
    return _loadVersionData(_version);
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
}