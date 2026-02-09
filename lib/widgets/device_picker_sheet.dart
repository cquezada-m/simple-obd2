import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
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
    // En iOS, mostrar WiFi por defecto. En Android, Bluetooth.
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Conectar Dispositivo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.isIOS
                  ? 'Conecta via WiFi al adaptador OBD2'
                  : 'Selecciona el metodo de conexion',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Toggle Bluetooth / WiFi (solo en Android, en iOS solo WiFi)
            if (!widget.isIOS) ...[
              _buildModeToggle(),
              const SizedBox(height: 16),
            ],

            // Contenido según modo
            if (_showWifi) _buildWifiSection() else _buildBluetoothSection(),

            const Divider(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onUseMock();
                },
                icon: const Icon(Icons.science_outlined, size: 18),
                label: const Text('Usar datos de demostracion'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleButton(
              icon: Icons.bluetooth,
              label: 'Bluetooth',
              selected: !_showWifi,
              onTap: () => setState(() => _showWifi = false),
            ),
          ),
          Expanded(
            child: _toggleButton(
              icon: Icons.wifi,
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
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
              color: selected ? AppTheme.primary : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? AppTheme.textPrimary : AppTheme.textSecondary,
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
        // Instrucciones
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppTheme.primary),
                  SizedBox(width: 8),
                  Text(
                    'Como conectar via WiFi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _WifiStep(
                number: '1',
                text: 'Conecta el adaptador OBD2 al puerto del vehiculo',
              ),
              SizedBox(height: 4),
              _WifiStep(
                number: '2',
                text: 'Ve a Ajustes > WiFi en tu dispositivo',
              ),
              SizedBox(height: 4),
              _WifiStep(
                number: '3',
                text:
                    'Conectate a la red del adaptador (ej: OBDLink, WiFi_OBDII, CLKDevices)',
              ),
              SizedBox(height: 4),
              _WifiStep(number: '4', text: 'Regresa aqui y presiona Conectar'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Campos IP y Puerto
        const Text(
          'Direccion IP',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _hostController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '192.168.0.10',
            prefixIcon: const Icon(Icons.router_outlined, size: 20),
            filled: true,
            fillColor: AppTheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Puerto',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _portController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '35000',
            prefixIcon: const Icon(Icons.tag, size: 20),
            filled: true,
            fillColor: AppTheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
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
            icon: const Icon(Icons.wifi, size: 18),
            label: const Text('Conectar via WiFi'),
          ),
        ),
      ],
    );
  }

  Widget _buildBluetoothSection() {
    if (widget.devices.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No se encontraron dispositivos emparejados',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: widget.devices
          .map(
            (device) => ListTile(
              leading: const Icon(Icons.bluetooth, color: AppTheme.primary),
              title: Text(
                device.name ?? 'Dispositivo desconocido',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                device.address,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppTheme.textTertiary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onDeviceSelected(device);
              },
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
            color: AppTheme.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
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
            style: const TextStyle(
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
