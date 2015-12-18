part of reddit;


abstract class Listings {
  Reddit _reddit;

  String get path;

  String _res(String res) => name == null ? res : "$path/$res";



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
}