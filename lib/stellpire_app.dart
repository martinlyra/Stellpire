import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:Stellpire/game_data_service.dart';
import 'package:Stellpire/src/item_selection/item_selection_component.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'app',
  styleUrls: ['templates/app_component.css'],
  templateUrl: 'templates/app_component.html',
  directives: [
    ItemSelectionComponent
  ]
)
class StellpireApplication extends AfterViewInit {


  @ViewChild("traits_available")
  ItemSelectionComponent availableTraits;
  @ViewChild("traits_selected")
  ItemSelectionComponent selectedTraits;

  String version = "";

  StellpireApplication();

  factory StellpireApplication.buildAndRun()
  {
    var inst = new StellpireApplication();

    return inst;
  }

  /*
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
  }*/

  @override
  void ngAfterViewInit() async {
    await gameDataService.whenInitialized();
    var traits = gameDataService.buildTraitObjects();
    availableTraits.items = traits;
    // TODO: implement ngAfterViewInit
  }
}