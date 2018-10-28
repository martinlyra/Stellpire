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
  Iterable<TableItem> items = List();

  @override
  void ngOnInit() {

  }
}