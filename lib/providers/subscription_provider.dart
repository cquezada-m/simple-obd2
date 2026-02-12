import 'package:flutter/foundation.dart';
import '../models/subscription.dart';
import '../services/purchase_service.dart';

/// Manages the user's subscription state (FREE / PRO).
///
/// Registered in [MultiProvider] at app startup. Widgets read [isPro] via
/// `context.watch<SubscriptionProvider>().isPro` or use
/// `Consumer<SubscriptionProvider>` to gate PRO features.
class SubscriptionProvider extends ChangeNotifier {
  SubscriptionTier _tier = SubscriptionTier.free;
  bool _loading = false;
  int _clearDtcCount = 0; // times DTCs cleared this session

  SubscriptionTier get tier => _tier;
  bool get isPro => _tier == SubscriptionTier.pro;
  bool get isLoading => _loading;

  /// FREE users can clear DTCs once per session.
  bool get canClearDtcs => isPro || _clearDtcCount < 1;

  /// Record a DTC clear action (called after successful clear).
  void recordDtcClear() {
    _clearDtcCount++;
    notifyListeners();
  }

  /// Maximum visible DTCs for FREE tier.
  static const int freeDtcLimit = 3;

  /// Initialise from RevenueCat cached state.
  Future<void> init() async {
    _loading = true;
    notifyListeners();
    try {
      await PurchaseService.init();
      final pro = await PurchaseService.isPro();
      _tier = pro ? SubscriptionTier.pro : SubscriptionTier.free;
    } catch (e) {
      debugPrint('SubscriptionProvider.init error: $e');
      _tier = SubscriptionTier.free;
    }
    _loading = false;
    notifyListeners();
  }

  /// Purchase a package by id. Returns true on success.
  Future<bool> purchase(String packageId) async {
    _loading = true;
    notifyListeners();
    try {
      final success = await PurchaseService.purchase(packageId);
      if (success) _tier = SubscriptionTier.pro;
      return success;
    } catch (e) {
      debugPrint('Purchase error: $e');
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Restore previous purchases.
  Future<bool> restore() async {
    _loading = true;
    notifyListeners();
    try {
      final restored = await PurchaseService.restore();
      if (restored) _tier = SubscriptionTier.pro;
      return restored;
    } catch (e) {
      debugPrint('Restore error: $e');
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Debug helpers (remove before release) ──

  /// Toggle PRO for development/testing.
  void debugTogglePro() {
    _tier = isPro ? SubscriptionTier.free : SubscriptionTier.pro;
    notifyListeners();
  }
}
