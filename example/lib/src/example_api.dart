import 'package:shelf/shelf.dart';

class ExampleApi {
  Response echo(Request request) => Response.ok(request.readAsString());
}
