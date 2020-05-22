import 'package:todo/controllers/session_controller.dart';
import 'package:todo/controllers/to_do_controller.dart';
import 'package:todo/controllers/user_controller.dart';
import 'package:todo/middlewares/jwt_middleware.dart';
import 'todo.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class TodoChannel extends ApplicationChannel {
  ManagedContext context;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        "postgres", "postgres", "localhost", 5432, "postgres");
    context = ManagedContext(dataModel, persistentStore);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    // router.route("/example").linkFunction((request) async {
    //   return Response.ok({"key": "value"});
    // });
    router
        .route("/todo/[:id]")
        .link(() => JwtMiddleware(context))
        .link(() => ToDoController(context));
    router.route("/user/[:id]").link(() => UserController(context));
    router.route("/session/[:id]").link(() => SessionController(context));
    return router;
  }
}
