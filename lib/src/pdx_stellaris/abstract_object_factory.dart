import 'package:Stellpire/src/pdx_stellaris/data_object.dart';

abstract class AbstractObjectFactory<T extends DataObject> {
  T facilitate(String key, Map map );
}