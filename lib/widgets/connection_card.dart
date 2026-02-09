import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConnectionCard extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const ConnectionCard({
    super.key,
    required this.isConnected,
    required this.isConnecting,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                _buildStatusIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isConnected
                            ? 'Conectado'
                            : isConnecting
                            ? 'Conectando...'
                            : 'Desconectado',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (isConnected) ...[
                            const Icon(
                              Icons.wifi,
                              size: 14,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            isConnected ? 'OBD2 ELM327' : 'Dispositivo OBD2',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isConnected)
                  OutlinedButton(
                    onPressed: onDisconnect,
                    child: const Text(
                      'Desconectar',
                      style: TextStyle(fontSize: 13),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: isConnecting ? null : onConnect,
                    child: Text(
                      isConnecting ? 'Conectando...' : 'Conectar',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
            if (!isConnected && !isConnecting) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppTheme.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Asegúrate de que tu dispositivo OBD2 esté conectado al vehículo y encendido.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    Color bgColor;
    if (isConnected) {
      bgColor = AppTheme.success;
    } else if (isConnecting) {
      bgColor = AppTheme.primary;
    } else {
      bgColor = AppTheme.textTertiary;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: const Icon(Icons.bluetooth, size: 22, color: Colors.white),
    );
  }
}
