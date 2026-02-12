import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/pid_catalog.dart';
import '../l10n/app_localizations.dart';
import '../models/obd2_pid.dart';
import '../providers/obd2_provider.dart';
import '../services/obd2_base_service.dart';
import '../theme/app_theme.dart';
import '../widgets/sensor_tile.dart';
import 'sensor_detail_screen.dart';

class SensorExplorerScreen extends StatefulWidget {
  const SensorExplorerScreen({super.key});

  @override
  State<SensorExplorerScreen> createState() => _SensorExplorerScreenState();
}

class _SensorExplorerScreenState extends State<SensorExplorerScreen> {
  PidCategory? _selectedCategory;
  String _searchQuery = '';
  final Map<String, PidReading> _readings = {};
  List<Obd2Pid> _availablePids = [];
  Timer? _pollTimer;
  bool _isPolling = false;
  bool _isDiscovering = false;
  bool _discoveryFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  void _init() {
    final provider = context.read<Obd2Provider>();
    if (provider.useMockData) {
      _availablePids = PidCatalog.all;
      _initReadings();
      _generateMockReadings();
      _startMockPolling();
    } else if (provider.isConnected) {
      _runDiscovery(provider);
    }
    // If not connected and not mock — _availablePids stays empty,
    // UI will show the "not connected" state.
    setState(() {});
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _runDiscovery(Obd2Provider provider) async {
    setState(() {
      _isDiscovering = true;
      _discoveryFailed = false;
    });

    final service = provider.activeService;
    if (service == null) {
      setState(() {
        _isDiscovering = false;
        _discoveryFailed = true;
      });
      return;
    }

    try {
      final supported = await Obd2BaseService.discoverSupportedPids(service);

      _availablePids = PidCatalog.all.where((pid) {
        final pidNum = int.tryParse(pid.pid.substring(2), radix: 16);
        return pidNum != null && supported.contains(pidNum);
      }).toList();

      _discoveryFailed = _availablePids.isEmpty;
    } catch (_) {
      _availablePids = [];
      _discoveryFailed = true;
    }

    _initReadings();
    if (mounted) {
      setState(() => _isDiscovering = false);
      if (_availablePids.isNotEmpty) {
        _startRealPolling(provider);
      }
    }
  }

  void _initReadings() {
    _readings.clear();
    for (final pid in _availablePids) {
      _readings[pid.pid] = PidReading(definition: pid);
    }
  }

  void _generateMockReadings() {
    final rng = Random();
    for (final pid in _availablePids) {
      final base = pid.normalMax ?? 100.0;
      final reading = PidReading(definition: pid);
      for (var i = 0; i < 30; i++) {
        reading.addValue((base * 0.2) + rng.nextDouble() * (base * 0.6));
      }
      _readings[pid.pid] = reading;
    }
  }

  void _startMockPolling() {
    final rng = Random();
    _pollTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      for (final pid in _availablePids) {
        final reading = _readings[pid.pid];
        if (reading == null) continue;
        final base = pid.normalMax ?? 100.0;
        final prev = reading.currentValue ?? (base * 0.5);
        final delta = (rng.nextDouble() - 0.5) * base * 0.05;
        final newVal = (prev + delta).clamp(
          0.0,
          (pid.warningMax ?? base) * 1.2,
        );
        reading.addValue(newVal);
      }
      setState(() {});
    });
  }

  void _startRealPolling(Obd2Provider provider) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) async {
      if (!mounted || _isPolling) return;
      if (!provider.isConnected || provider.useMockData) return;

      final service = provider.activeService;
      if (service == null) return;

      _isPolling = true;
      try {
        final pidsToQuery = _filteredPids.take(8).toList();
        for (final pid in pidsToQuery) {
          if (!mounted || !provider.isConnected) break;
          final bytes = await _queryPidRaw(service, pid.pid);
          if (bytes != null && bytes.length >= pid.dataBytes) {
            final value = pid.decode(bytes);
            _readings[pid.pid]?.addValue(value);
          }
        }
        if (mounted) setState(() {});
      } catch (_) {
        // Retry next cycle
      } finally {
        _isPolling = false;
      }
    });
  }

  Future<List<int>?> _queryPidRaw(Obd2BaseService service, String pid) async {
    final response = await service.sendRawCommand(pid);
    if (response == null || response.isEmpty) return null;
    final pidHex = pid.length >= 4 ? pid.substring(2) : pid;
    final header = '41$pidHex'.toUpperCase();
    return Obd2BaseService.extractResponseBytes(response, header);
  }

  List<Obd2Pid> get _filteredPids {
    var pids = _availablePids;
    if (_selectedCategory != null) {
      pids = pids.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      pids = pids
          .where(
            (p) =>
                p.nameEs.toLowerCase().contains(q) ||
                p.nameEn.toLowerCase().contains(q) ||
                p.pid.toLowerCase().contains(q),
          )
          .toList();
    }
    return pids;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final provider = context.watch<Obd2Provider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(l.sensorExplorerTitle)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F0FE), Color(0xFFF8F9FE), Color(0xFFF3E8FD)],
          ),
        ),
        child: SafeArea(child: _buildBody(l, provider)),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l, Obd2Provider provider) {
    // Discovering sensors
    if (_isDiscovering) return _buildDiscovering(l);

    // Not connected and not mock — nothing to show
    if (!provider.isConnected && !provider.useMockData) {
      return _buildCenterMessage(
        icon: Icons.bluetooth_disabled_rounded,
        message: l.sensorNotConnected,
      );
    }

    // Connected but discovery failed
    if (_discoveryFailed && !provider.useMockData) {
      return _buildDiscoveryError(l, provider);
    }

    return _buildSensorList(l, provider);
  }

  Widget _buildDiscovering(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(strokeWidth: 2.5),
          const SizedBox(height: 16),
          Text(
            l.sensorDiscovering,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryError(AppLocalizations l, Obd2Provider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sensors_off_rounded,
              size: 48,
              color: AppTheme.textTertiary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              l.sensorDiscoveryFailed,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _runDiscovery(provider),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l.sensorRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterMessage({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppTheme.textTertiary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorList(AppLocalizations l, Obd2Provider provider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: l.sensorSearch,
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        _buildCategoryChips(l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            provider.useMockData
                ? '${_filteredPids.length} ${l.sensorAvailable}'
                : '${_filteredPids.length} ${l.sensorDetected}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: _filteredPids.isEmpty
              ? Center(
                  child: Text(
                    l.sensorNoneFound,
                    style: GoogleFonts.inter(color: AppTheme.textTertiary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredPids.length,
                  itemBuilder: (context, index) {
                    final pid = _filteredPids[index];
                    final reading = _readings[pid.pid];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SensorDetailScreen(
                            reading: reading ?? PidReading(definition: pid),
                          ),
                        ),
                      ),
                      child: SensorTile(
                        pid: pid,
                        reading: reading,
                        locale: l.locale,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips(AppLocalizations l) {
    final categories = {
      null: l.logsFilterAll,
      PidCategory.engine: l.sensorCatEngine,
      PidCategory.fuel: l.sensorCatFuel,
      PidCategory.air: l.sensorCatAir,
      PidCategory.emissions: l.sensorCatEmissions,
      PidCategory.electrical: l.sensorCatElectrical,
      PidCategory.diagnostic: l.sensorCatDiagnostic,
    };

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: categories.entries.map((e) {
          final selected = _selectedCategory == e.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(e.value),
              selected: selected,
              onSelected: (_) => setState(() => _selectedCategory = e.key),
              selectedColor: AppTheme.primary.withValues(alpha: 0.15),
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
