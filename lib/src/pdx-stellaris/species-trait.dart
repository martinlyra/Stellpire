import 'dart:html';

import '../pdx-data-tools/localization.dart';

class SpeciesTrait
{
  String name = "undefined";
  String iconName = "trait_unknown";
  int cost = 0;

  bool initial = true;
  bool randomized = true;
  bool modification = true;
  bool improvesLeaders = false;
  bool advancedTrait = false;


  List opposites = List();
  List allowedArchtypes = List();

  List modifiers = List();

  SpeciesTrait();

  factory SpeciesTrait.fromJson(String name, Map json)
  {
    var inst = new SpeciesTrait();

    inst.name = name;
    if (json.containsKey('icon'))
      inst.iconName = json['icon'];
    else
      inst.iconName = name;

    if (json.containsKey('cost'))
      inst.cost = int.parse(json['cost']);

    return inst;
  }
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