import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Utility class for managing SharedPreferences
class LocalStorage {
  static Future<SharedPreferences> _getPrefs() async {
    return SharedPreferences.getInstance();
  }

  // Save a String value
  static Future<void> saveString(String key, String value) async {
    final prefs = await _getPrefs();
    await prefs.setString(key, value);
  }

  // Get a String value
  static Future<String?> getString(String key) async {
    final prefs = await _getPrefs();
    return prefs.getString(key);
  }

  // Save a List of Strings
  static Future<void> saveStringList(String key, List<String> value) async {
    final prefs = await _getPrefs();
    await prefs.setStringList(key, value);
  }

  // Get a List of Strings
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _getPrefs();
    return prefs.getStringList(key);
  }

  // Save a Map<String, dynamic> as JSON string
  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    final prefs = await _getPrefs();
    final jsonString = json.encode(value);
    await prefs.setString(key, jsonString);
  }

  // Get a Map<String, dynamic> from JSON string
  static Future<Map<String, dynamic>?> getMap(String key) async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  // Save a complete model class
  static Future<void> saveModel<T>(
      String key, T model, Map<String, dynamic> Function(T) toJson) async {
    final prefs = await _getPrefs();
    final jsonString = json.encode(toJson(model));
    await prefs.setString(key, jsonString);
  }

  // Get a complete model class
  static Future<T?> getModel<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    }
    return null;
  }
}

void saveAndRetrieveData() async {
  // Save and get a string
  await LocalStorage.saveString('example_key', 'example_value');
  String? retrievedString = await LocalStorage.getString('example_key');
  debugPrint('Retrieved String: $retrievedString');

  // Save and get a list of strings
  await LocalStorage.saveStringList('example_list', ['a', 'b', 'c']);
  List<String>? retrievedList =
      await LocalStorage.getStringList('example_list');
  debugPrint('Retrieved List: $retrievedList');
}

Map<String, dynamic> makeJsonSafe(Map<String, dynamic> data) {
  return data.map((key, value) {
    if (value is DateTime) {
      return MapEntry(key, value.toIso8601String());
    } else if (value is Timestamp) {
      return MapEntry(key, value.toDate().toIso8601String());
    } else if (value is GeoPoint) {
      return MapEntry(key, {'lat': value.latitude, 'lng': value.longitude});
    } else if (value is Map) {
      return MapEntry(key, makeJsonSafe(Map<String, dynamic>.from(value)));
    } else {
      return MapEntry(key, value);
    }
  });
}
