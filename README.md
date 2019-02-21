# dart-reddit

A Reddit library for Dart, inspired by reddit.js (API) and raw.js (Auth).

## Documentation

See the [Dart documentation](http://www.dartdocs.org/documentation/reddit/latest/).

## Usage

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  reddit: any
```

### Creating a client

The top class `Reddit` takes a `Client` as parameter.
This client can be constructed using the[`http`](https://pub.dartlang.org/packages/http) package.

```dart
// in Dart VM
Reddit reddit = new Reddit(new Client());
// in browser
Reddit reddit = new Reddit(new BrowserClient());
```

### OAuth

OAuth is required for all endpoints. To enable OAuth, you will need an app identifier and a secret. Get them [here](https://www.reddit.com/prefs/apps).

There are two options: App-only and User authorization.

 - App-only auth

```dart
reddit.authSetup(identifier, secret);
// with user info
await reddit.authFinish(username: "sroose", password: "correct horse battery staple");
// or without
await reddit.authFinish();
```

Note that not providing (developer) user info will result in getting 503 Service Unavailable responses after a while.

 - User-enabled auth

```dart
reddit.authSetup(identifier, secret);
Uri authUrl = reddit.authUrl("https://myapp.com/auth_redirect");
// redirect user to authUrl and gather the response from the auth server
await reddit.authFinish(response: authServerResponse);
// or if you already extracted the auth code from the response
await reddit.authFinish(code: authCode);
```


### Queries, filters and listings

Most methods in the API construct a `Query`, which can be fetched to get a future with the results.

Most queries allow filtering. For the supported filters, we refer to the [Reddit API docs](https://www.reddit.com/dev/api/oauth#scope_read) or the [documentation for this library](#documentation).

```dart
// without filters
reddit.frontPage.newPosts().fetch().then(print);
// filtered
reddit.frontPage.hot().limit(10).fetch().then(print);
```

A lot of queries also are [listings](https://www.reddit.com/dev/api/oauth#listings).
Listings allow for browsing through content across multiple queries.

```dart
// using the regular fetch() method (not recommended)
reddit.sub("dartlang").top("day").fetch().then((result) {
  print(result);
  if (notEnough) {
    result.fetchMore().then((result) {
      print(result);
      if (stillNotEnough) {
        result.fetchmore().then(print);
      }
    });
  }
});

// or using the dart:async API
reddit.sub("dartlang").top("month").listen((result) {
  print(result);
  if (notEnough) {
    result.fetchMore();
  }
})
```


### Browsing Reddit

You can use the standard read-only API to browse Reddit.

```dart
// the front page
reddit.front.hot().fetch().then(print);
// or subreddits
reddit.sub("dartlang").hot().fetch().then(print);
```

Some examples using filters:

```dart
reddit.sub("dartlang").top().t("day").limit(10).fetch().then(print);
```

### Comments

Fetching comments for a link:

```dart
reddit.sub("dartlang").comments("2ek93l").depth(3).fetch().then(print);
```

Or a single comment:

```dart
reddit.sub("dartlang").comments("2ek93l").comment("ck0mkcy").context(2).fetch().then(print);
```

### Search

Search through reddit:

```dart
reddit.sub("dartlang").search("reddit api").limit(5).sort("hot").fetch().then(print);
```

### Subreddits

Find subreddits:

```dart
reddit.newSubreddits().fetch().then(print);

reddit.popularSubreddits().fetch().then(print);

reddit.recommendedSubreddits(["dartlang", "reddit"]).fetch().then(print);

reddit.subredditsByTopic("programming").fetch().then(print);
```

Get information about a subreddit:

```dart
reddit.sub("dartlang").about().fetch().then(print);
```

### Users

Get information about a user:

```dart
reddit.user("sroose").about().fetch().then(print);
```

Get listings from users:

```dart
reddit.user("sroose").comments("month").listen(print);

reddit.user("sroose").submitted("week").sort("hot").listen(print);
```

Get a list of multi's from a user:
```dart
reddit.user("sroose").multis().fetch().then(print);
```
