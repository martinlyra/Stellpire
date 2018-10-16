import 'dart:async';
import 'dart:html';
import 'dart:convert';
import 'src/pdx-data-tools/parser.dart';
import 'src/pdx-stellaris/species-trait.dart';
import 'src/web-io/resource.dart';

void main() {

  var preScreen = querySelector("#pre-screen");

  preScreen.style.display = "none";

  PdxSteApplication.buildAndRun();
}

class PdxSteApplication {
  String version = "";

  Map<String, Future<Map<String, Future<Object>>>> data = Map();

  PdxSteApplication();

  factory PdxSteApplication.buildAndRun()
  {
    var inst = new PdxSteApplication();

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

  Future _loadVersionData(String targetVersion) async
  {
    var basePath = "ref/${targetVersion}";
    var manifest = jsonDecode((await Resource
        .fetch("${basePath}/version_manifest.json")).content);

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
      print(file);
      var traits = (await files[file]) as Map;
      for (String trait in traits.keys) {
        if (trait.startsWith("@"))
          continue;
        print(traits[trait]);
        new TraitDom(out, SpeciesTrait.fromJson(trait, traits[trait]));
      }
    }
  }
}


