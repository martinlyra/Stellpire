import 'dart:core';

import 'package:Stellpire/game_data.dart';
import 'package:Stellpire/game_data_service.dart';
import 'package:Stellpire/src/item_selection/item_selection_component.dart';
import 'package:Stellpire/table_item_factory.dart';
import 'package:angular/angular.dart';
import 'package:pdx_data_tools/pdx_data_tools.dart';

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

  GameData currentGameData;

  StellpireApplication();

  factory StellpireApplication.buildAndRun()
  {
    var inst = new StellpireApplication();

    return inst;
  }

  @override
  void ngAfterViewInit() async {
    await gameDataService.whenInitialized();

    currentGameData = await gameDataService.loadDefault();

    var traits = currentGameData.speciesTraits.where(
        (trait) => trait.initial && !trait.isHabitatPreference()
    ).expand(
        (trait) =>
            [
              new SpeciesTraitItemFactory(
                "images/icons/traits",
                "english",
                localization).facilitate(trait
            )]
    );

    availableTraits.items = traits;
    /*availableTraits.factory =
    new SpeciesTraitTableEntryFactory(
        "images/icons/traits",
        "english",
        localization);*/
  }
}