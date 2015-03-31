library reddit.query;

import "dart:async";
import "dart:convert";

import "package:http/http.dart";
import "package:json_object/json_object.dart";

import "reddit.dart";

class Query {

  Client _client;

  String resourse;
  Map params;

  Query(Client this._client, String this.resourse, Map this.params);

  Future<JsonObject> fetch() {
    String url = _redditUrl(resourse, params);
    Reddit.logger.fine("Fetching url: $url");
    return _client.get(url).then((Response response) {
      return new JsonObject.fromJsonString(response.body);
    });
  }

  static String _redditUrl(String resourse, Map params) {
    String url = "http://www.reddit.com/";
    if (params.containsKey("subreddit")) {
      url += "r/${params["subreddit"]}/";
    }
    url += resourse + ".json";
    var qs = [];
    for (String key in params.keys) {
      if (key == "subreddit") continue;
      String part = Uri.encodeQueryComponent(key);
      var val = params[key];
      if (val != null) {
        part += "=" + Uri.encodeQueryComponent(val.toString());
      }
      qs.add(part);
    }
    url += "?" + qs.join("&");
    return url;
  }
}

@proxy
class FilterableQuery extends Query {

  /// The allowed filters
  Iterable<String> _filters;

  FilterableQuery(Client client, String resource, Map params, [Iterable<String> this._filters = const []])
      : super(client, resource, params);

  FilterableQuery filter(String filter, [String param]) {
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
