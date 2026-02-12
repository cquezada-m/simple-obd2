/// Wrapper around RevenueCat (purchases_flutter) for in-app purchases.
///
/// Until `purchases_flutter` is integrated, this provides a stub
/// implementation so the rest of the subscription system can be built
/// and tested. Replace the body of each method once RevenueCat is
/// configured in the App Store / Google Play dashboards.
class PurchaseService {
  PurchaseService._();

  /// Initialise RevenueCat SDK. Call once at app startup.
  static Future<void> init() async {
    // TODO: Purchases.configure(PurchasesConfiguration('<REVENUECAT_API_KEY>'));
  }

  /// Whether the current user has an active "pro" entitlement.
  static Future<bool> isPro() async {
    // TODO: final info = await Purchases.getCustomerInfo();
    // return info.entitlements.active.containsKey('pro');
    return false;
  }

  /// Fetch available offerings (monthly, annual, lifetime).
  static Future<List<ProPackage>> getOfferings() async {
    // TODO: return real packages from Purchases.getOfferings()
    return const [
      ProPackage(id: 'pro_monthly', label: 'Mensual', price: '\$4.99 USD'),
      ProPackage(id: 'pro_annual', label: 'Anual', price: '\$29.99 USD'),
      ProPackage(id: 'pro_lifetime', label: 'Lifetime', price: '\$49.99 USD'),
    ];
  }

  /// Purchase a specific package. Returns true on success.
  static Future<bool> purchase(String packageId) async {
    // TODO: Purchases.purchasePackage(package)
    return false;
  }

  /// Restore previous purchases. Returns true if PRO was restored.
  static Future<bool> restore() async {
    // TODO: Purchases.restorePurchases()
    return false;
  }
}

/// Placeholder until RevenueCat types are available.
class ProPackage {
  final String id;
  final String label;
  final String price;
  const ProPackage({
    required this.id,
    required this.label,
    required this.price,
  });
}
