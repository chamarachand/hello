import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello/home/cubits/location_history_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationHistoryCubit extends Cubit<LocationHistoryState> {
  LocationHistoryCubit() : super(LocationHistoryInitials());

  Future<List<String>> getLocationHistoryData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? history = prefs.getStringList('location_history');

    List<String> data = (history == null) ? [] : history;
    debugPrint(data.toString());

    emit(LocationHistoryDataLoaded(locationHistory: data));
    return data;
  }
}
