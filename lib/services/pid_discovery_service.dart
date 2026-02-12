import '../data/pid_catalog.dart';
import '../models/obd2_pid.dart';
import 'obd2_base_service.dart';

/// Discovers which OBD2 PIDs are supported by the connected vehicle
/// by reading the bitmap PIDs (0100, 0120, 0140, 0160).
class PidDiscoveryService {
  PidDiscoveryService._();

  /// Bitmap query PIDs and their ranges.
  static const _bitmapPids = {
    '0100': 0x01, // PIDs 01-20
    '0120': 0x21, // PIDs 21-40
    '0140': 0x41, // PIDs 41-60
    '0160': 0x61, // PIDs 61-80
  };

  /// Discovers supported PIDs by querying bitmap PIDs.
  /// Returns a list of PID hex strings (e.g., '010C', '010D').
  static Future<List<String>> discoverSupportedPids(
    Obd2BaseService service,
  ) async {
    final supported = <String>{};

    for (final entry in _bitmapPids.entries) {
      final bytes = await service.queryPid(entry.key);
      if (bytes == null || bytes.length < 4) continue;

      final startPid = entry.value;
      // Each of the 4 bytes represents 8 PIDs (32 total per bitmap)
      for (var byteIdx = 0; byteIdx < 4; byteIdx++) {
        for (var bit = 7; bit >= 0; bit--) {
          if ((bytes[byteIdx] >> bit) & 1 == 1) {
            final pidNum = startPid + (byteIdx * 8) + (7 - bit);
            final pidHex =
                '01${pidNum.toRadixString(16).padLeft(2, '0').toUpperCase()}';
            supported.add(pidHex);
          }
        }
      }

      // Check if the last PID in range is set (indicates next bitmap exists)
      final lastPid = startPid + 31;
      final lastPidHex =
          '01${lastPid.toRadixString(16).padLeft(2, '0').toUpperCase()}';
      if (!supported.contains(lastPidHex)) break;
    }

    return supported.toList()..sort();
  }

  /// Returns catalog entries for the supported PIDs.
  static List<Obd2Pid> getAvailableSensors(List<String> supportedPids) {
    return PidCatalog.all
        .where((p) => supportedPids.contains(p.pid.toUpperCase()))
        .toList();
  }
}
