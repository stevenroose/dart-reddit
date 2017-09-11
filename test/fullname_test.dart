library reddit.test.fullname;

import "package:reddit/reddit.dart";
import "package:unittest/unittest.dart";

void main() {
  group("fullname", () {
    test("equals", () {
      Fullname fn1 = new Fullname("t5_2sut9");
      Fullname fn2 = new Fullname("t5_2sut9");
      expect(fn1, equals(fn2));
      expect(fn1.hashCode, equals(fn2.hashCode));
    });

    test("prefix-omitted", () {
      expect(() => new Fullname("2sut9"), throws);
    });

    test("id", () {
      Fullname fn = new Fullname("t5_2sut9");
      expect(fn.id, equals("2sut9"));
    });

    test("type", () {
      Fullname fn = new Fullname("t5_2sut9");
      expect(fn.type, equals(FullnameType.SUBREDDIT));
    });
  });
}
