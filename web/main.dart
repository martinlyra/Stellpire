import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import 'package:Stellpire/game_data_service.dart';
import 'package:Stellpire/stellpire_app.template.dart' as ng;

void main() {
  print('Initializing game data service');
  // Begin loading game data for Stellaris
  gameDataService.initialize();

  print('Initializing app interface');
  // As we load the game data, start the app and build the interface
  runApp(ng.StellpireApplicationNgFactory);

  // Hide the pre-screen
  var preScreen = querySelector("#pre-screen");
  preScreen.style.display = "none";
}


