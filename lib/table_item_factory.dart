import 'dart:html';

import 'package:Stellpire/src/pdx_stellaris/data_object.dart';
import 'package:Stellpire/src/pdx_stellaris/species_trait.dart';
import 'package:pdx_data_tools/pdx_data_tools.dart';

class TableItem {
  final Object reference;
  final String displayIcon;
  final String displayString;
  final int displayCost;

  TableItem(
      this.reference,
      this.displayIcon,
      this.displayString,
      this.displayCost
      );
}

abstract class TableItemFactory<T extends DataObject> {
  final Localization localization;
  final String targetLocale;
  final String imageDirectory;

  TableItemFactory(this.imageDirectory, this.targetLocale, this.localization);

  TableItem facilitate(T object);
}

class SpeciesTraitItemFactory extends
    TableItemFactory<SpeciesTrait> {

  SpeciesTraitItemFactory(
      String imageDirectory,
      String targetLocale,
      Localization localization)
      : super(imageDirectory, targetLocale, localization);

  @override
  TableItem facilitate(SpeciesTrait object) {
    return new TableItem(
      object,
      "$imageDirectory/${object.key}.dds.png",
      localization.getLocalizedString(targetLocale, object.key),
      object.cost
    );
  }
}