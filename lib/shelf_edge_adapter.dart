import 'dart:async';
import 'dart:typed_data';

import 'package:shelf/shelf.dart' as shelf;
import 'package:supabase_functions/supabase_functions.dart' as edge;

/// Converts between shelf and edge request/response objects.
class ShelfEdgeAdapter {
  final shelf.Handler app;

  ShelfEdgeAdapter(this.app);

  FutureOr<edge.Response> call(edge.Request request) async {
    final shelfReq = await _shelfRequest(request);
    final response = await app(shelfReq);
    final edgeRes = await _edgeResponse(response);

    return edgeRes;
  }

  Future<shelf.Request> _shelfRequest(edge.Request request) async {
    return shelf.Request(
      request.method,
      request.url,
      headers: request.headers.toMap(),
      body: await request.body?.fold<List<int>>([], (a, b) => a + b),
    );
  }

  Future<edge.Response> _edgeResponse(shelf.Response response) async {
    return edge.Response(
      Uint8List.fromList(await response.read().fold([], (a, b) => a + b)),
      status: response.statusCode,
      statusText: response.statusCode.toString(),
      headers: edge.Headers(response.headers),
    );
  }
}
