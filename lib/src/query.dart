part of reddit;

class Query {
  Reddit _reddit;

  String resourse;
  Map params;

  Query._(Reddit this._reddit, String this.resourse, Map this.params);

  /**
   * Fetch the data from the API. Returns a JSON Map.
   *
   * Throws a [RedditApiException] of the API returned invalid JSON.
   */
  Future<Map> fetch() async {
    Uri uri = _redditUri(resourse, params);
    Reddit.logger.fine("Fetching url: $uri");
    Response response = await _reddit._client.get(uri);
    Reddit.logger.finer("Response code ${response.statusCode}");
    try {
      return JSON.decode(response.body) as Map;
    } on FormatException catch (e) {
      var exc =
          new RedditApiException("Exception in parsing JSON from $uri", e);
      Reddit.logger.warning(exc);
      throw exc;
    }
  }

  Uri _redditUri(String resourse, Map params) {
    String path = "$resourse.json";
    var qs = [];
    for (String key in params.keys) {
      String part = Uri.encodeQueryComponent(key);
      var val = params[key];
      if (val != null) {
        part += "=" + Uri.encodeQueryComponent(val.toString());
      }
      qs.add(part);
    }
    return _reddit._baseApiUri().replace(path: path, query: qs.join("&"));
  }
}

@proxy
class FilterableQuery extends Query {
  /// The allowed filters
  Iterable<String> _filters;

  FilterableQuery._(Reddit reddit, String resource, Map params,
      [Iterable<String> this._filters = const []])
      : super._(reddit, resource, params);

  FilterableQuery filter(String filter, [dynamic param]) {
    if (_filters.contains(filter) == false) {
      throw new StateError(
          "Filter $filter is not allowed for this query. Allowed filters are $_filters");
    }
    params[filter] = param;
    return this;
  }

  @override
  noSuchMethod(Invocation inv) {
    if (inv.isMethod == false) {
      return new NoSuchMethodError(
          this, inv.memberName, inv.positionalArguments, inv.namedArguments);
    }
    if (inv.positionalArguments.length > 1 || inv.namedArguments.length > 0) {
      throw new StateError(
          "Filter methods take zero or one positional arguments.");
    }
    String symbol = inv.memberName.toString();
    String f = symbol.substring(8, symbol.length - 2);
    return filter(f,
        inv.positionalArguments.isEmpty ? null : inv.positionalArguments.first);
  }
}

class RedditApiException implements Exception {
  String message;
  var reason;
  RedditApiException([this.message, this.reason]);
  @override
  String toString() => "RedditApiException: $message\nReason: $reason";
}
