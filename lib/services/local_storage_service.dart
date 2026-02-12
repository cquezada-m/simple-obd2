import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/alert_config.dart';
import '../models/drag_run.dart';
import '../models/drive_session.dart';
import '../models/mileage_check.dart';
import '../models/vehicle_profile.dart';

/// Hive-backed local persistence service.
///
/// Boxes store JSON-encoded maps keyed by entity id.
class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  static const String _vehicleProfilesBox = 'vehicle_profiles';
  static const String _driveSessionsBox = 'drive_sessions';
  static const String _dragRunsBox = 'drag_runs';
  static const String _alertConfigsBox = 'alert_configs';
  static const String _mileageChecksBox = 'mileage_checks';
  static const String _prefsBox = 'prefs';

  late Box<String> _profiles;
  late Box<String> _sessions;
  late Box<String> _runs;
  late Box<String> _alerts;
  late Box<String> _mileage;
  late Box<String> _prefs;

  /// Must be called once before runApp.
  static Future<void> init() async {
    await Hive.initFlutter();
    final s = instance;
    s._profiles = await Hive.openBox<String>(_vehicleProfilesBox);
    s._sessions = await Hive.openBox<String>(_driveSessionsBox);
    s._runs = await Hive.openBox<String>(_dragRunsBox);
    s._alerts = await Hive.openBox<String>(_alertConfigsBox);
    s._mileage = await Hive.openBox<String>(_mileageChecksBox);
    s._prefs = await Hive.openBox<String>(_prefsBox);
  }

  // ── Vehicle Profiles ──

  List<VehicleProfile> getProfiles() {
    return _profiles.values
        .map(
          (json) =>
              VehicleProfile.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveProfile(VehicleProfile profile) async {
    await _profiles.put(profile.id, jsonEncode(profile.toJson()));
  }

  Future<void> deleteProfile(String id) async {
    await _profiles.delete(id);
  }

  // ── Drive Sessions ──

  List<DriveSession> getSessions() {
    return _sessions.values
        .map(
          (json) =>
              DriveSession.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  Future<void> saveSession(DriveSession session) async {
    final id = session.id ?? session.startTime.toIso8601String();
    await _sessions.put(id, jsonEncode(session.toJson()));
  }

  Future<void> deleteSession(String id) async {
    await _sessions.delete(id);
  }

  // ── Drag Runs ──

  List<DragRun> getDragRuns() {
    return _runs.values
        .map(
          (json) => DragRun.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> saveDragRun(DragRun run) async {
    final id = run.id ?? run.timestamp.toIso8601String();
    await _runs.put(id, jsonEncode(run.toJson()));
  }

  Future<void> deleteDragRun(String id) async {
    await _runs.delete(id);
  }

  // ── Alert Configs ──

  List<AlertConfig> getAlertConfigs() {
    return _alerts.values
        .map(
          (json) =>
              AlertConfig.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> saveAlertConfig(AlertConfig config) async {
    await _alerts.put(config.parameterKey, jsonEncode(config.toJson()));
  }

  Future<void> deleteAlertConfig(String parameterKey) async {
    await _alerts.delete(parameterKey);
  }

  // ── Mileage Checks ──

  List<MileageCheck> getMileageChecks() {
    return _mileage.values
        .map(
          (json) =>
              MileageCheck.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> saveMileageCheck(MileageCheck check) async {
    final id = check.id ?? check.timestamp.toIso8601String();
    await _mileage.put(id, jsonEncode(check.toJson()));
  }

  // ── Preferences ──

  String? getPref(String key) => _prefs.get(key);

  Future<void> setPref(String key, String value) async {
    await _prefs.put(key, value);
  }

  /// Active vehicle profile id.
  String? get activeProfileId => getPref('activeProfileId');

  Future<void> setActiveProfileId(String? id) async {
    if (id == null) {
      await _prefs.delete('activeProfileId');
    } else {
      await setPref('activeProfileId', id);
    }
  }
}
