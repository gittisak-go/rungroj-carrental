import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────
// promptpay_screen.dart
// ใช้: qr_flutter ^4.1.0
// pubspec: qr_flutter: ^4.1.0
// PromptPay เบอร์มือถือ รุ่งโรจน์คาร์เร้นท์: 0963638519
// ─────────────────────────────────────────────────────────────────

class PromptPayScreen extends StatefulWidget {
  final double amount;
  final String bookingId;
  const PromptPayScreen({super.key, required this.amount, required this.bookingId});

  @override
  State<PromptPayScreen> createState() => _PromptPayScreenState();
}

class _PromptPayScreenState extends State<PromptPayScreen> {
  bool _paid = false;

  // ── EMVCo PromptPay payload builder ──────────────────────────
  static String _buildPayload(double amount) {
    const ppId = '0066963638519'; // เบอร์มือถือ รุ่งโรจน์คาร์เร้นท์ (0963638519 → 0066...)
    final amt = amount.toStringAsFixed(2);

    final merchantAccount = '0016A000000677010111' // PromptPay GUID
        '0113$ppId';                               // mobile number (13 digits)

    String raw = ''
        '000201'                                   // Payload Format Indicator
        '010212'                                   // Dynamic QR
        '29${merchantAccount.length.toString().padLeft(2, '0')}$merchantAccount'
        '5303764'                                  // Currency: THB (764)
        '54${amt.length.toString().padLeft(2, '0')}$amt'
        '5802TH'                                   // Country: Thailand
        '6304';                                    // CRC placeholder

    // CRC16-CCITT (xFFFF)
    raw += _crc16(raw);
    return raw;
  }

  static String _crc16(String str) {
    int crc = 0xFFFF;
    for (final ch in str.codeUnits) {
      crc ^= ch << 8;
      for (int i = 0; i < 8; i++) {
        crc = (crc & 0x8000) != 0 ? ((crc << 1) ^ 0x1021) & 0xFFFF : (crc << 1) & 0xFFFF;
      }
    }
    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }

  void _confirmPayment() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ยืนยันการรับเงิน', style: kHead(20)),
            const SizedBox(height: 8),
            Text('฿${widget.amount.toStringAsFixed(0)}', style: kHead(36, color: kPrimary)),
            const SizedBox(height: 8),
            Text('Booking: ${widget.bookingId}', style: kBody(13, color: kTextMed)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(() => _paid = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) context.go('/payments');
                });
              },
              child: Container(
                width: double.infinity, height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [kSuccess, Color(0xFF00E676)]),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Center(child: Text('ยืนยันรับเงินแล้ว', style: kHead(16, color: Colors.white))),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payload = _buildPayload(widget.amount);

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text('ชำระผ่าน PromptPay', style: kHead(18)),
        leading: GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_rounded)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (_paid) ...[
                const SizedBox(height: 40),
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(color: kSuccess.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded, color: kSuccess, size: 56),
                ),
                const SizedBox(height: 24),
                Text('รับเงินสำเร็จ!', style: kHead(28, color: kSuccess)),
                const SizedBox(height: 8),
                Text('฿${widget.amount.toStringAsFixed(0)}', style: kHead(20, color: kTextMed)),
              ] else ...[
                // Amount card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text('ยอดชำระ', style: kBody(14, color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text('฿${widget.amount.toStringAsFixed(0)}', style: kHead(40, color: Colors.white)),
                      Text('Booking: ${widget.bookingId}', style: kBody(12, color: Colors.white60)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // QR Code box
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))],
                  ),
                  child: Column(
                    children: [
                      // PromptPay logo area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFF1A237E), borderRadius: BorderRadius.circular(8)),
                            child: Text('PromptPay', style: kHead(14, color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // QR placeholder (ใช้ qr_flutter จริง)
                      // QrImageView(data: payload, version: QrVersions.auto, size: 240)
                      Container(
                        width: 240, height: 240,
                        color: Colors.white,
                        child: CustomPaint(painter: _DemoQrPainter()),
                      ),

                      const SizedBox(height: 12),
                      Text('GTSALPHA MCP COMPANY LIMITED', style: kBody(12, color: const Color(0xFF1A237E), w: FontWeight.w600)),
                      Text('เลขนิติบุคคล 0445569000441', style: kBody(11, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: kDivider)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('วิธีชำระ', style: kHead(14)),
                      const SizedBox(height: 8),
                      _Step('1', 'เปิดแอปธนาคารหรือ Mobile Banking'),
                      _Step('2', 'เลือก "สแกน QR" หรือ "จ่ายเงิน"'),
                      _Step('3', 'สแกน QR Code ด้านบน'),
                      _Step('4', 'ตรวจสอบยอดเงินและยืนยัน'),
                      _Step('5', 'แจ้งเจ้าของรถว่าโอนแล้ว'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Confirm button (เจ้าของกด)
                GestureDetector(
                  onTap: _confirmPayment,
                  child: Container(
                    width: double.infinity, height: 56,
                    decoration: BoxDecoration(
                      color: kSuccess.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: kSuccess.withOpacity(0.4)),
                    ),
                    child: Center(child: Text('✅  ยืนยันว่ารับเงินแล้ว (เจ้าของกด)', style: kHead(15, color: kSuccess))),
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String no, text;
  const _Step(this.no, this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Container(
          width: 22, height: 22,
          decoration: BoxDecoration(color: kPrimary.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(child: Text(no, style: kBody(11, color: kPrimary, w: FontWeight.w700))),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: kBody(13, color: kTextMed))),
      ],
    ),
  );
}

class _DemoQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.black;
    // วาด QR demo pattern
    final cell = size.width / 21;
    final pattern = [
      [1,1,1,1,1,1,1,0,0,1,0,1,0,0,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,1],
      [1,0,1,1,1,0,1,0,0,1,0,1,0,0,1,0,1,1,1,0,1],
      [1,0,1,1,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,1],
      [1,0,1,1,1,0,1,0,0,1,1,0,0,0,1,0,1,1,1,0,1],
      [1,0,0,0,0,0,1,0,1,0,0,1,1,0,1,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,1,1,1,1,1,1],
      [0,0,0,0,0,0,0,0,1,1,0,1,0,0,0,0,0,0,0,0,0],
      [1,0,1,1,0,1,1,0,0,1,1,0,1,0,1,1,0,1,1,0,1],
      [0,1,0,0,1,0,0,1,1,0,0,1,0,1,0,0,1,1,0,0,0],
      [1,0,1,0,1,1,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0],
      [0,1,0,1,0,0,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1],
      [1,1,1,0,1,0,1,0,1,0,1,1,0,1,1,0,1,0,0,1,0],
      [0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,0,1,1,0,1],
      [1,1,1,1,1,1,1,0,0,1,0,1,0,0,1,0,1,1,0,0,1],
      [1,0,0,0,0,0,1,0,1,0,1,0,1,1,0,1,0,0,1,0,0],
      [1,0,1,1,1,0,1,1,0,1,0,1,0,0,1,0,1,0,0,1,0],
      [1,0,1,1,1,0,1,0,1,1,1,0,0,1,0,1,0,1,0,0,1],
      [1,0,1,1,1,0,1,0,0,0,1,1,0,0,1,0,0,0,1,0,0],
      [1,0,0,0,0,0,1,0,1,0,0,0,1,1,0,1,1,0,0,1,0],
      [1,1,1,1,1,1,1,0,0,1,1,0,0,0,1,0,0,1,0,0,1],
    ];
    for (int r = 0; r < pattern.length; r++) {
      for (int c = 0; c < pattern[r].length; c++) {
        if (pattern[r][c] == 1) {
          canvas.drawRect(Rect.fromLTWH(c * cell, r * cell, cell, cell), p);
        }
      }
    }
  }
  @override
  bool shouldRepaint(_) => false;
}
