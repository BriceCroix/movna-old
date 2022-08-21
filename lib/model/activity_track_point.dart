class ActivityTrackPoint{
  double latitude;
  double longitude;
  DateTime dateTime;
  double? altitudeInMeters;
  double? heartRateInBeatsPerMinute;

  ActivityTrackPoint({required this.latitude, required this.longitude, required this.dateTime, this.altitudeInMeters, this.heartRateInBeatsPerMinute});
}
