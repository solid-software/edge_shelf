import 'package:shelf/shelf.dart';

/// Middleware that immediately returns CORS headers for all OPTIONS requests,
/// and attaches CORS headers to all other requests handled downstream.
class CorsHeadersMiddleware {
  static const _corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers':
        'authorization, x-client-info, apikey, content-type',
  };

  static const _optionsMethod = 'OPTIONS';

  Handler call(Handler innerHandler) {
    return (request) async {
      if (request.method == _optionsMethod) {
        return Response.ok(null, headers: _corsHeaders);
      }

      final response = await innerHandler(request);

      return response.change(headers: _corsHeaders);
    };
  }
}
