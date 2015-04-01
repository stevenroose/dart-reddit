part of reddit;


class Reddit {

  static final Uri _BASE_API_URI_PUBLIC = Uri.parse("http://www.reddit.com/");
  static final Uri _BASE_API_URI_OAUTH2 = Uri.parse("https://oauth.reddit.com/");

  static final Uri _AUTH_ENDPOINT =  Uri.parse("https://www.reddit.com/api/v1/authorize");
  static final Uri _TOKEN_ENDPOINT = Uri.parse("https://www.reddit.com/api/v1/access_token");

  static final Logger logger = new Logger("reddit");


  Client _client;
  bool _oauthEnabled;


  Reddit(Client this._client) : _oauthEnabled = false;


  Subreddit get frontPage => new Subreddit._(this, null);

  Subreddit sub(String sub) => new Subreddit._(this, sub);

  RedditUser user(String username) => new RedditUser._(this, username);


  /* BROWSE SUBREDDITS */

  /**
   * Allowed filters are all Listing filters.
   */
  Listing newSubreddits() => new Listing._(this, "subreddits/new", {});

  /**
   * Allowed filters are all Listing filters.
   */
  Listing popularSubreddits() => new Listing._(this, "subreddits/popular", {});

  /**
   * Allowed filters are "omit".
   */
  FilterableQuery recommendedSubreddits(Iterable<String> subs) =>
      new FilterableQuery._(this, "api/recommend/sr/${subs.join(",")}", {}, ["omit"]);

  /**
   * Allowed filters are all Listing filters.
   */
  Listing searchSubreddits(String query) => new Listing._(this, "subreddits/search", {"q": query});

  Query subredditsByTopic(String topic) => new Query._(this, "api/subreddits_by_topic", {"query": topic});

  /**
   * Allowed filters are "id", "limit", "url".
   */
  FilterableQuery info() => new FilterableQuery._(this, "api/info", {}, ["id", "limit", "url"]);


  /* AUTHENTICATION */

  Uri _baseApiUri() => _oauthEnabled ? _BASE_API_URI_OAUTH2 : _BASE_API_URI_PUBLIC;

  /**
   * Setup App-only OAuth. This allows for accessing OAuth-only endpoints.
   *
   * This method will be required after August 3, 2015:
   * https://www.reddit.com/r/redditdev/comments/2ujhkr/important_api_licensing_terms_clarified/
   */
  Future<Reddit> setupUserlessOAuth2 (String identifier, String secret) {
    logger.info("Requesting a userless OAuth2 token at $_TOKEN_ENDPOINT");
    DateTime startTime = new DateTime.now();
    return _client.post(_TOKEN_ENDPOINT.replace(userInfo: "$identifier:$secret"), body: {
      "grant_type": "client_credentials",
      "username": "",
      "password": ""
    }).then((Response response) {
      logger.info("Access token response: [${response.statusCode}] ${response.body}");
      oauth2.Credentials credentials = handleAccessTokenResponse(response, _TOKEN_ENDPOINT, startTime, ["*"]);
      oauth2.Client oauthClient = new oauth2.Client(identifier, secret, credentials, httpClient: _client);
      _client = oauthClient;
      _oauthEnabled = true;
      return this;
    });
  }

}
