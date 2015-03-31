library reddit.reddit;

import "package:http/http.dart";
import "package:logging/logging.dart";

import "listing.dart";
import "query.dart";
import "subreddit.dart";
import "user.dart";

class Reddit {

  static final Logger logger = new Logger("reddit");

  Client _client;

  Reddit(Client this._client);

  Subreddit get frontPage => new Subreddit(_client, null);

  Subreddit sub(String sub) => new Subreddit(_client, sub);

  RedditUser user(String username) => new RedditUser(_client, username);

  /* BROWSE SUBREDDITS */

  /**
   * Allowed filters are all Listing filters.
   */
  Listing newSubreddits() => new Listing(_client, "subreddits/new", {});

  /**
   * Allowed filters are all Listing filters.
   */
  Listing popularSubreddits() => new Listing(_client, "subreddits/popular", {});

  /**
   * Allowed filters are "omit".
   */
  FilterableQuery recommendedSubreddits(Iterable<String> subs) =>
      new FilterableQuery(_client, "api/recommend/sr/${subs.join(",")}", {}, ["omit"]);

  /**
   * Allowed filters are all Listing filters.
   */
  Listing searchSubreddits(String query) => new Listing(_client, "subreddits/search", {"q": query});

  Query subredditsByTopic(String topic) => new Query(_client, "api/subreddits_by_topic", {"query": topic});


  /**
   * Allowed filters are "id", "limit", "url".
   */
  FilterableQuery info() => new FilterableQuery(_client, "api/info", {}, ["id", "limit", "url"]);
}
