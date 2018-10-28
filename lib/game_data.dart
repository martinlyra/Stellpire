import 'dart:async';

import 'package:Stellpire/src/pdx_stellaris/abstract_object_factory.dart';
import 'package:Stellpire/src/pdx_stellaris/data_object.dart';
import 'package:Stellpire/src/pdx_stellaris/empire_ethics.dart';
import 'package:Stellpire/src/pdx_stellaris/species_trait.dart';

class GameData {
  final String version;

  List<EmpireEthics> empireEthics;
  List<SpeciesTrait> speciesTraits;

  GameData(this.version);
}

class GameDataFactory {
  final String _version;
  final Map<String, Future<dynamic>> _gameDataMap;

  GameDataFactory(this._version, this._gameDataMap);

  Future<GameData> build() async {
    var out = GameData(_version);

    out.speciesTraits =
    await _buildObjects('traits', new SpeciesTraitFactory());
    out.empireEthics =
    await _buildObjects('ethics', new EmpireEthicFactory());

    return out;
 }

 Future<List<T>>
 _buildObjects<T extends DataObject>(
     String targetKey,
     AbstractObjectFactory<T> factory
     ) async {
   var out = List<T>();
   var objectData = await _gameDataMap[targetKey];

   for (var file in objectData.keys) {
     var data = (await objectData[file]) as Map;
     for (var key in data.keys) {
       T object = factory.facilitate(key, data[key]);
       object.key = key;
       out.add(object);
     }
   }
   return out;
 }
}