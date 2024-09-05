import 'package:flutter/widgets.dart';

@immutable
abstract class LocationHistoryState {}

class LocationHistoryInitials extends LocationHistoryState {}

class LocationHistoryDataLoaded extends LocationHistoryState {
  final List<String> locationHistory;

  LocationHistoryDataLoaded({required this.locationHistory});
}
