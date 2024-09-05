import 'package:flutter/material.dart';
import 'package:hello/home/cubits/location_history_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello/home/cubits/location_history_state.dart';
import 'package:hello/utils/helper_functions.dart';

class LocationHistory extends StatelessWidget {
  LocationHistory({super.key});
  List<String> locationHistoryData = [];

  @override
  Widget build(BuildContext context) {
    context.read<LocationHistoryCubit>().getLocationHistoryData();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Location History"),
      ),
      body: BlocBuilder<LocationHistoryCubit, LocationHistoryState>(
        builder: (context, state) {
          if (state is LocationHistoryDataLoaded) {
            locationHistoryData = state.locationHistory;

            return locationHistoryData.isNotEmpty
                ? ListView.builder(
                    itemCount: locationHistoryData.length,
                    itemBuilder: (context, index) {
                      String data = locationHistoryData[index];
                      return ListTile(
                        title: Text(getTimeSubstring(data)),
                        subtitle: Text(getLocationSubstring(data)),
                      );
                    },
                  )
                : const Center(
                    child: Text("No location history data"),
                  );
          } else {
            return const Center(
              child: Text("Could not load history data"),
            );
          }
        },
      ),
    );
  }
}
