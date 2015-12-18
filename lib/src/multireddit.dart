part of reddit;


class Multireddit extends Object with Listings {
  Reddit _reddit;

  final String user;
  final String name;

  Multireddit._(Reddit this._reddit, String this.user, this.name);

  String get path => "user/$user/m/$name";


  FilterableQuery info() => new FilterableQuery._(_reddit, "api/multi/$path", {}, ["expand_srs"]);

  FilterableQuery description() => new FilterableQuery._(_reddit, "api/multi/$path/description", {});



}