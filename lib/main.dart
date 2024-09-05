import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:hello/utils/helper_functions.dart';
// import 'package:background_location/background_location.dart';

import 'home/cubits/home_cubit.dart';
import 'home/screens/home_page.dart';
import 'utils/Noti.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final LocationSettings myLocationSettings = getPlatformSpecificLocationSettings();

// for geolocator
@pragma('vm:entry-point')
void updateLocation() async {
  print("reached update location");
  print(await Geolocator.isLocationServiceEnabled());

  await trackLocationInBackground(myLocationSettings, flutterLocalNotificationsPlugin);
}

// for ios
void configureBackgroundFetch() {
  BackgroundFetch.configure(
    BackgroundFetchConfig(
        minimumFetchInterval: 5, // minutes (min is 15)
        stopOnTerminate: false,
        enableHeadless: true,
        requiresCharging: false),
    (String taskId) async {
      print("[BackgroundFetch] taskId: $taskId");
      // Perform your background task here
      await trackLocationInBackground(myLocationSettings, flutterLocalNotificationsPlugin);

      BackgroundFetch.finish(taskId);
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) await AndroidAlarmManager.initialize();
  runApp(const MyApp());

  if (Platform.isAndroid) {
    const int helloAlarmID = 0;
    await AndroidAlarmManager.periodic(const Duration(minutes: 5), helloAlarmID, updateLocation);
  } else if (Platform.isIOS || Platform.isMacOS) {
    configureBackgroundFetch();
  }

  Noti.initialize(flutterLocalNotificationsPlugin);

  await Geolocator.requestPermission();
  if (await needToRequestAlwaysPermission()) await Geolocator.openLocationSettings();

  print("reached here");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => HomeCubit(),
          child: HomePage(fln: flutterLocalNotificationsPlugin),
        ));
  }
}
