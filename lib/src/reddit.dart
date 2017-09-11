part of reddit;


class Reddit {

  static final Uri _BASE_API_URI_PUBLIC = Uri.parse("http://www.reddit.com/");
  static final Uri _BASE_API_URI_OAUTH2 = Uri.parse("https://oauth.reddit.com/");

  static final Uri _AUTH_ENDPOINT =  Uri.parse("https://www.reddit.com/api/v1/authorize");
  static final Uri _TOKEN_ENDPOINT = Uri.parse("https://www.reddit.com/api/v1/access_token");

  static final Logger logger = new Logger("reddit");


  Client _client;
  Subreddit _front;


  Reddit(Client this._client) : _oauthEnabled = false {
    _front = new Subreddit._(this, null);
  }


  Subreddit get frontPage => _front;

  Subreddit sub(String sub) => new Subreddit._(this, sub);

  RedditUser user(String username) => new RedditUser._(this, username);

//  FilterableQuery multi(String multiPath) => new FilterableQuery._(this, "api/multi/$multiPath", {}, ["expand_srs"]);
  Multireddit multi(String user, String multiName) => new Multireddit._(this, user, multiName);


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

  bool _oauthEnabled;
  oauth2.AuthorizationCodeGrant _grant;

  /**
   * Start the OAuth2 setup.
   *
   * After calling this method, directly call [authFinish] for App-only auth or use the [authUrl] to get
   * authorization information from the user and provide those to [authFinish].
   *
   * Using OAuth will be required after August 3, 2015:
   * https://www.reddit.com/r/redditdev/comments/2ujhkr/important_api_licensing_terms_clarified/
   */
  void authSetup(String identifier, String secret) {
    if (_grant != null) throw new StateError("Should not call this method twice");
    if (_oauthEnabled) throw new StateError("OAuth2 is already enabled");
    _grant = new oauth2.AuthorizationCodeGrant(
        identifier, _AUTH_ENDPOINT, _TOKEN_ENDPOINT, secret: secret, httpClient: _client);
  }

  /**
   * Get the authorization URL to forward a user to to get auth information.
   */
  Uri authUrl(redirectUrl, {List<String> scopes, String state}) {
    if (_grant == null) throw new StateError("Should first call setupOAuth2");
    if (_oauthEnabled) throw new StateError("OAuth2 is already enabled");
    if (redirectUrl is String) redirectUrl = Uri.parse(redirectUrl);
    else if (redirectUrl is! Uri) throw new ArgumentError("redirectUrl parameter must be either of type Uri or String");
    return _grant.getAuthorizationUrl(redirectUrl, scopes: scopes, state: state);
  }

  /**
   * Finish the OAuth2 setup.
   *
   * There are several options:
   *
   * - App-only auth
   *   Use either no parameters or provide [username] and [password]. Note that not passing user information will
   *   often result in getting 503 errors. E.g.
   *
   *     await reddit.authFinish(username: "sroose", password: "you wish");
   *     // or
   *     await reddit.authFinish();
   *
   * - User auth
   *   Provide either [response] or [code], depending on what you received from the authorization server.
   *   In most cases, the response from the server contains the code, but you can also just provide the complete
   *   response. E.g.
   *
   *     await reddit.authFinish(code: "code_from_server");
   *     // or
   *     await reddit.authFinish(response: authServerResponse);
   *
   * The Reddit instance provided by the Future, is the same as the instance this method is invoked on.
   */
  Future<Reddit> authFinish({Map response, String code, String username, String password}) async {
    if (_grant == null) throw new StateError("Should first call setupOAuth2");
    if (_oauthEnabled) throw new StateError("OAuth2 is already enabled");

    // shortening stuff
    Reddit withAuthClient(Client oauthClient) {
      logger.info("OAuth2 setup successful.");
      _client = oauthClient;
      _oauthEnabled = true;
      _grant = null;
      return this;
    }

    if (response == null && code == null) {
      // APP-ONLY AUTH
      logger.info("Requesting a userless OAuth2 token at $_TOKEN_ENDPOINT");
      DateTime startTime = new DateTime.now();
      Response response = await _client.post(_TOKEN_ENDPOINT.replace(userInfo: "${_grant.identifier}:${_grant.secret}"), body: {
        "grant_type": "client_credentials",
        "username": username == null ? "" : username,
        "password": password == null ? "" : password,
        "duration": "permanent"
      });
      logger.fine("Access token response: [${response.statusCode}] ${response.body}");
      oauth2.Credentials credentials = handleAccessTokenResponse(response, _TOKEN_ENDPOINT, startTime, ["*"], "");
      oauth2.Client oauthClient = new oauth2.Client(credentials, identifier: _grant.identifier, secret: _grant.secret, httpClient: _client);
      return withAuthClient(oauthClient);
    } else {
      // USER-ENABLED AUTH
      //  (flow using AuthorizationCodeGrant from oauth2 package)
      logger.info("Enabling user authentication.");
      if (response != null && code == null) {
        return withAuthClient(await _grant.handleAuthorizationResponse(response));
      } else if (code != null && response == null) {
        return withAuthClient(await _grant.handleAuthorizationCode(code));
      } else {
        throw new ArgumentError("Only either of response and code should be provided.");
      }
    }
  }

}
