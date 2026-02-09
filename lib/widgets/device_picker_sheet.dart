import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../theme/app_theme.dart';

class DevicePickerSheet extends StatelessWidget {
  final List<BluetoothDevice> devices;
  final ValueChanged<BluetoothDevice> onDeviceSelected;
  final VoidCallback onUseMock;

  const DevicePickerSheet({
    super.key,
    required this.devices,
    required this.onDeviceSelected,
    required this.onUseMock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Seleccionar Dispositivo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          const Text('Dispositivos Bluetooth emparejados',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 16),
          if (devices.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No se encontraron dispositivos emparejados',
                  style: TextStyle(color: AppTheme.textSecondary)),
              ),
            )
          else
            ...devices.map((device) => ListTile(
              leading: const Icon(Icons.bluetooth, color: AppTheme.primary),
              title: Text(device.name ?? 'Dispositivo desconocido',
                style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(device.address, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.textTertiary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: () {
                Navigator.pop(context);
                onDeviceSelected(device);
              },
            )),
          const Divider(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onUseMock();
              },
              icon: const Icon(Icons.science_outlined, size: 18),
              label: const Text('Usar datos de demostración'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
