import 'dart:html';

import 'package:Stellpire/src/pdx_stellaris/data_object.dart';
import 'package:Stellpire/src/pdx_stellaris/species_trait.dart';
import 'package:Stellpire/table_item_factory.dart';
import 'package:angular/angular.dart';
import 'package:pdx_data_tools/pdx_data_tools.dart';

@Component(
  selector: 'item-selection',
  styleUrls: ['item_selection_component.css'],
  templateUrl: 'item_selection_component.html',
  directives: [
    NgFor,
    NgIf,
  ]
)
class ItemSelectionComponent extends OnInit
{
  Iterable<DataObject> items = List();
  String imageDirectory;
  String targetLocale;
  Localization localization;

  TableItemFactory<DataObject> factory;

  String getString(DataObject object) {
    if (object is SpeciesTrait)
      return
        localization.getLocalizedString(
            targetLocale,
            object.key);
    return "";
  }

  String getIcon(DataObject object) {
    if (object is SpeciesTrait)
      return "$imageDirectory/${object.key}.dds.png";
    return "";
  }

  int getCost(DataObject object) {
    if (object is SpeciesTrait)
      return object.cost;
    return 0;
  }

  Element asItem(DataObject object) {
    return factory?.facilitate(object);
  }

  @override
  void ngOnInit() {

  }
}