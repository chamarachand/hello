import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hello/models/location_data_model.dart';
import 'package:hello/utils/Noti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

LocationSettings getPlatformSpecificLocationSettings() {
  if (Platform.isAndroid) {
    return AndroidSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
      intervalDuration: const Duration(minutes: 5, seconds: 30),
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
            "Example app will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
      ),
    );
  } else if (Platform.isIOS || Platform.isMacOS) {
    return AppleSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
      activityType: ActivityType.automotiveNavigation,
      allowBackgroundLocationUpdates: true,
      pauseLocationUpdatesAutomatically: false,
      showBackgroundLocationIndicator: false,
    );
  } else {
    return const LocationSettings(
        accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 15));
  }
}

Future<bool> needToRequestAlwaysPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  return permission != LocationPermission.always;
}

Future<void> storeInSharedPreferencesStringList(String data, int maxLength) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? history = prefs.getStringList('location_history');
  history ??= [];

  if (history.length >= maxLength) history.removeAt(0);

  history.add(data);

  await prefs.setStringList('location_history', history);
  debugPrint("Saved to shared prefs: $history");
}

Future<void> trackLocationInBackground(
    LocationSettings myLocationSettings, FlutterLocalNotificationsPlugin fln) async {
  try {
    print("Reach 1");
    Position? position;
    bool gotCurrentPosition = false;
    int repeatedCount = 0;

    while (!gotCurrentPosition && repeatedCount <= 10) {
      try {
        position = await Geolocator.getCurrentPosition(locationSettings: myLocationSettings);
        gotCurrentPosition = true;
      } catch (e) {
        print("Timed Out");
        repeatedCount++;
      }
    }
    print("Reach 2");
    print(
        "Updated Latitude: ${position?.latitude}, Longitude: ${position?.longitude}, time: ${DateTime.now()}");

    LocationData data = LocationData(
        latitude: position?.latitude, longitude: position?.longitude, time: DateTime.now());
    // save details to shared preferences
    await storeInSharedPreferencesStringList(data.toString(), 100);

    Noti.showNotification(
        title: "Location updated",
        body: "Latitude: ${position?.latitude}, Longitude: ${position?.longitude}",
        fln: fln);
  } catch (e) {
    print('Error getting location: $e');
  }
}

String getTimeSubstring(String input) {
  try {
    List<String> parts = input.split('time: ');
    if (parts.length > 1) {
      return parts[1];
    } else {
      return 'No date';
    }
  } catch (e) {
    return 'No date';
  }
}

String getLocationSubstring(String input) {
  try {
    List<String> parts = input.split('time: ');
    if (parts.length > 1) {
      return parts[0].trim();
    } else {
      return 'No location data';
    }
  } catch (e) {
    return 'No location data';
  }
}
