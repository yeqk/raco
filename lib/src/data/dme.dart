class Dme {
  static final Dme _dme = Dme._internal();

  factory Dme() {
    return _dme;
  }

  Dme._internal();

  String username;
  String nom;
  String cognoms;
  String email;


}