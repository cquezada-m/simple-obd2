import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/obd2_provider.dart';
import '../screens/chat_ai_screen.dart';
import '../screens/draggy_screen.dart';
import '../screens/drive_session_screen.dart';
import '../screens/emissions_check_screen.dart';
import '../screens/mileage_check_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/log_viewer_screen.dart';
import '../screens/sensor_explorer_screen.dart';
import '../services/pdf_report_service.dart';
import '../theme/app_theme.dart';
import '../widgets/connection_card.dart';
import '../widgets/vehicle_info_card.dart';
import '../widgets/diagnostic_codes_card.dart';
import '../widgets/live_parameters_card.dart';
import '../widgets/radial_gauge_card.dart';
import '../widgets/recommendations_card.dart';
import '../widgets/device_picker_sheet.dart';
import '../widgets/emissions_check_card.dart';
import '../widgets/alert_banner.dart';

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
                            onConnect: () => _showDevicePicker(context),
                            onDisconnect: () => provider.disconnect(),
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
                                MaterialPageRoute(
                                  builder: (_) => const EmissionsCheckScreen(),
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
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogViewerScreen()),
            ),
            child: Semantics(
              label: 'Logs',
              button: true,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.purple.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.terminal_rounded,
                  size: 18,
                  color: AppTheme.purple,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            ),
            child: Semantics(
              label: AppLocalizations.of(context).privacyPolicyLink,
              button: true,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildFeatureTools(BuildContext context, Obd2Provider provider) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          child: Text(
            l.featuresTitle,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 88,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _featureTile(
                icon: Icons.timer_rounded,
                label: 'Draggy',
                color: AppTheme.purple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DraggyScreen()),
                ),
              ),
              _featureTile(
                icon: Icons.sensors_rounded,
                label: l.sensorExplorerTitle,
                color: AppTheme.cyan,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SensorExplorerScreen(),
                  ),
                ),
              ),
              _featureTile(
                icon: Icons.speed_rounded,
                label: l.mileageCheckTitle,
                color: AppTheme.warning,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MileageCheckScreen()),
                ),
              ),
              _featureTile(
                icon: Icons.route_rounded,
                label: l.driveSessionTitle,
                color: AppTheme.success,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DriveSessionScreen()),
                ),
              ),
              _featureTile(
                icon: Icons.chat_rounded,
                label: l.chatAiTitle,
                color: AppTheme.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatAiScreen()),
                ),
              ),
              _featureTile(
                icon: Icons.picture_as_pdf_rounded,
                label: l.featureExportPdf,
                color: AppTheme.error,
                onTap: () => _exportPdf(context, provider),
              ),
            ],
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
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
          ),
        ),
        SizedBox(
          height: _calculateTabHeight(provider),
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    DiagnosticCodesCard(
                      codes: provider.dtcCodes,
                      onClearCodes: () => provider.clearCodes(),
                      isClearing: provider.isClearing,
                    ),
                    AiRecommendationsCard(
                      recommendations: provider.getRecommendations(
                        locale: l.locale,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    RadialGaugeCard(
                      rpm: provider.liveParams[0],
                      speed: provider.liveParams[1],
                    ),
                    LiveParametersCard(parameters: provider.liveParams),
                    AiRecommendationsCard(
                      recommendations: provider.getRecommendations(
                        locale: l.locale,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculateTabHeight(Obd2Provider provider) {
    final locale = AppLocalizations.of(context).locale;
    final dtcHeight = provider.dtcCodes.isEmpty
        ? 250.0
        : (provider.dtcCodes.length * 100.0 + 120);
    final recHeight =
        provider.getRecommendations(locale: locale).length * 280.0 + 160;
    final liveHeight = 640.0; // gauges (~220) + remaining params + padding
    final diagTab = dtcHeight + recHeight;
    final liveTab = liveHeight + recHeight;
    return (diagTab > liveTab ? diagTab : liveTab) + 40;
  }

  Widget _buildDisconnectedState() {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              size: 40,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.connectObd2,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
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
