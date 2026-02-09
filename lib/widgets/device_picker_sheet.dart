import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/wifi_obd2_service.dart';
import '../theme/app_theme.dart';

class DevicePickerSheet extends StatefulWidget {
  final List<BluetoothDevice> devices;
  final bool isIOS;
  final ValueChanged<BluetoothDevice> onDeviceSelected;
  final void Function(String host, int port) onWifiConnect;
  final VoidCallback onUseMock;

  const DevicePickerSheet({
    super.key,
    required this.devices,
    required this.isIOS,
    required this.onDeviceSelected,
    required this.onWifiConnect,
    required this.onUseMock,
  });

  @override
  State<DevicePickerSheet> createState() => _DevicePickerSheetState();
}

class _DevicePickerSheetState extends State<DevicePickerSheet> {
  late bool _showWifi;
  final _hostController = TextEditingController(
    text: WifiObd2Service.defaultHost,
  );
  final _portController = TextEditingController(
    text: '${WifiObd2Service.defaultPort}',
  );

  @override
  void initState() {
    super.initState();
    _showWifi = widget.isIOS;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.textTertiary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Conectar Dispositivo',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isIOS
                      ? 'Conecta vía WiFi al adaptador OBD2'
                      : 'Selecciona el método de conexión',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                if (!widget.isIOS) ...[
                  _buildModeToggle(),
                  const SizedBox(height: 16),
                ],
                if (_showWifi)
                  _buildWifiSection()
                else
                  _buildBluetoothSection(),
                const SizedBox(height: 16),
                Divider(color: AppTheme.textTertiary.withValues(alpha: 0.15)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onUseMock();
                    },
                    icon: const Icon(Icons.science_outlined, size: 18),
                    label: Text(
                      'Usar datos de demostración',
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleButton(
              icon: Icons.bluetooth_rounded,
              label: 'Bluetooth',
              selected: !_showWifi,
              onTap: () => setState(() => _showWifi = false),
            ),
          ),
          Expanded(
            child: _toggleButton(
              icon: Icons.wifi_rounded,
              label: 'WiFi',
              selected: _showWifi,
              onTap: () => setState(() => _showWifi = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? AppTheme.primary : AppTheme.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? AppTheme.textPrimary : AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWifiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color: AppTheme.primary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cómo conectar vía WiFi',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _WifiStep(
                number: '1',
                text: 'Conecta el adaptador OBD2 al puerto del vehículo',
              ),
              const SizedBox(height: 6),
              _WifiStep(
                number: '2',
                text: 'Ve a Ajustes > WiFi en tu dispositivo',
              ),
              const SizedBox(height: 6),
              _WifiStep(number: '3', text: 'Conéctate a la red del adaptador'),
              const SizedBox(height: 6),
              _WifiStep(number: '4', text: 'Regresa aquí y presiona Conectar'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Dirección IP',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _hostController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            hintText: '192.168.0.10',
            hintStyle: GoogleFonts.inter(color: AppTheme.textTertiary),
            prefixIcon: const Icon(Icons.router_outlined, size: 20),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Puerto',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _portController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            hintText: '35000',
            hintStyle: GoogleFonts.inter(color: AppTheme.textTertiary),
            prefixIcon: const Icon(Icons.tag_rounded, size: 20),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              final host = _hostController.text.trim();
              final port =
                  int.tryParse(_portController.text.trim()) ??
                  WifiObd2Service.defaultPort;
              Navigator.pop(context);
              widget.onWifiConnect(host, port);
            },
            icon: const Icon(Icons.wifi_rounded, size: 18),
            label: Text(
              'Conectar vía WiFi',
              style: GoogleFonts.inter(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBluetoothSection() {
    if (widget.devices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No se encontraron dispositivos emparejados',
            style: GoogleFonts.inter(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: widget.devices
          .map(
            (device) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.bluetooth_rounded,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  device.name ?? 'Dispositivo desconocido',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  device.address,
                  style: GoogleFonts.jetBrainsMono(fontSize: 11),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textTertiary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onDeviceSelected(device);
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

class _WifiStep extends StatelessWidget {
  final String number;
  final String text;
  const _WifiStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
