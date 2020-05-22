// import 'package:aqueduct/aqueduct.dart';
import 'package:todo/models/user.dart';
import 'package:todo/todo.dart';

class ToDo extends ManagedObject<_ToDo> implements _ToDo {}

class _ToDo {
  @primaryKey
  int id;
  String name;
  bool done;
  @Relate(#toDo)
  User user;
}

// class ToDo extends Serializable {
//   int id;
//   String name;
//   bool done;
//   @override
//   Map<String, dynamic> asMap() {
//     return {"id": id, "name": name, "done": done};
//   }

//   @override
//   void readFromMap(Map<String, dynamic> object) {
//     id = object["id"] as int;
//     name = object["name"] as String;
//     done = object["done"] as bool;
//   }
// }
