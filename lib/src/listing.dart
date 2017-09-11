part of reddit;

/**
 *
 * The filters included in a Listing are "after", "before", "count", "limit", "show".
 */
class Listing extends FilterableQuery implements Stream<ListingResult> {
  static const List<String> _LISTING_FILTERS = const [
    "after",
    "before",
    "count",
    "limit",
    "show"
  ];

  StreamController _controller;

  Listing._(Reddit reddit, String resource, Map params,
      [Iterable<String> extraFilters = const []])
      : super._(reddit, resource, params,
            []..addAll(_LISTING_FILTERS)..addAll(extraFilters)) {
    _controller = new StreamController(onListen: fetch);
  }

  Listing after(fullname) {
    if (params.containsKey("before")) {
      throw new StateError(
          "It is not possible to specify both the after and before filter.");
    }
    fullname = new Fullname.cast(fullname);
    params["after"] = fullname;
    return this;
  }

  Listing before(fullname) {
    if (params.containsKey("after")) {
      throw new StateError(
          "It is not possible to specify both the after and before filter.");
    }
    fullname = new Fullname.cast(fullname);
    params["before"] = fullname;
    return this;
  }

  Listing count([int count = 0]) {
    params["count"] = count;
    return this;
  }

  Listing limit([int limit = 25]) {
    params["limit"] = limit;
    return this;
  }

  Listing show() {
    params["show"] = "all";
    return this;
  }

  @override
  Future<ListingResult> fetch() {
    return super.fetch().then((JsonObject result) {
      if (result.containsKey("data")) {
        params["after"] = result["data"]["after"];
        params["before"] = result["data"]["before"];
      }
      ListingResult res = new ListingResult(result, this);
      _controller.add(res);
      return res;
    });
  }

  @override
  noSuchMethod(Invocation inv) {
    if (reflectClass(Stream).instanceMembers.containsKey(inv.memberName) ||
        inv.memberName == const Symbol("listen")) {
      return reflect(_controller.stream).delegate(inv);
    } else {
      return super.noSuchMethod(inv);
    }
  }
}

/**
 * This class is a JsonObject containing data on a Listing stream.
 *
 * You can use it just like the result of [Query.fetch].
 *
 * The method [fetchMore] allows to request the next batch of data.
 */
class ListingResult implements JsonObject {
  JsonObject _result;
  Listing _listing;

  ListingResult(JsonObject this._result, Listing this._listing);

  Future<ListingResult> fetchMore() => _listing.fetch();

  @override
  noSuchMethod(Invocation inv) => reflect(_result).delegate(inv);

  @override
  String toString() => _result.toString();
}
