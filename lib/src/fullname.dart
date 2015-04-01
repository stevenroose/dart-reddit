library reddit.fullname;

class Fullname {
  static final RegExp _REG_EXP = new RegExp(r"^t([1-9])\_([0-9a-z]+$)");

  String _value;

  Fullname(String this._value) {
    if (_REG_EXP.hasMatch(_value) == false) {
      throw new ArgumentError("The given string $_value is not a valid fullname."
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

  FullnameType get type => FullnameType.values[
      int.parse(_REG_EXP.firstMatch(_value).group(1))];

  String get id   => _REG_EXP.firstMatch(_value).group(2);

  @override
  String toString() => _value;

  @override
  bool operator ==(other) => other is Fullname && other._value == _value;

  @override
  int get hashCode => _value.hashCode;
}


enum FullnameType {
  INVALID0,
  COMMENT,
  ACCOUNT,
  LINK,
  MESSAGE,
  SUBREDDIT,
  AWARD,
  INVALID7,
  PROMO_CAMPAIGN
}