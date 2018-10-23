import 'dart:html';

import 'package:pdx_data_tools/pdx_data_tools.dart';
import 'species_trait.pdt_factory.g.dart';

@PdxDataObject()
class SpeciesTrait
{
  String key;

  @DataField("name", "undefined")
  String name;

  @DataField("icon_name", "trait_unknown")
  String iconName;

  @DataField("cost", 0)
  int cost;

  @DataField("initial", true)
  bool initial;
  @DataField("randomized", true)
  bool randomized;
  @DataField("modification", true)
  bool modification;
  @DataField("improves_leaders", false)
  bool improvesLeaders = false;
  @DataField("advanced_trait", false)
  bool advancedTrait = false;

  @DataField("opposites", List)
  List opposites;
  @DataField("allowed_archtypes", List)
  List allowedArchtypes;

  @DataField("modifier", List)
  List modifiers;

  SpeciesTrait();

  factory SpeciesTrait.deserialize(String key, Map map) =>
      deserializeSpeciesTrait(key, map);
}

class TraitDom
{
  Element element;
  Element iconImageElement;
  Element textElement;
  Element costElement;

  TraitDom(Element targetElement, SpeciesTrait trait)
  {
    element = Element.div();

    iconImageElement = Element.img();
    iconImageElement.setAttribute("src",
        "images/icons/traits/${trait.name}.dds.png");

    textElement = Element.div();
    textElement.id = "trait_name";
    textElement.text = trait.name;
    localization.whenLoaded().then( (param) {
      textElement.text = localization.getLocalizedString("english", trait.name);
    });

    costElement = Element.div();
    costElement.id = "trait_cost";
    costElement.text = trait.cost.toString();

    element.classes.add("trait");
    element.children.add(iconImageElement);
    element.children.add(textElement);
    element.children.add(costElement);

    targetElement.children.add(element);
  }
}