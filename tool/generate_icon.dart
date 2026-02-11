import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;

/// Generates app icon PNGs for flutter_launcher_icons.
/// Run: dart run tool/generate_icon.dart
Future<void> main() async {
  await _generateIcon('assets/icon/app_icon.png', 1024, withBackground: true);
  await _generateIcon('assets/icon/app_icon_foreground.png', 1024, withBackground: false);
  print('Icons generated in assets/icon/');
}

Future<void> _generateIcon(String path, int size, {required bool withBackground}) async {
  final file = File(path);
  await file.parent.create(recursive: true);

  final pixels = Uint8List(size * size * 4);
  final cx = size / 2;
  final cy = size / 2;

  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final idx = (y * size + x) * 4;

      if (withBackground) {
        // Gradient background: #4A6CF7 → #6B4CF7
        final t = y / size;
        final r = (74 + (107 - 74) * t).round().clamp(0, 255);
        final g = (108 + (76 - 108) * t).round().clamp(0, 255);
        pixels[idx] = r;
        pixels[idx + 1] = g;
        pixels[idx + 2] = 247;
        pixels[idx + 3] = 255;
      }
      // else: stays 0,0,0,0 (transparent)

      // ── Car body ──
      final carW = size * 0.52;
      final carH = size * 0.20;
      final carTop = cy + size * 0.04;
      final carLeft = cx - carW / 2;
      final carRight = carLeft + carW;
      final carBot = carTop + carH;
      final carRad = size * 0.04;

      if (_inRoundedRect(x.toDouble(), y.toDouble(), carLeft, carTop, carRight, carBot, carRad)) {
        _setWhite(pixels, idx);
      }

      // ── Car roof (trapezoid) ──
      final roofTop = carTop - size * 0.15;
      final roofBot = carTop + size * 0.01;
      if (y >= roofTop && y < roofBot) {
        final p = (y - roofTop) / (roofBot - roofTop);
        final topHalf = size * 0.15;
        final botHalf = carW / 2 * 0.85;
        final halfW = topHalf + (botHalf - topHalf) * p;
        if (x >= cx - halfW && x <= cx + halfW) {
          _setWhite(pixels, idx);
        }
      }

      // ── Windows (dark cutouts in roof) ──
      final winTop = carTop - size * 0.12;
      final winBot = carTop - size * 0.02;
      if (y >= winTop && y < winBot) {
        final p = (y - (carTop - size * 0.15)) / ((carTop + size * 0.01) - (carTop - size * 0.15));
        final topHalf = size * 0.15;
        final botHalf = carW / 2 * 0.85;
        final roofHalfW = topHalf + (botHalf - topHalf) * p;
        final winInset = size * 0.025;
        final winHalfW = roofHalfW - winInset;

        // Left window
        final leftWinLeft = cx - winHalfW;
        final leftWinRight = cx - size * 0.015;
        // Right window
        final rightWinLeft = cx + size * 0.015;
        final rightWinRight = cx + winHalfW;

        if ((x >= leftWinLeft && x <= leftWinRight) ||
            (x >= rightWinLeft && x <= rightWinRight)) {
          if (withBackground) {
            final t2 = y / size;
            pixels[idx] = (74 + (107 - 74) * t2).round().clamp(0, 255);
            pixels[idx + 1] = (108 + (76 - 108) * t2).round().clamp(0, 255);
            pixels[idx + 2] = 247;
            pixels[idx + 3] = 200;
          } else {
            pixels[idx] = 74;
            pixels[idx + 1] = 108;
            pixels[idx + 2] = 247;
            pixels[idx + 3] = 180;
          }
        }
      }

      // ── Wheels ──
      final wheelR = size * 0.065;
      final wheelY = carBot;
      final w1x = cx - carW * 0.30;
      final w2x = cx + carW * 0.30;
      final d1 = _dist(x.toDouble(), y.toDouble(), w1x, wheelY);
      final d2 = _dist(x.toDouble(), y.toDouble(), w2x, wheelY);

      if (d1 <= wheelR || d2 <= wheelR) {
        _setWhite(pixels, idx);
      }
      // Wheel hubs
      final hubR = wheelR * 0.45;
      if (d1 <= hubR || d2 <= hubR) {
        pixels[idx] = 74;
        pixels[idx + 1] = 108;
        pixels[idx + 2] = 247;
        pixels[idx + 3] = 255;
      }

      // ── Gauge arc (diagnostic symbol above car) ──
      final gaugeY = cy - size * 0.20;
      final gaugeR = size * 0.11;
      final gDist = _dist(x.toDouble(), y.toDouble(), cx, gaugeY);
      final gAngle = math.atan2(y - gaugeY, x - cx);
      final arcThick = size * 0.022;

      // Arc: top semicircle with small gap at bottom
      if (gDist >= gaugeR - arcThick && gDist <= gaugeR + arcThick &&
          gAngle >= -math.pi * 0.85 && gAngle <= -math.pi * 0.15) {
        _setWhite(pixels, idx);
      }

      // Tick marks on the arc
      for (var tickAngle = -math.pi * 0.8; tickAngle <= -math.pi * 0.2; tickAngle += math.pi * 0.15) {
        final tInnerR = gaugeR + arcThick;
        final tOuterR = gaugeR + arcThick + size * 0.018;
        if (gDist >= tInnerR && gDist <= tOuterR) {
          final a = math.atan2(y - gaugeY, x - cx);
          if ((a - tickAngle).abs() < 0.04) {
            _setWhite(pixels, idx);
          }
        }
      }

      // Needle pointing to ~60 degrees (good reading)
      final needleAngle = -math.pi * 0.35;
      final nEndX = cx + gaugeR * 0.75 * math.cos(needleAngle);
      final nEndY = gaugeY + gaugeR * 0.75 * math.sin(needleAngle);
      final nDist = _distToSeg(x.toDouble(), y.toDouble(), cx, gaugeY, nEndX, nEndY);
      if (nDist <= size * 0.012) {
        _setWhite(pixels, idx);
      }

      // Center dot
      if (gDist <= size * 0.022) {
        _setWhite(pixels, idx);
      }
    }
  }

  final png = _encodePng(pixels, size, size);
  await file.writeAsBytes(png);
}

void _setWhite(Uint8List p, int i) {
  p[i] = 255; p[i+1] = 255; p[i+2] = 255; p[i+3] = 255;
}

double _dist(double x1, double y1, double x2, double y2) =>
    math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));

bool _inRoundedRect(double x, double y, double l, double t, double r, double b, double rad) {
  if (x < l || x > r || y < t || y > b) return false;
  // Check corners
  if (x < l + rad && y < t + rad) return _dist(x, y, l + rad, t + rad) <= rad;
  if (x > r - rad && y < t + rad) return _dist(x, y, r - rad, t + rad) <= rad;
  if (x < l + rad && y > b - rad) return _dist(x, y, l + rad, b - rad) <= rad;
  if (x > r - rad && y > b - rad) return _dist(x, y, r - rad, b - rad) <= rad;
  return true;
}

double _distToSeg(double px, double py, double x1, double y1, double x2, double y2) {
  final dx = x2 - x1, dy = y2 - y1;
  final lenSq = dx * dx + dy * dy;
  if (lenSq == 0) return _dist(px, py, x1, y1);
  final t = (((px - x1) * dx + (py - y1) * dy) / lenSq).clamp(0.0, 1.0);
  return _dist(px, py, x1 + t * dx, y1 + t * dy);
}

// ── Minimal PNG encoder ──

Uint8List _encodePng(Uint8List rgba, int w, int h) {
  final raw = <int>[];
  for (int y = 0; y < h; y++) {
    raw.add(0); // filter: none
    for (int x = 0; x < w; x++) {
      final i = (y * w + x) * 4;
      raw.addAll([rgba[i], rgba[i+1], rgba[i+2], rgba[i+3]]);
    }
  }
  final compressed = ZLibCodec().encode(raw);
  final out = BytesBuilder();
  out.add([137, 80, 78, 71, 13, 10, 26, 10]); // PNG signature
  _chunk(out, 'IHDR', [
    ..._u32(w), ..._u32(h),
    8, // bit depth
    6, // RGBA
    0, 0, 0, // compression, filter, interlace
  ]);
  _chunk(out, 'IDAT', compressed);
  _chunk(out, 'IEND', []);
  return out.toBytes();
}

List<int> _u32(int v) => [(v >> 24) & 0xFF, (v >> 16) & 0xFF, (v >> 8) & 0xFF, v & 0xFF];

void _chunk(BytesBuilder b, String type, List<int> data) {
  b.add(_u32(data.length));
  b.add(type.codeUnits);
  b.add(data);
  b.add(_u32(_crc32([...type.codeUnits, ...data])));
}

int _crc32(List<int> data) {
  var c = 0xFFFFFFFF;
  for (final byte in data) {
    c ^= byte;
    for (int i = 0; i < 8; i++) {
      c = (c & 1 != 0) ? (c >> 1) ^ 0xEDB88320 : c >> 1;
    }
  }
  return c ^ 0xFFFFFFFF;
}
