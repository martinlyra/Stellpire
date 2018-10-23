/**
import 'dart:mirrors';

import 'package:Stellpire/src/pdx-data-tools/data-obj.dart';

class ObjectDeserializer {
  static T deserialize<T extends PdxDataObject>
      (String key, Map json) {
    ClassMirror mirror = reflectClass(T);
    var instance = mirror
        .newInstance(null, null);

    var variables = mirror.typeVariables;
    for (var variable in variables) {
      if (variable.metadata.isEmpty)
        continue;

      var meta = variable.metadata.whereType<SerializableField>().first;
      var fieldName = variable.simpleName;

      if (json.containsKey(meta.name))
        instance.setField(fieldName, json[meta.name]);
      else {
        if (meta.defaultValue is Type) {
          var typeMirror = reflectClass(meta.defaultValue as Type);
          instance.setField(fieldName, typeMirror.newInstance(null, null));
        }
        else
          instance.setField(fieldName, meta.defaultValue);
      }
    }

    return instance.reflectee;
  }
}**/