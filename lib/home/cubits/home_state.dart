import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomePostionChnage extends HomeState {
  final Position? position;
  final String? label;

  HomePostionChnage({this.position, this.label});
}
