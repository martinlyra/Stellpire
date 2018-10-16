import 'dart:html';

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

    print(inst);

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

  TraitDom(Element targetElement, SpeciesTrait trait)
  {
    element = Element.div();
    iconImageElement = Element.img();
    iconImageElement.setAttribute("src",
        "images/icons/traits/${trait.name}.dds.png");


    element.classes.add("trait");
    element.text = trait.name;

    targetElement.children.add(element);
    element.children.add(iconImageElement);
  }
}