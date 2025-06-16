// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../models/user_location_model.dart';
//
// class UserLocationHelper {
//   static Future<void> saveUserLocation(UserLocation userLocation) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('userLocation', json.encode(userLocation.toJson()));
//   }
//
//   static Future<UserLocation?> getUserLocation() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonString = prefs.getString('userLocation');
//
//     if (jsonString != null) {
//       final Map<String, dynamic> json = jsonDecode(jsonString);
//       return UserLocation.fromJson(json);
//     }
//
//     return null;
//   }
// }
