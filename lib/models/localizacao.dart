class Localizacao {
  final double latitude;
  final double longitude;

  Localizacao({required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
