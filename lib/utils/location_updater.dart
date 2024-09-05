// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';

// import '../home/home_cubit/home_cubit.dart';

// @pragma('vm:entry-point')
// void updateLocation(BuildContext context) async {
//   print("reached update location 2");

//   try {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     print(
//         "Updated Latitude: ${position.latitude}, Longitude: ${position.longitude}");

//     context.read()<HomeCubit>().updateLocation();
//   } catch (e) {
//     print('Error getting location: $e');
//   }
// }
