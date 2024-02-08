import 'package:edge_shelf/cors_headers_middleware.dart';
import 'package:edge_shelf/shelf_edge_adapter.dart';
import 'package:example/src/example_api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:supabase_functions/supabase_functions.dart';

Handler createShelfApi() {
  const String functionName = 'example_function';

  // This will be the top-level route handler.
  // E.g. it will handle all requests coming into
  // https://<your project-id>.supabase.co/functions/v1/example_function
  final topLevelRouter = Router();
  final endpointsRouter = Router();
  topLevelRouter.mount('/$functionName', endpointsRouter);

  final api = ExampleApi();

  // POST https://<your project-id>.supabase.co/functions/v1/example_function/echo
  endpointsRouter.post('/echo', api.echo);

  return const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(CorsHeadersMiddleware())
      .addHandler(topLevelRouter);
}

void main() {
  final api = createShelfApi();
  final edgeAdapter = ShelfEdgeAdapter(api);
  SupabaseFunctions(fetch: edgeAdapter);
}
