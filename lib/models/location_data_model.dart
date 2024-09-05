class LocationData {
  double? latitude;
  double? longitude;
  DateTime? time;

  LocationData({this.latitude, this.longitude, this.time});

  @override
  String toString() {
    return 'LocationData(latitude: $latitude, longitude: $longitude, time: ${time?.toIso8601String()})';
  }
}
