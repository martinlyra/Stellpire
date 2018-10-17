import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import 'package:Stellpire/game_data_service.dart';
import 'package:Stellpire/stellpire_app.template.dart' as ng;

void main() {
  // Begin loading game data for Stellaris
  gameDataService.initialize();

  // As we load the game data, start the app and build the interface
  runAppAsync(ng.StellpireApplicationNgFactory,
      beforeComponentCreated: (Injector ) {})
      .whenComplete( () {
        var preScreen = querySelector("#pre-screen");
        preScreen.style.display = "none";
      }
  );
}


