part of reddit;

/**
 *
 * Keep in mind that most users hide certain information from their public profile. This information is not
 * accessible through the API either.
 */
class RedditUser {
  Reddit _reddit;

  final String name;

  RedditUser._(Reddit this._reddit, String this.name);

  String _res(String res) => "user/$name/$res";

  /* ABOUT */

  Query about() => new Query._(_reddit, _res("about"), {});

  /* CONTENT */

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing overview([String t]) {
    Listing listing =
        new Listing._(_reddit, _res("overview"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing submitted([String t]) {
    Listing listing =
        new Listing._(_reddit, _res("submitted"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing comments([String t]) {
    Listing listing =
        new Listing._(_reddit, _res("comments"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing liked([String t]) {
    Listing listing = new Listing._(_reddit, _res("liked"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing disliked([String t]) {
    Listing listing =
        new Listing._(_reddit, _res("disliked"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing hidden([String t]) {
    Listing listing = new Listing._(_reddit, _res("hidden"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing saved([String t]) {
    Listing listing = new Listing._(_reddit, _res("saved"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing gilded([String t]) {
    Listing listing = new Listing._(_reddit, _res("gilded"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /* MULTIS */

  /**
   * Allowed filters are "expand_srs".
   */
  FilterableQuery multis() => new FilterableQuery._(
      _reddit, "api/multi/user/$name", {}, ["expand_srs"]);

  /**
   * A multi curated by this user.
   */
  Multireddit multi(String multiName) =>
      new Multireddit._(_reddit, name, multiName);

  /* TROPHIES */

  Query trophies() => new Query._(_reddit, "api/v1/user/$name/trophies", {});
}
