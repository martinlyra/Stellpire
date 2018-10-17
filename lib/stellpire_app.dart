import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:Stellpire/src/item_selection/item_selection_component.dart';
import 'package:angular/angular.dart';

import 'src/pdx-data-tools/localization.dart';
import 'src/pdx-data-tools/parser.dart';
import 'src/pdx-stellaris/species-trait.dart';
import 'src/web-io/resource.dart';

@Component(
  selector: 'app',
  styleUrls: ['templates/app_component.css'],
  templateUrl: 'templates/app_component.html',
  directives: [
    ItemSelectionComponent
  ]
)
class StellpireApplication {
  String version = "";

  Map<String, Future<Map<String, Future<Object>>>> data = Map();

  List<Future> loadingResources = List();

  StellpireApplication();

  factory StellpireApplication.buildAndRun()
  {
    var inst = new StellpireApplication();

    Resource.fetch("ref/config.json").then(
            (file) {
          inst._initialize(file.content);
        }
    );

    return inst;
  }

  void _initialize(String configFileContent)
  {
    var config = jsonDecode(configFileContent);
    var versionConf = config["Versions"];

    version = versionConf["Default"];

    querySelector('#output').text = version + "\n";

    _loadVersionData(version).then((param) => testLoadTraits());
  }

  void _loadLocalization(String basePath, Map localizationMap)
  {
    for (var language in (localizationMap).keys) {
      for (var file in localizationMap[language]) {
        loadingResources.add(Resource.fetch("${basePath}/${file}").then(
                (file) {
              localization.addLocalization(language, file.content);
            }
        ));
      }
    }
  }

  Future _loadVersionData(String targetVersion) async
  {
    var basePath = "ref/${targetVersion}";
    var manifest = jsonDecode((await Resource
        .fetch("${basePath}/version_manifest.json")).content);

    _loadLocalization(basePath, manifest['Localization']);

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

      loadingResources.addAll(resources.values);

      data[targetKey] = Future(() async {
        for (var loading in resources.values)
          await loading;
        return resources;
      });
    }
  }


  void testLoadTraits() async
  {
    var files = await data["traits"];

    var out = querySelector("#output");

    for (var file in files.keys) {
      var traits = (await files[file]) as Map;
      for (String trait in traits.keys) {
        if (trait.startsWith("@"))
          continue;

        new TraitDom(out, SpeciesTrait.fromJson(trait, traits[trait]));
      }
    }
  }
}