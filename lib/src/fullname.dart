library reddit.fullname;

class Fullname {
  static final RegExp _regExp = new RegExp(r"^t[1-9]\_[0-9a-z]+$");

  String fullname;

  Fullname(String this.fullname) {
    if (_regExp.hasMatch(fullname) == false) {
      throw new ArgumentError("The given string $fullname is not a valid fullname."
          "See the reddit documentation for more info: https://www.reddit.com/dev/api/oauth#fullnames");
    }
  }

  factory Fullname.cast(dynamic from) {
    if (from is Fullname) {
      return from;
    } else if (from is String) {
      return new Fullname(from);
    }
    throw new ArgumentError("Can only cast a fullname from a String.");
  }

  @override
  String toString() => fullname;

  @override
  bool operator ==(other) => other is Fullname && other.fullname == fullname;

  @override
  int get hashCode => fullname.hashCode;
}
