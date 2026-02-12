import 'package:flutter/foundation.dart';
import '../models/alert_config.dart';
import '../models/drag_run.dart';
import '../models/drive_session.dart';
import '../models/mileage_check.dart';
import '../models/vehicle_profile.dart';
import '../services/local_storage_service.dart';

/// Manages persisted history: vehicle profiles, drive sessions,
/// drag runs, alert configs, and mileage checks.
class HistoryProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService.instance;

  List<VehicleProfile> _profiles = [];
  List<DriveSession> _sessions = [];
  List<DragRun> _dragRuns = [];
  List<AlertConfig> _alertConfigs = [];
  List<MileageCheck> _mileageChecks = [];
  String? _activeProfileId;

  List<VehicleProfile> get profiles => _profiles;
  List<DriveSession> get sessions => _sessions;
  List<DragRun> get dragRuns => _dragRuns;
  List<AlertConfig> get alertConfigs => _alertConfigs;
  List<MileageCheck> get mileageChecks => _mileageChecks;
  String? get activeProfileId => _activeProfileId;

  VehicleProfile? get activeProfile {
    if (_activeProfileId == null) return null;
    try {
      return _profiles.firstWhere((p) => p.id == _activeProfileId);
    } catch (_) {
      return null;
    }
  }

  /// Load all data from Hive. Call once at startup.
  void loadAll() {
    _profiles = _storage.getProfiles();
    _sessions = _storage.getSessions();
    _dragRuns = _storage.getDragRuns();
    _alertConfigs = _storage.getAlertConfigs();
    _mileageChecks = _storage.getMileageChecks();
    _activeProfileId = _storage.activeProfileId;
    notifyListeners();
  }

  // ── Vehicle Profiles ──

  Future<void> addProfile(VehicleProfile profile) async {
    await _storage.saveProfile(profile);
    _profiles = _storage.getProfiles();
    notifyListeners();
  }

  Future<void> updateProfile(VehicleProfile profile) async {
    await _storage.saveProfile(profile);
    _profiles = _storage.getProfiles();
    notifyListeners();
  }

  Future<void> deleteProfile(String id) async {
    await _storage.deleteProfile(id);
    if (_activeProfileId == id) {
      _activeProfileId = null;
      await _storage.setActiveProfileId(null);
    }
    _profiles = _storage.getProfiles();
    notifyListeners();
  }

  Future<void> setActiveProfile(String? id) async {
    _activeProfileId = id;
    await _storage.setActiveProfileId(id);
    notifyListeners();
  }

  // ── Drive Sessions ──

  Future<void> saveSession(DriveSession session) async {
    await _storage.saveSession(session);
    _sessions = _storage.getSessions();
    notifyListeners();
  }

  Future<void> deleteSession(String id) async {
    await _storage.deleteSession(id);
    _sessions = _storage.getSessions();
    notifyListeners();
  }

  // ── Drag Runs ──

  Future<void> saveDragRun(DragRun run) async {
    await _storage.saveDragRun(run);
    _dragRuns = _storage.getDragRuns();
    notifyListeners();
  }

  Future<void> deleteDragRun(String id) async {
    await _storage.deleteDragRun(id);
    _dragRuns = _storage.getDragRuns();
    notifyListeners();
  }

  /// Best time for a given config name.
  DragRun? bestRun(String configName) {
    final matching = _dragRuns.where((r) => r.config.name == configName);
    if (matching.isEmpty) return null;
    return matching.reduce((a, b) => a.totalTime < b.totalTime ? a : b);
  }

  // ── Alert Configs ──

  Future<void> saveAlertConfig(AlertConfig config) async {
    await _storage.saveAlertConfig(config);
    _alertConfigs = _storage.getAlertConfigs();
    notifyListeners();
  }

  Future<void> deleteAlertConfig(String parameterKey) async {
    await _storage.deleteAlertConfig(parameterKey);
    _alertConfigs = _storage.getAlertConfigs();
    notifyListeners();
  }

  // ── Mileage Checks ──

  Future<void> saveMileageCheck(MileageCheck check) async {
    await _storage.saveMileageCheck(check);
    _mileageChecks = _storage.getMileageChecks();
    notifyListeners();
  }
}
