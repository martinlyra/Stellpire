import 'dart:html';

import 'package:Stellpire/src/pdx_stellaris/data_object.dart';
import 'package:Stellpire/src/pdx_stellaris/species_trait.dart';
import 'package:pdx_data_tools/pdx_data_tools.dart';

abstract class TableItemFactory<T extends DataObject> {
  final Localization localization;
  final String targetLocale;
  final String imageDirectory;

  TableItemFactory(this.imageDirectory, this.targetLocale, this.localization);

  Element facilitate(T object);
}

class SpeciesTraitTableEntryFactory extends
    TableItemFactory<SpeciesTrait> {

  SpeciesTraitTableEntryFactory(
      String imageDirectory,
      String targetLocale,
      Localization localization)
      : super(imageDirectory, targetLocale, localization);

  @override
  Element facilitate(SpeciesTrait object) {
    var entryRow = new Element.tr();

    var imagePath =
        "$imageDirectory/${object.key}.dds.png";
    var localizedString =
    localization.getLocalizedString(targetLocale, object.key);
    var costValue = object.cost;

    var icon = new Element.td();
    icon.id = "trait_icon";

    var iconImage = new Element.img();
    iconImage.setAttribute("src", imagePath);
    icon.children.add(iconImage);

    var name = new Element.td();
    name.id = "trait_name";
    name.text = localizedString;

    var cost = new Element.td();
    cost.id = "trait_cost";
    cost.text = costValue.toString();

    entryRow.children.add(icon);
    entryRow.children.add(name);
    entryRow.children.add(cost);

    return entryRow;
  }
}