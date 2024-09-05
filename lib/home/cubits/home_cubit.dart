// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'home_state.dart';

// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeState()) {
//     _startTracking();
//   }

//   void _startTracking() async {
//     try {
//       print("reached start tracking");

//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       print("Latitude: ${position.latitude}");

//       emit(HomeState(position: position));
//       print("emitted");
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void updatePosition(Position position) {
    emit(HomePostionChnage(position: position));
    print("emitted");
  }

  void updateLabel() async {
    emit(HomePostionChnage(label: "Hello"));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(HomePostionChnage(label: ""));
  }

  void updateLocation() async {
    try {
      print("reached start tracking");

      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      print("Latitude: ${position.latitude}");

      emit(HomePostionChnage(position: position));
      print("emitted");
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void resetLocation() {
    emit(HomePostionChnage(position: null));
  }

  Future<void> storeInSharedPreferencesStringList(String data, int maxLength) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('location_history');
    history ??= [];

    if (history.length >= maxLength) history.removeAt(0);

    history.add(data);
  }
}
