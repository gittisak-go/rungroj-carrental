import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────
// nfc_scan_screen.dart
// ใช้: flutter_nfc_kit ^3.3.1
// pubspec: flutter_nfc_kit: ^3.3.1
// AndroidManifest: <uses-permission android:name="android.permission.NFC"/>
// MethodChannel: nfc.gtsalphamcp.com (Hostinger subdomain)
// ─────────────────────────────────────────────────────────────────

class NfcScanScreen extends StatefulWidget {
  final String bookingId;
  final String mode; // 'checkin' | 'checkout'
  const NfcScanScreen({super.key, required this.bookingId, required this.mode});

  @override
  State<NfcScanScreen> createState() => _NfcScanScreenState();
}

class _NfcScanScreenState extends State<NfcScanScreen>
    with TickerProviderStateMixin {
  static const _nfc = MethodChannel('nfc.gtsalphamcp.com');

  _ScanState _state = _ScanState.idle;
  String _message = 'พร้อมสแกน';
  bool _nfcAvailable = false;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _checkNfc();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _stopNfc();
    super.dispose();
  }

  Future<void> _checkNfc() async {
    try {
      final ok = await _nfc.invokeMethod<bool>('isAvailable');
      if (mounted) setState(() => _nfcAvailable = ok ?? false);
    } catch (_) {
      if (mounted) setState(() => _nfcAvailable = false);
    }
  }

  Future<void> _startScan() async {
    setState(() { _state = _ScanState.scanning; _message = 'แตะบัตร NFC หรือโทรศัพท์...'; });
    try {
      final result = await _nfc.invokeMethod<String>('readTag');
      if (!mounted) return;
      if (result != null && result.isNotEmpty) {
        await _onTagRead(result);
      } else {
        _setError('ไม่พบข้อมูลบน NFC tag');
      }
    } on PlatformException catch (e) {
      if (mounted) _setError(e.message ?? 'สแกนไม่สำเร็จ');
    }
  }

  Future<void> _onTagRead(String payload) async {
    setState(() { _state = _ScanState.verifying; _message = 'กำลังยืนยัน...'; });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // TODO: ส่ง payload ไป Firebase verify
    // final valid = await BookingService.verifyNfcToken(widget.bookingId, payload);
    final valid = payload.contains(widget.bookingId) || true; // demo mode

    if (valid) {
      setState(() { _state = _ScanState.success; _message = widget.mode == 'checkin' ? 'รับรถสำเร็จ! 🎉' : 'คืนรถสำเร็จ! ✅'; });
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) context.go('/bookings');
    } else {
      _setError('Token ไม่ตรงกัน กรุณาติดต่อเจ้าของรถ');
    }
  }

  void _setError(String msg) {
    setState(() { _state = _ScanState.error; _message = msg; });
  }

  Future<void> _stopNfc() async {
    try { await _nfc.invokeMethod('stop'); } catch (_) {}
  }

  String get _modeLabel => widget.mode == 'checkin' ? 'รับรถ' : 'คืนรถ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text('สแกน NFC — $_modeLabel', style: kHead(18)),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // NFC animation ring
              ScaleTransition(
                scale: _state == _ScanState.scanning ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
                child: _NfcRing(state: _state),
              ),

              const SizedBox(height: 40),

              // Status message
              Text(_message, style: kHead(20, color: _stateColor), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Booking ID: ${widget.bookingId}',
                style: kBody(13, color: kTextLow),
              ),

              const Spacer(),

              // NFC not available warning
              if (!_nfcAvailable)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: kAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: kAccent),
                      const SizedBox(width: 12),
                      Expanded(child: Text('อุปกรณ์นี้ไม่รองรับ NFC\nใช้ QR Code แทนได้เลย', style: kBody(13, color: kAccent))),
                    ],
                  ),
                ),

              // Scan button
              if (_state != _ScanState.scanning && _state != _ScanState.success)
                _PrimaryBtn(
                  icon: Icons.nfc_rounded,
                  label: _nfcAvailable ? 'เริ่มสแกน NFC' : 'NFC ไม่พร้อม',
                  color: _nfcAvailable ? kPrimary : kTextMed,
                  onTap: _nfcAvailable ? _startScan : null,
                ),

              const SizedBox(height: 12),

              // QR fallback
              _OutlineBtn(
                icon: Icons.qr_code_scanner_rounded,
                label: 'ใช้ QR Code แทน',
                onTap: () => context.push('/qr/${widget.bookingId}'),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Color get _stateColor {
    switch (_state) {
      case _ScanState.success: return kSuccess;
      case _ScanState.error: return kError;
      case _ScanState.scanning: return kSecondary;
      default: return kTextHigh;
    }
  }
}

enum _ScanState { idle, scanning, verifying, success, error }

class _NfcRing extends StatelessWidget {
  final _ScanState state;
  const _NfcRing({required this.state});

  Color get _color {
    switch (state) {
      case _ScanState.success: return kSuccess;
      case _ScanState.error: return kError;
      case _ScanState.scanning: return kSecondary;
      default: return kPrimary;
    }
  }

  IconData get _icon {
    switch (state) {
      case _ScanState.success: return Icons.check_circle_rounded;
      case _ScanState.error: return Icons.error_rounded;
      case _ScanState.verifying: return Icons.sync_rounded;
      default: return Icons.nfc_rounded;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    width: 180, height: 180,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: _color.withOpacity(0.06),
      border: Border.all(color: _color.withOpacity(0.3), width: 2),
      boxShadow: [BoxShadow(color: _color.withOpacity(0.2), blurRadius: 40, spreadRadius: 8)],
    ),
    child: Center(
      child: Container(
        width: 120, height: 120,
        decoration: BoxDecoration(shape: BoxShape.circle, color: _color.withOpacity(0.12)),
        child: Icon(_icon, size: 56, color: _color),
      ),
    ),
  );
}

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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(onTap != null ? 1.0 : 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: kTextHigh, size: 22),
          const SizedBox(width: 10),
          Text(label, style: kHead(16)),
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: kDivider),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: kTextMed, size: 22),
          const SizedBox(width: 10),
          Text(label, style: kBody(16, color: kTextMed)),
        ],
      ),
    ),
  );
}
