import 'package:Stellpire/src/pdx_stellaris/abstract_object_factory.dart';
import 'package:Stellpire/src/pdx_stellaris/data_object.dart';
import 'package:pdx_data_tools/pdx_data_tools.dart';

import 'empire_ethics.pdt_factory.g.dart';

@PdxDataObject()
class EmpireEthics extends DataObject {
  @DataField("cost", 0)
  int cost;

  @DataField("category", "")
  String category;
  @DataField("category_value", 0)
  int categoryValue;

  @DataField("use_for_pops", true)
  bool useForPops;

  @DataField("country_modifier", {})
  Map countryModifiers;

  @DataField("tags", [])
  List tags;

}

class EmpireEthicFactory implements AbstractObjectFactory<EmpireEthics> {
  @override
  EmpireEthics facilitate(String key, Map map) =>
      deserializeEmpireEthics(key, map);
}