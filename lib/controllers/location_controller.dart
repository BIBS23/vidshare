import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  double? latitude;
  double? longitude;

  String? lok  ;

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      lok = await getLocationName(latitude!.toDouble(), longitude!.toDouble());
   

      print(
          'Latitude 1111111111: $latitude, Longitude888888888888: $longitude');
      print('Location : $lok'); // Print the location here
    } catch (e) {
      print('Error: $e');
    }
       
  }

  Future<String?> getLocationName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String locationName =
            "${placemark.locality}, ${placemark.administrativeArea}";
        return locationName;
      } else {
        return null; // No location information found
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
