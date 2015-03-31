library reddit.subreddit;

import "package:http/http.dart";

import "listing.dart";
import "query.dart";

class Subreddit {
  Client _client;

  final String name;

  Subreddit(Client this._client, String this.name);

  String _res(String res) => name == null ? res : "r/$name/$res";

  Query about() => new Query(_client, _res("about"), {});

  /**
   * Allowed filters are "comment", "context", "depth", "limit", "sort".
   */
  FilterableQuery comments(String article) => new FilterableQuery(
      _client, _res("comments/$article"), {}, ["comment", "context", "depth", "limit", "sort"]);

  /**
   * Allowed filters are "id", "limit", "url".
   */
  FilterableQuery info() => new FilterableQuery(_client, _res("api/info"), {}, ["id", "limit", "url"]);

  Query random() => new Query(_client, _res("random"), {});

  /**
   * Allowed filters are "after", "before", "count", "limit", "restrict_sr", "show", "sort", "syntax", "t".
   */
  FilterableQuery search(String query) => new FilterableQuery(_client, _res("search"), {"q": query},
      ["after", "before", "count", "limit", "restrict_sr", "show", "sort", "syntax", "t"]);

  /* LISTINGS */

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "t" and all Listing filters.
   */
  Listing controversial([String t]) {
    Listing listing = new Listing(_client, _res("controversial"), {}, ["t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   * Allowed filters are all Listing filters.
   */
  Listing hot() => new Listing(_client, _res("hot"), {});

  /**
   * Allowed filters are all Listing filters.
   */
  Listing newPosts() => new Listing(_client, _res("new"), {});

  /**
   * Get the top posts for this subreddit.
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "t" and all Listing filters.
   */
  Listing top([String t]) {
    Listing listing = new Listing(_client, _res("top"), {}, ["t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  @override
  String toString() => name == null ? "front page" : "r/$name";
}
