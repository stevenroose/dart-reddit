library reddit.uri;



class RedditUri {

  final Uri uri;

  static final RegExp _REGEXP_SUB = new RegExp(
      r"^\/r\/([a-zA-Z0-9]+)(?:\/(?:comments\/([a-z0-9]+)\/[^\/]+)(?:\/([a-z0-9]+)?(?:\/)?)?)?$");

  static final RegExp _REGEXP_USER = new RegExp(
      r"^\/user\/([^\/]+)(?:\/(?:(comments|submitted|gilded)(?:\/)?)?)?$");

  factory RedditUri(dynamic/*String|Uri*/ uri) {
    if(uri is Uri) {
      return new RedditUri._internal(uri);
    } else if (uri is String) {
      return new RedditUri._internal(Uri.parse(uri));
    } else {
      throw new ArgumentError("uri parameter must be of type Uri or String");
    }
  }

  RedditUri._internal(Uri this.uri) {
    if (!matches(uri)) {
      throw new ArgumentError("Invalid Reddit URI: $uri");
    }
  }

  /* SUB */

  String get subReddit => _REGEXP_SUB.firstMatch(uri.path).group(1);

  String get postId => _REGEXP_SUB.firstMatch(uri.path).group(2);

  String get commentId => _REGEXP_SUB.firstMatch(uri.path).group(3);

  /* USERS */

  String get userName => _REGEXP_USER.firstMatch(uri.path).group(1);


  /* STATIC */

  static bool matches(Uri uri) {
    var parts = uri.authority.split(".");
    var l = parts.length;
    return l >= 2 && parts[l-1] == "com" && parts[l-2] == "reddit";
  }

}