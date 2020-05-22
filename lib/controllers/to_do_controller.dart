import 'package:todo/models/to_do.dart';
import 'package:todo/models/user.dart';
import 'package:todo/todo.dart';

class ToDoController extends ResourceController {
  ToDoController(this.context) {
    acceptedContentTypes = [ContentType.json];
  }
  final ManagedContext context;
  // final List<ToDo> toDos = [
  //   ToDo()
  //     ..id = 1
  //     ..name = 'Tomar café'
  //     ..done = true,
  //   ToDo()
  //     ..id = 2
  //     ..name = 'Estudar'
  //     ..done = true,
  //   ToDo()
  //     ..id = 3
  //     ..name = 'Comer'
  //     ..done = false,
  //   ToDo()
  //     ..id = 4
  //     ..name = 'Brincar'
  //     ..done = false,
  //   ToDo()
  //     ..id = 5
  //     ..name = 'Dormir'
  //     ..done = false,
  // ];
  @Operation.get()
  Future<Response> getAllToDos() async {
    final User user = request.attachments['user'] as User;
    final query = Query<ToDo>(context)
      ..where((todo) => todo.user.id).equalTo(user.id);
    final toDos = await query.fetch();
    return Response.ok(toDos);
  }

  @Operation.get('id')
  Future<Response> getToDoByID() async {
    final User user = request.attachments['user'] as User;

    final id = int.parse(request.path.variables['id']);
    // final toDo =
    //     toDos.firstWhere((element) => element.id == id, orElse: () => null);
    final query = Query<ToDo>(context)
      ..where((todo) => todo.id).equalTo(id)
      ..where((todo) => todo.user.id).equalTo(user.id);
    final toDo = await query.fetchOne();

    if (toDo == null) {
      return Response.notFound();
    }
    return Response.ok(toDo);
  }

  @Operation.post()
  // Future<Response> postToDo(@Bind.body() ToDo toDo) async {
  // toDos.add(toDo);
  Future<Response> postToDo() async {
    final User user = request.attachments['user'] as User;

    final body = ToDo()..read(await request.body.decode(), ignore: ["id"]);
    final query = Query<ToDo>(context)
      ..values.name = body.name
      ..values.done = body.done
      ..values.user.id = user.id;
    print('aqui1');
    final toDo = await query.insert();
    print('aqui2');
    return Response.ok(toDo);
  }

  // @Operation.put()
  // Future<Response> putTodo(@Bind.body() ToDo toDo) async {
  // toDos.removeAt(toDos.indexWhere((element) => element.id == toDo.id));
  // toDos.add(toDo);
  @Operation.put('id')
  Future<Response> putTodo(@Bind.path('id') int id) async {
    final User user = request.attachments['user'] as User;

    final body = ToDo()..read(await request.body.decode(), ignore: ['id']);
    final query = Query<ToDo>(context)
      ..values = body
      ..where((todo) => todo.id).equalTo(id)
      ..where((todo) => todo.user.id).equalTo(user.id);
    final toDo = await query.updateOne();
    return Response.ok(toDo);
  }

  // @Operation.delete('id')
  // Future<Response> deleteToDoByID() async {
  //   final id = int.parse(request.path.variables['id']);
  //   toDos.removeAt(toDos.indexWhere((element) => element.id == id));
  @Operation.delete('id')
  Future<Response> deleteToDoByID(@Bind.path('id') int id) async {
    final User user = request.attachments['user'] as User;

    final query = Query<ToDo>(context)
      ..where((todo) => todo.id).equalTo(id)
      ..where((todo) => todo.user.id).equalTo(user.id);

    await query.delete();
    return Response.ok({'delete': true});
  }
}
