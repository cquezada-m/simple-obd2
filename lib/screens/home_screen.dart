import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/obd2_provider.dart';
import '../providers/subscription_provider.dart';
import '../screens/alert_settings_screen.dart';
import '../screens/chat_ai_screen.dart';
import '../screens/draggy_screen.dart';
import '../screens/drive_session_screen.dart';
import '../screens/emissions_check_screen.dart';
import '../screens/history_screen.dart';
import '../screens/mileage_check_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/log_viewer_screen.dart';
import '../screens/sensor_explorer_screen.dart';
import '../screens/vehicle_profiles_screen.dart';
import '../services/pdf_report_service.dart';
import '../theme/app_theme.dart';
import '../theme/page_transitions.dart';
import '../widgets/connection_card.dart';
import '../widgets/vehicle_info_card.dart';
import '../widgets/diagnostic_codes_card.dart';
import '../widgets/live_parameters_card.dart';
import '../widgets/radial_gauge_card.dart';
import '../widgets/recommendations_card.dart';
import '../widgets/device_picker_sheet.dart';
import '../widgets/emissions_check_card.dart';
import '../widgets/alert_banner.dart';
import '../widgets/paywall_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDevicePicker(BuildContext context) async {
    final provider = context.read<Obd2Provider>();
    final l = AppLocalizations.of(context);

    // Request runtime permissions before attempting connection
    final permissionsGranted = await _requestPermissions(context);
    if (!permissionsGranted) {
      if (!context.mounted) return;
      _showPermissionDeniedDialog(context, l);
      return;
    }

    if (!context.mounted) return;

    if (!provider.isIOS) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(strokeWidth: 2.5),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context).searchingDevices),
            ],
          ),
        ),
      );

      await provider.scanDevices();
      if (!context.mounted) return;
      Navigator.pop(context);
      if (!context.mounted) return;
    }

    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DevicePickerSheet(
        devices: provider.pairedDevices,
        isIOS: provider.isIOS,
        onDeviceSelected: (device) => provider.connectBluetooth(device),
        onWifiConnect: (host, port) =>
            provider.connectWifi(host: host, port: port),
        onUseMock: () => provider.connectMock(),
      ),
    );
  }

  /// Requests Bluetooth and Location permissions at runtime.
  /// Returns true if all required permissions are granted.
  Future<bool> _requestPermissions(BuildContext context) async {
    final provider = context.read<Obd2Provider>();

    if (provider.isIOS) {
      // iOS: Bluetooth permission is handled by the system dialog via Info.plist
      // We only need to check if Bluetooth is available
      return true;
    }

    // Android: Request Bluetooth + Location permissions
    final statuses = await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
    ].request();

    final allGranted = statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );

    return allGranted;
  }

  void _showPermissionDeniedDialog(BuildContext context, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l.permissionsRequired,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          l.permissionsDeniedMsg,
          style: GoogleFonts.inter(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.disconnect),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: Text(l.permissionsOpenSettings),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDisconnect(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l.disconnectConfirmTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: Text(
          l.disconnectConfirmMsg,
          style: GoogleFonts.inter(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.disconnect),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<Obd2Provider>().disconnect();
    }
  }

  void _clearCodesWithFeedback(BuildContext context) async {
    final provider = context.read<Obd2Provider>();
    await provider.clearCodes();
    if (!context.mounted) return;
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.codesCleared),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8F0FE), Color(0xFFF8F9FE), Color(0xFFF3E8FD)],
            ),
          ),
          child: SafeArea(
            child: Consumer<Obd2Provider>(
              builder: (context, provider, _) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildAppBar()),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          ConnectionCard(
                            isConnected: provider.isConnected,
                            isConnecting: provider.isConnecting,
                            connectionMode: provider.useMockData
                                ? 'mock'
                                : provider.activeMode?.name,
                            onConnect: () => _showDevicePicker(context),
                            onDisconnect: () => _confirmDisconnect(context),
                          ),
                          if (provider.isConnected) ...[
                            ...provider.activeAlerts.map(
                              (alert) => AlertBanner(
                                alert: alert,
                                onDismiss: () =>
                                    provider.dismissAlert(alert.config),
                              ),
                            ),
                            VehicleInfoCard(
                              vin: provider.vin,
                              protocol: provider.protocol,
                              ecuCount: provider.ecuCount,
                              vehicleInfo: provider.vehicleInfo,
                            ),
                            EmissionsCheckCard(
                              passes: provider.dtcCodes.isEmpty,
                              dtcCount: provider.dtcCodes.length,
                              onTap: () => Navigator.push(
                                context,
                                SlideFadeRoute(
                                  page: const EmissionsCheckScreen(),
                                ),
                              ),
                            ),
                            _buildFeatureTools(context, provider),
                            _buildTabs(provider),
                          ] else if (!provider.isConnecting) ...[
                            if (provider.connectionError != null)
                              _buildErrorBanner(provider.connectionError!),
                            _buildDisconnectedState(),
                          ],
                          const SizedBox(height: 24),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              size: 22,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.appTitle,
                  style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  l.appSubtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildLanguageToggle(),
          const SizedBox(width: 8),
          _buildProBadge(),
          const SizedBox(width: 8),
          _buildAppBarMenu(l),
        ],
      ),
    );
  }

  Widget _buildAppBarMenu(AppLocalizations l) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.textTertiary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.more_vert_rounded,
          size: 18,
          color: AppTheme.textSecondary,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      offset: const Offset(0, 44),
      onSelected: (value) {
        switch (value) {
          case 'profiles':
            Navigator.push(
              context,
              SlideFadeRoute(page: const VehicleProfilesScreen()),
            );
          case 'alerts':
            Navigator.push(
              context,
              SlideFadeRoute(page: const AlertSettingsScreen()),
            );
          case 'history':
            if (context.read<SubscriptionProvider>().isPro) {
              Navigator.push(
                context,
                SlideFadeRoute(page: const HistoryScreen()),
              );
            } else {
              showPaywall(context);
            }
          case 'logs':
            Navigator.push(
              context,
              SlideFadeRoute(page: const LogViewerScreen()),
            );
          case 'privacy':
            Navigator.push(
              context,
              SlideFadeRoute(page: const PrivacyPolicyScreen()),
            );
          case 'debug_pro':
            context.read<SubscriptionProvider>().debugTogglePro();
        }
      },
      itemBuilder: (_) {
        final sub = context.read<SubscriptionProvider>();
        return [
          PopupMenuItem(
            value: 'profiles',
            child: Row(
              children: [
                const Icon(
                  Icons.directions_car_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 10),
                Text(l.profilesTitle, style: GoogleFonts.inter(fontSize: 13)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'alerts',
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active_rounded,
                  size: 18,
                  color: AppTheme.warning,
                ),
                const SizedBox(width: 10),
                Text(
                  l.alertSettingsTitle,
                  style: GoogleFonts.inter(fontSize: 13),
                ),
                if (!sub.isPro) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'PRO',
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.purple,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuItem(
            value: 'history',
            child: Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: AppTheme.success,
                ),
                const SizedBox(width: 10),
                Text(l.historyTitle, style: GoogleFonts.inter(fontSize: 13)),
                if (!sub.isPro) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'PRO',
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.purple,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuItem(
            value: 'logs',
            child: Row(
              children: [
                const Icon(
                  Icons.terminal_rounded,
                  size: 18,
                  color: AppTheme.purple,
                ),
                const SizedBox(width: 10),
                Text(l.logsTitle, style: GoogleFonts.inter(fontSize: 13)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'privacy',
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  l.privacyPolicyTitle,
                  style: GoogleFonts.inter(fontSize: 13),
                ),
              ],
            ),
          ),
          // Debug: toggle PRO (remove before release)
          PopupMenuItem(
            value: 'debug_pro',
            child: Row(
              children: [
                Icon(
                  sub.isPro
                      ? Icons.toggle_on_rounded
                      : Icons.toggle_off_rounded,
                  size: 18,
                  color: sub.isPro ? AppTheme.success : AppTheme.textTertiary,
                ),
                const SizedBox(width: 10),
                Text(
                  sub.isPro ? 'Debug: PRO ON' : 'Debug: PRO OFF',
                  style: GoogleFonts.inter(fontSize: 13),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget _buildLanguageToggle() {
    final langProvider = context.watch<LanguageProvider>();
    final l = AppLocalizations.of(context);
    return Semantics(
      label: l.languageLabel,
      button: true,
      child: GestureDetector(
        onTap: () => langProvider.toggleLanguage(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.language_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                langProvider.locale.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProBadge() {
    final sub = context.watch<SubscriptionProvider>();
    if (sub.isPro) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.purple.withValues(alpha: 0.15),
              AppTheme.primary.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'PRO',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.purple,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () => showPaywall(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.purple.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              size: 16,
              color: AppTheme.purple,
            ),
            const SizedBox(width: 4),
            Text(
              'PRO',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTools(BuildContext context, Obd2Provider provider) {
    final l = AppLocalizations.of(context);
    final isPro = context.watch<SubscriptionProvider>().isPro;

    void gatedNav(Widget page) {
      if (isPro) {
        Navigator.push(context, SlideFadeRoute(page: page));
      } else {
        showPaywall(context);
      }
    }

    final tools = [
      _FeatureItem(
        Icons.timer_rounded,
        'Draggy',
        AppTheme.purple,
        () =>
            Navigator.push(context, SlideFadeRoute(page: const DraggyScreen())),
        false,
      ),
      _FeatureItem(
        Icons.sensors_rounded,
        l.sensorExplorerTitle,
        AppTheme.cyan,
        () => gatedNav(const SensorExplorerScreen()),
        !isPro,
      ),
      _FeatureItem(
        Icons.speed_rounded,
        l.mileageCheckTitle,
        AppTheme.warning,
        () => Navigator.push(
          context,
          SlideFadeRoute(page: const MileageCheckScreen()),
        ),
        false,
      ),
      _FeatureItem(
        Icons.route_rounded,
        l.driveSessionTitle,
        AppTheme.success,
        () => gatedNav(const DriveSessionScreen()),
        !isPro,
      ),
      _FeatureItem(
        Icons.chat_rounded,
        l.chatAiTitle,
        AppTheme.primary,
        () => gatedNav(const ChatAiScreen()),
        !isPro,
      ),
      _FeatureItem(
        Icons.picture_as_pdf_rounded,
        l.featureExportPdf,
        AppTheme.error,
        () {
          if (isPro) {
            _exportPdf(context, provider);
          } else {
            showPaywall(context);
          }
        },
        !isPro,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          child: Row(
            children: [
              Text(
                l.featuresTitle,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.swipe_rounded,
                size: 14,
                color: AppTheme.textTertiary.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                l.swipeHint,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 92,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final t = tools[index];
              return _featureTile(
                icon: t.icon,
                label: t.label,
                color: t.color,
                onTap: t.onTap,
                locked: t.locked,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _featureTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool locked = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Semantics(
        label: label,
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: color.withValues(alpha: 0.15),
            highlightColor: color.withValues(alpha: 0.08),
            child: Ink(
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(icon, size: 26, color: color),
                      if (locked)
                        Positioned(
                          right: -6,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppTheme.purple,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.lock,
                              size: 8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exportPdf(BuildContext context, Obd2Provider provider) async {
    final l = AppLocalizations.of(context);
    try {
      final file = await PdfReportService.generateReport(
        vin: provider.vin,
        protocol: provider.protocol,
        ecuCount: provider.ecuCount,
        parameters: provider.liveParams,
        dtcCodes: provider.dtcCodes,
        aiDiagnostic: provider.aiDiagnostic,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.pdfExported}: ${file.path}'),
          backgroundColor: AppTheme.success,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.pdfError}: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  Widget _buildTabs(Obd2Provider provider) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppTheme.textPrimary,
            unselectedLabelColor: AppTheme.textTertiary,
            labelStyle: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 16),
                    const SizedBox(width: 6),
                    Text(l.diagnosticTab),
                    if (provider.dtcCodes.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${provider.dtcCodes.length}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.show_chart_rounded, size: 16),
                    const SizedBox(width: 6),
                    Text(l.liveTab),
                  ],
                ),
              ),
            ],
            onTap: (_) => setState(() {}),
          ),
        ),
        // Render only the active tab content inline (no fixed height)
        IndexedStack(
          index: _tabController.index,
          children: [
            Column(
              children: [
                DiagnosticCodesCard(
                  codes: provider.dtcCodes,
                  onClearCodes: () => _clearCodesWithFeedback(context),
                  isClearing: provider.isClearing,
                ),
                AiRecommendationsCard(
                  recommendations: provider.getRecommendations(
                    locale: l.locale,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                RadialGaugeCard(
                  rpm: provider.liveParams[0],
                  speed: provider.liveParams[1],
                ),
                LiveParametersCard(parameters: provider.liveParams),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDisconnectedState() {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cable_rounded,
              size: 42,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.connectObd2,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              l.connectObd2Hint,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showDevicePicker(context),
            icon: const Icon(Icons.bluetooth_searching_rounded, size: 18),
            label: Text(
              l.connect,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 18,
              color: AppTheme.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool locked;
  const _FeatureItem(
    this.icon,
    this.label,
    this.color,
    this.onTap,
    this.locked,
  );
}
