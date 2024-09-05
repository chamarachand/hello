import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> requestLocationPermission() async {
    bool result = false;

    var status = await Permission.location.status;
    if (status.isGranted) {
      result = true;
    } else if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }
}
