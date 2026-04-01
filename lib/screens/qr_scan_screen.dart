import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────
// qr_scan_screen.dart
// ใช้: mobile_scanner ^5.0.0
// pubspec: mobile_scanner: ^5.0.0
// AndroidManifest: <uses-permission android:name="android.permission.CAMERA"/>
// ─────────────────────────────────────────────────────────────────

class QrScanScreen extends StatefulWidget {
  final String bookingId;
  const QrScanScreen({super.key, required this.bookingId});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _scanned = false;
  bool _torchOn = false;

  void _onDetect(String code) {
    if (_scanned) return;
    setState(() => _scanned = true);

    // TODO: verify QR payload
    // Expected: https://rentalr.app/booking/{bookingId}?token={jwt}
    if (code.contains(widget.bookingId) || code.isNotEmpty) {
      _showResult(true, code);
    } else {
      _showResult(false, 'QR ไม่ถูกต้อง');
    }
  }

  void _showResult(bool success, String data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      isDismissible: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: (success ? kSuccess : kError).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                success ? Icons.check_circle_rounded : Icons.error_rounded,
                color: success ? kSuccess : kError,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(success ? 'สแกนสำเร็จ!' : 'สแกนไม่สำเร็จ', style: kHead(20, color: success ? kSuccess : kError)),
            const SizedBox(height: 8),
            Text(success ? 'กำลังดำเนินการ...' : data, style: kBody(14, color: kTextMed), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            if (success)
              _PrimaryBtn(
                icon: Icons.arrow_forward_rounded,
                label: 'ดำเนินการต่อ',
                color: kSuccess,
                onTap: () { Navigator.pop(context); context.go('/bookings'); },
              )
            else
              _OutlineBtn(
                icon: Icons.refresh_rounded,
                label: 'สแกนใหม่',
                onTap: () { Navigator.pop(context); setState(() => _scanned = false); },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera view placeholder
          // ถ้าติดตั้ง mobile_scanner แล้ว:
          // MobileScanner(onDetect: (capture) => _onDetect(capture.barcodes.first.rawValue ?? ''))
          Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt_rounded, color: Colors.white54, size: 64),
                  const SizedBox(height: 16),
                  Text('กล้องจะแสดงที่นี่', style: kBody(14, color: Colors.white54)),
                  Text('(ต้องติดตั้ง mobile_scanner)', style: kBody(12, color: Colors.white30)),
                ],
              ),
            ),
          ),

          // Overlay frame
          _QrOverlay(),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                  ),
                  Text('สแกน QR Code', style: kHead(16, color: Colors.white)),
                  GestureDetector(
                    onTap: () => setState(() => _torchOn = !_torchOn),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: Icon(_torchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom hint
          Positioned(
            bottom: 60, left: 0, right: 0,
            child: Column(
              children: [
                Text('จัดกรอบ QR ให้อยู่ตรงกลาง', style: kBody(14, color: Colors.white70), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                // Demo button (ลบออกเมื่อกล้องพร้อม)
                GestureDetector(
                  onTap: () => _onDetect('https://rentalr.app/booking/${widget.bookingId}?token=demo'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(24)),
                    child: Text('ทดสอบ (Demo)', style: kHead(14, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const frameSize = 240.0;
    final top = (size.height - frameSize) / 2 - 40;
    final left = (size.width - frameSize) / 2;
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.srcOut),
          child: Stack(
            children: [
              Container(color: Colors.transparent),
              Positioned(top: top, left: left, child: Container(width: frameSize, height: frameSize, color: Colors.black)),
            ],
          ),
        ),
        Positioned(
          top: top, left: left,
          child: SizedBox(
            width: frameSize, height: frameSize,
            child: CustomPaint(painter: _FramePainter()),
          ),
        ),
      ],
    );
  }
}

class _FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = kPrimary..strokeWidth = 4..style = PaintingStyle.stroke;
    const r = 12.0;
    const len = 30.0;
    // corners
    for (final (x, y) in [(0.0, 0.0), (size.width, 0.0), (0.0, size.height), (size.width, size.height)]) {
      final dx = x == 0 ? 1 : -1;
      final dy = y == 0 ? 1 : -1;
      canvas.drawLine(Offset(x, y + dy * r), Offset(x, y + dy * (r + len)), paint);
      canvas.drawLine(Offset(x + dx * r, y), Offset(x + dx * (r + len), y), paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────
// Shared widgets (ใช้ร่วมกัน nfc + qr screen)
// ─────────────────────────────────────────────────────────────────

class _PrimaryBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _PrimaryBtn({required this.icon, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, height: 56,
      decoration: BoxDecoration(
        color: onTap != null ? color : kTextLow,
        borderRadius: BorderRadius.circular(28),
        boxShadow: onTap != null ? [BoxShadow(color: color.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))] : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Text(label, style: kHead(16, color: Colors.white)),
        ],
      ),
    ),
  );
}

class _OutlineBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _OutlineBtn({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, height: 52,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: kDivider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: kTextMed, size: 20),
          const SizedBox(width: 10),
          Text(label, style: kHead(15, color: kTextMed)),
        ],
      ),
    ),
  );
}
