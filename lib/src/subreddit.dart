part of reddit;


class Subreddit {
  Reddit _reddit;

  final String name;

  Subreddit._(Reddit this._reddit, String this.name);

  String _res(String res) => name == null ? res : "r/$name/$res";

  Query about() => new Query._(_reddit, _res("about"), {});

  /**
   * Allowed filters are "comment", "context", "depth", "limit", "sort".
   */
  FilterableQuery comments(String article) => new FilterableQuery._(
    _reddit, _res("comments/$article"), {}, ["comment", "context", "depth", "limit", "sort"]);

  /**
   * Allowed filters are "id", "limit", "url".
   */
  FilterableQuery info() => new FilterableQuery._(_reddit, _res("api/info"), {}, ["id", "limit", "url"]);

  Query random() => new Query._(_reddit, _res("random"), {});

  /**
   * Allowed filters are "after", "before", "count", "limit", "restrict_sr", "show", "sort", "syntax", "t".
   */
  FilterableQuery search(String query) => new FilterableQuery._(_reddit, _res("search"), {"q": query},
      ["after", "before", "count", "limit", "restrict_sr", "show", "sort", "syntax", "t"]);

  /* LISTINGS */

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "t" and all Listing filters.
   */
  Listing controversial([String t]) {
    Listing listing = new Listing._(_reddit, _res("controversial"), {}, ["t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   * Allowed filters are all Listing filters.
   */
  Listing hot() => new Listing._(_reddit, _res("hot"), {});

  /**
   * Allowed filters are all Listing filters.
   */
  Listing newPosts() => new Listing._(_reddit, _res("new"), {});

  /**
   * Get the top posts for this subreddit.
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "t" and all Listing filters.
   */
  Listing top([String t]) {
    Listing listing = new Listing._(_reddit, _res("top"), {}, ["t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  @override
  String toString() => name == null ? "front page" : "r/$name";
}
