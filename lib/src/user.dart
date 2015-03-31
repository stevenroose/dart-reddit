library reddit.user;


import "package:http/http.dart";

import "listing.dart";
import "query.dart";


/**
 *
 * Keep in mind that most users hide certain information from their public profile. This information is not
 * accessible through the API either.
 */
class RedditUser {

  Client _client;

  final String name;

  RedditUser(Client this._client, String this.name);


  String _res(String res) => "user/$name/$res";

  /* ABOUT */

  Query about() => new Query(_client, _res("about"), {});


  /* CONTENT */

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing overview([String t]) {
    Listing listing = new Listing(_client, _res("overview"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing submitted([String t]) {
    Listing listing = new Listing(_client, _res("submitted"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing comments([String t]) {
    Listing listing = new Listing(_client, _res("comments"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing liked([String t]) {
    Listing listing = new Listing(_client, _res("liked"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing disliked([String t]) {
    Listing listing = new Listing(_client, _res("disliked"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing hidden([String t]) {
    Listing listing = new Listing(_client, _res("hidden"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing saved([String t]) {
    Listing listing = new Listing(_client, _res("saved"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }

  /**
   *
   * The parameter [t] is equivalent to using the "t" filter.
   *
   * Allowed filters are "sort", "t" and all Listing filters.
   */
  Listing gilded([String t]) {
    Listing listing = new Listing(_client, _res("gilded"), {}, ["sort", "t"]);
    return t != null ? listing.filter("t", t) : listing;
  }


  /* MULTIS */

  /**
   * Allowed filters are "expand_srs".
   */
  FilterableQuery multis() => new FilterableQuery(_client, "api/multi/user/$name", {}, ["expand_srs"]);


  /* TROPHIES */

  Query trophies() => new Query(_client, "api/v1/user/$name/trophies", {});




}