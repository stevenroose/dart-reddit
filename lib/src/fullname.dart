library reddit.fullname;

class Fullname {
  static final RegExp _regExp = new RegExp(r"^t[1-9]\_[0-9a-z]+$");

  String _value;

  Fullname(String this._value) {
    if (_regExp.hasMatch(_value) == false) {
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

  @override
  String toString() => _value;

  @override
  bool operator ==(other) => other is Fullname && other._value == _value;

  @override
  int get hashCode => _value.hashCode;
}
