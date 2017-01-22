# Changelog

## 0.4.0 (2017-01-22)

- Fix `subreddit.search()` to restrict results to the subreddit

## 0.3.3 (2015-12-18)

- Upgraded dependencies to latest versions
- Adapted to breaking changes in oauth2 v1.0.0
- Added better support for multireddits

## 0.3.2 (2015-04-03)

- Updated RedditUri with official regex and extra test
- Updated README
- Constant constructor for Fullname
- Improved exception handling in Query

## 0.3.1 (2015-04-02)

- Added FullnameType enum
- Added Fullname.id and Fullname.type getters
- Bugfix in FilterableQuery.filter

## 0.3.0 (2015-04-01)

- Added full OAuth2 support (app-only and user)
- Changed auth interface
- Expose RedditUri and Fullname classes

## 0.2.0 (2015-04-01)

- Added App-only OAuth support, inspired by raw.js

## 0.1.0 (2015-03-31)

- Initial version, inspired by reddit.js
