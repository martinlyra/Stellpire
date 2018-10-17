import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

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
  List<Object> items = List();

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
  }

}