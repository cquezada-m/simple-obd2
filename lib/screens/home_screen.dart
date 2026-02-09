import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/obd2_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/connection_card.dart';
import '../widgets/vehicle_info_card.dart';
import '../widgets/diagnostic_codes_card.dart';
import '../widgets/live_parameters_card.dart';
import '../widgets/recommendations_card.dart';
import '../widgets/device_picker_sheet.dart';

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

    // En iOS no escaneamos Bluetooth, vamos directo al picker con WiFi
    if (!provider.isIOS) {
      // Mostrar loading mientras escanea BT
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          padding: const EdgeInsets.all(40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Buscando dispositivos...'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_car,
                size: 22,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OBD2 Scanner',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Diagnostico de Vehiculo',
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Consumer<Obd2Provider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ConnectionCard(
                  isConnected: provider.isConnected,
                  isConnecting: provider.isConnecting,
                  onConnect: () => _showDevicePicker(context),
                  onDisconnect: () => provider.disconnect(),
                ),
                if (provider.isConnected) ...[
                  VehicleInfoCard(
                    vin: provider.vin,
                    protocol: provider.protocol,
                    ecuCount: provider.ecuCount,
                  ),
                  _buildTabs(provider),
                ] else if (!provider.isConnecting) ...[
                  if (provider.connectionError != null)
                    _buildErrorBanner(provider.connectionError!),
                  _buildDisconnectedState(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(Obd2Provider provider) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.all(4),
            dividerColor: Colors.transparent,
            labelColor: AppTheme.textPrimary,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber, size: 16),
                    const SizedBox(width: 6),
                    const Text('Diagnostico'),
                    if (provider.dtcCodes.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${provider.dtcCodes.length}',
                          style: const TextStyle(
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
              const Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.show_chart, size: 16),
                    SizedBox(width: 6),
                    Text('En Vivo'),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          // Calcular altura necesaria para el contenido
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
                      recommendations: provider.getRecommendations(),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    LiveParametersCard(parameters: provider.liveParams),
                    AiRecommendationsCard(
                      recommendations: provider.getRecommendations(),
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
    // Estimación dinámica basada en contenido
    final dtcHeight = provider.dtcCodes.isEmpty
        ? 250.0
        : (provider.dtcCodes.length * 100.0 + 120);
    final recHeight = provider.getRecommendations().length * 280.0 + 160;
    final liveHeight = 420.0; // Grid de parámetros
    final diagTab = dtcHeight + recHeight;
    final liveTab = liveHeight + recHeight;
    return (diagTab > liveTab ? diagTab : liveTab) + 40;
  }

  Widget _buildDisconnectedState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car,
              size: 40,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Conecta tu dispositivo OBD2',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Conecta el escaner al puerto de diagnostico de tu vehiculo y presiona conectar',
              textAlign: TextAlign.center,
              style: TextStyle(
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.errorLight,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, size: 20, color: AppTheme.error),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                error,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
