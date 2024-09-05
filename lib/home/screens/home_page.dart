// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../utils/permission_handler.dart';
// import '../home_cubit/home_cubit.dart';
// import '../home_cubit/home_state.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double? lat;
//     double? long;

//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Location Tracker"),
//         ),
//         body: BlocListener<HomeCubit, HomeState>(
//             listener: (context, state) {
//               PermissionHandler.requestLocationPermission();

//               if (state is HomePostionChnage) {
//                 lat = state.position?.latitude;
//                 long = state.position?.longitude;

//                 print("home screen emitted");
//               }
//             },
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Latitude: ${lat ?? 0}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Text("Longitude:  ${long ?? 0}",
//                       style: const TextStyle(fontSize: 16))
//                 ],
//               ),
//             )));
//     // return Text(
//     //     "Latitude: ${state.position?.latitude} Longitude : ${state.position?.longitude}")
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello/home/cubits/location_history_cubit.dart';
import 'package:hello/home/screens/location_history.dart';

import '../../utils/Noti.dart';
import '../../utils/permission_handler.dart';
import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.fln});
  final fln;

  @override
  Widget build(BuildContext context) {
    double? lat;
    double? long;
    String? text;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Location Tracker"),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            PermissionHandler.requestLocationPermission();

            if (state is HomePostionChnage) {
              lat = state.position?.latitude;
              long = state.position?.longitude;
              text = state.label;

              print("home screen emitted");
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Latitude: ${lat ?? 0}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text("Longitude:  ${long ?? 0}", style: const TextStyle(fontSize: 16)),
                  ElevatedButton(
                      onPressed: () {
                        Noti.showNotification(title: "Test", body: "Test body", fln: fln);
                      },
                      child: const Text("Show Notification")),
                  ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().updateLocation();
                      },
                      child: const Text("Update Location")),
                  ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().resetLocation();
                      },
                      child: const Text("Reset")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => LocationHistoryCubit(),
                              child: LocationHistory(),
                            ),
                          ),
                        );
                      },
                      child: const Text("Show Location History")),
                  Text(text ?? "")
                ],
              ),
            );
          },
        ));
    // return Text(
    //     "Latitude: ${state.position?.latitude} Longitude : ${state.position?.longitude}")
  }
}
