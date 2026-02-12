import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/pid_catalog.dart';
import '../l10n/app_localizations.dart';
import '../models/obd2_pid.dart';
import '../providers/obd2_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _availablePids = PidCatalog.all;
    _initReadings();
    // Generate mock data if in demo mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<Obd2Provider>();
      if (provider.useMockData) {
        _generateMockReadings();
      }
    });
  }

  void _initReadings() {
    for (final pid in _availablePids) {
      _readings[pid.pid] = PidReading(definition: pid);
    }
  }

  void _generateMockReadings() {
    final rng = Random();
    for (final pid in _availablePids) {
      final base = pid.normalMax ?? 100.0;
      final reading = PidReading(definition: pid);
      // Fill 30 history points
      for (var i = 0; i < 30; i++) {
        reading.addValue((base * 0.2) + rng.nextDouble() * (base * 0.6));
      }
      _readings[pid.pid] = reading;
    }
    setState(() {});
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
        child: SafeArea(
          child: Column(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  '${_filteredPids.length} ${l.sensorAvailable}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
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
          ),
        ),
      ),
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
