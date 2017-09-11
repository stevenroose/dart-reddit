part of reddit;

class Subreddit extends Object with Listings {
  Reddit _reddit;

  final String name;

  Subreddit._(Reddit this._reddit, String this.name);

  String get path => name == null ? "" : "r/$name";

  Query about() => new Query._(_reddit, _res("about"), {});

  /**
   * Allowed filters are "comment", "context", "depth", "limit", "sort".
   */
  FilterableQuery comments(String article) => new FilterableQuery._(
      _reddit,
      _res("comments/$article"),
      {},
      ["comment", "context", "depth", "limit", "sort"]);

  /**
   * Allowed filters are "id", "limit", "url".
   */
  FilterableQuery info() => new FilterableQuery._(
      _reddit, _res("api/info"), {}, ["id", "limit", "url"]);

  Query random() => new Query._(_reddit, _res("random"), {});

  /**
   * Allowed filters are "after", "before", "count", "limit", "restrict_sr", "show", "sort", "syntax", "t".
   */
  FilterableQuery search(String query) =>
      new FilterableQuery._(_reddit, _res("search"), {
        "q": query,
        "restrict_sr": true
      }, [
        "after",
        "before",
        "count",
        "limit",
        "restrict_sr",
        "show",
        "sort",
        "syntax",
        "t"
      ]);

  @override
  String toString() => name == null ? "front page" : "r/$name";
}
