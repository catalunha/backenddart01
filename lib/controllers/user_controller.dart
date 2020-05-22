import 'package:todo/todo.dart';
import 'package:todo/models/user.dart';
import 'package:todo/utils/utils.dart';

class UserController extends ResourceController {
  UserController(this.context) {
    acceptedContentTypes = [ContentType.json];
  }
  final ManagedContext context;
  @Operation.post()
  Future<Response> postUser() async {
    final body = User()..read(await request.body.decode(), ignore: ['id']);
    body.passwordHash = Utils.generateSHA256Hash(body.password);
    final query = Query<User>(context)
      ..values.name = body.name
      ..values.email = body.email
      ..values.passwordHash = body.passwordHash;
    final user = await query.insert();
    return Response.ok("Usuario criado com sucesso. ${user.id}");
  }
}
