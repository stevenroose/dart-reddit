library reddit.test.uri;


import "package:reddit/reddit.dart";
import "package:unittest/unittest.dart";


void main() {
  group("RedditUri", () {

    test("subreddit", () {
      Uri u = Uri.parse("http://www.reddit.com/r/Bitcoin");
      expect(RedditUri.matches(u), isTrue);
      RedditUri uri = new RedditUri(u);
      expect(uri.subReddit, equals("Bitcoin"));
    });

    test("post", () {
      Uri u = Uri.parse("https://www.reddit.com/r/Bitcoin/comments/311gfc/in_a_plea_bargain_former_dea_agent_agrees_to/");
      expect(RedditUri.matches(u), isTrue);
      RedditUri uri = new RedditUri(u);
      expect(uri.subReddit, equals("Bitcoin"));
      expect(uri.postId, equals("311gfc"));
    });

    test("comment", () {
      Uri u = Uri.parse("https://www.reddit.com/r/Bitcoin/comments/311gfc/in_a_plea_bargain_former_dea_agent_agrees_to/cpxog28");
      expect(RedditUri.matches(u), isTrue);
      RedditUri uri = new RedditUri(u);
      expect(uri.subReddit, equals("Bitcoin"));
      expect(uri.postId, equals("311gfc"));
      expect(uri.commentId, equals("cpxog28"));
    });

    test("query bit", () {
      Uri u = Uri.parse("https://www.reddit.com/r/Bitcoin/comments/311gfc/in_a_plea_bargain_former_dea_agent_agrees_to/cpxog28?context=1");
      expect(RedditUri.matches(u), isTrue);
      RedditUri uri = new RedditUri(u);
      expect(uri.subReddit, equals("Bitcoin"));
      expect(uri.postId, equals("311gfc"));
      expect(uri.commentId, equals("cpxog28"));
    });

    test("user", () {
      Uri u = Uri.parse("https://www.reddit.com/user/sroose/");
      expect(RedditUri.matches(u), isTrue);
      RedditUri uri = new RedditUri(u);
      expect(uri.userName, equals("sroose"));
    });

    test("user comments", () {
      Uri u = Uri.parse("https://www.reddit.com/user/sroose/comments");
      expect(RedditUri.matches(u), isTrue);
      RedditUri uri = new RedditUri(u);
      expect(uri.userName, equals("sroose"));
    });
  });
}