part of reddit;


class Query {

  Reddit _reddit;

  String resourse;
  Map params;

  Query._(Reddit this._reddit, String this.resourse, Map this.params);

  Future<JsonObject> fetch() {
    Uri uri = _redditUri(resourse, params);
    Reddit.logger.fine("Fetching url: $uri");
    return _reddit._client.get(uri).then((Response response) {
      Reddit.logger.fine("Response code ${response.statusCode}");
      return new JsonObject.fromJsonString(response.body);
    });
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
    return _reddit._baseApiUri().replace(
      path: path,
      query: qs.join("&")
    );
  }
}

@proxy
class FilterableQuery extends Query {

  /// The allowed filters
  Iterable<String> _filters;

  FilterableQuery._(Reddit reddit, String resource, Map params, [Iterable<String> this._filters = const []])
      : super._(reddit, resource, params);

  FilterableQuery filter(String filter, [dynamic param]) {
    if (_filters.contains(filter) == false) {
      throw new StateError("Filter $filter is not allowed for this query. Allowed filters are $_filters");
    }
    params[filter] = param;
    return this;
  }

  @override
  noSuchMethod(Invocation inv) {
    if (inv.isMethod == false) {
      return new NoSuchMethodError(this, inv.memberName, inv.positionalArguments, inv.namedArguments);
    }
    if (inv.positionalArguments.length > 1 || inv.namedArguments.length > 0) {
      throw new StateError("Filter methods take zero or one positional arguments.");
    }
    String symbol = inv.memberName.toString();
    String f = symbol.substring(8, symbol.length - 2);
    return filter(f, inv.positionalArguments.isEmpty ? null : inv.positionalArguments.first);
  }
}
