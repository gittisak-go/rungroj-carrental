import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String bookingId;
  const PaymentScreen({super.key, required this.amount, required this.bookingId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _nfcScanning = false;
  bool _idVerified = false;
  bool _paymentDone = false;
  final _idCtrl = TextEditingController();
  String _idError = '';

  // PromptPay เลขนิติบุคคล GTSALPHA MCP
  static const _promptPayId = '0445569000441';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  // ─── PromptPay QR payload (EMVCo Thai standard) ───────────
  String _promptPayPayload() {
    final amt = widget.amount.toStringAsFixed(2);
    final merchantTag = '2937001600A000000677010111'
        '021300$_promptPayId';
    final amtTag = '54${amt.length.toString().padLeft(2, '0')}$amt';
    final raw = '000201010212$merchantTag5303764$amtTag5802TH'
        '5920DriveFlow Rental-R6304';
    // CRC16-CCITT (simplified placeholder — ใช้ library qr_flutter + promptpay จริง)
    return '${raw}0000'; // production: คำนวณ CRC จริง
  }

  // ─── National ID validation ────────────────────────────────
  bool _validateThaiId(String id) {
    if (id.length != 13) return false;
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(id[i]) * (13 - i);
    }
    final check = (11 - (sum % 11)) % 10;
    return check == int.parse(id[12]);
  }

  void _verifyId() {
    final id = _idCtrl.text.replaceAll('-', '').trim();
    if (_validateThaiId(id)) {
      setState(() { _idVerified = true; _idError = ''; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kSuccess,
          content: Text('ยืนยันตัวตนสำเร็จ ✓', style: kHead(14, color: Colors.black)),
        ),
      );
    } else {
      setState(() => _idError = 'เลขบัตรประชาชนไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง');
    }
  }

  // ─── NFC scan (Android NfcAdapter) ────────────────────────
  Future<void> _startNfcScan() async {
    setState(() => _nfcScanning = true);
    try {
      const ch = MethodChannel('com.driveflow.rentalr/nfc');
      // อ่านค่า NDEF จาก NFC tag
      // tag ต้องเขียน URL: rentalr://pay?id=BOOKING_ID&amount=AMOUNT
      final result = await ch.invokeMethod<String>('startScan');
      if (!mounted) return;
      if (result != null && result.contains(widget.bookingId)) {
        setState(() { _paymentDone = true; _nfcScanning = false; });
        _showSuccess();
      } else {
        setState(() => _nfcScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: kError, content: Text('QR/NFC ไม่ตรงกับการจองนี้', style: kBody(14, color: Colors.white))),
        );
      }
    } catch (_) {
      // NFC plugin ยังไม่ติดตั้ง หรืออุปกรณ์ไม่รองรับ
      if (mounted) {
        setState(() => _nfcScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: kError, content: Text('อุปกรณ์ไม่รองรับ NFC', style: kBody(14, color: Colors.white))),
        );
      }
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: kSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72, height: 72,
                decoration: const BoxDecoration(color: kSuccess, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.black, size: 40),
              ),
              const SizedBox(height: 20),
              Text('ชำระเงินสำเร็จ!', style: kHead(22)),
              const SizedBox(height: 8),
              Text('฿${widget.amount.toStringAsFixed(0)}', style: kHead(32, color: kSuccess)),
              const SizedBox(height: 8),
              Text('การจอง #${widget.bookingId}', style: kBody(13, color: kTextMed)),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () { Navigator.pop(context); context.go('/bookings'); },
                child: Container(
                  width: double.infinity, height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(child: Text('กลับหน้าการจอง', style: kHead(15, color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back_rounded, color: kTextHigh, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('ชำระเงิน', style: kHead(22)),
                ],
              ),
            ),

            // Amount card
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kPrimary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text('ยอดชำระ', style: kBody(14, color: kTextMed)),
                    const SizedBox(height: 6),
                    Text('฿${widget.amount.toStringAsFixed(0)}', style: kHead(40, color: kPrimary)),
                    Text('การจอง #${widget.bookingId}', style: kBody(12, color: kTextLow)),
                  ],
                ),
              ),
            ),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)),
              child: TabBar(
                controller: _tab,
                indicator: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: kBody(13, color: Colors.white, w: FontWeight.w600),
                unselectedLabelStyle: kBody(13, color: kTextMed),
                labelColor: Colors.white,
                unselectedLabelColor: kTextMed,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'QR พร้อมเพย์'),
                  Tab(text: 'NFC'),
                  Tab(text: 'ยืนยัน ID'),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _buildQrTab(),
                  _buildNfcTab(),
                  _buildIdTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Tab 1: QR PromptPay ──────────────────────────────────
  Widget _buildQrTab() => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        Text('สแกน QR Code เพื่อชำระเงิน', style: kBody(14, color: kTextMed)),
        const SizedBox(height: 20),
        Container(
          width: 240, height: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QR placeholder — production ใช้ qr_flutter package:
                // QrImageView(data: _promptPayPayload(), size: 200)
                Icon(Icons.qr_code_2_rounded, size: 160, color: Colors.black87),
                Text('QR พร้อมเพย์', style: TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kDivider),
          ),
          child: Column(
            children: [
              _InfoRow(Icons.business_rounded, 'ชื่อบัญชี', 'GTSALPHA MCP CO., LTD.'),
              const SizedBox(height: 8),
              _InfoRow(Icons.tag_rounded, 'เลขนิติบุคคล', _promptPayId),
              const SizedBox(height: 8),
              _InfoRow(Icons.payments_rounded, 'ยอด', '฿${widget.amount.toStringAsFixed(0)}'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('รองรับ: ธนาคารทุกแห่ง · True Money Wallet · SCB Easy', style: kBody(12, color: kTextLow), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        // Confirm slip button
        GestureDetector(
          onTap: () { setState(() => _paymentDone = true); _showSuccess(); },
          child: Container(
            width: double.infinity, height: 52,
            decoration: BoxDecoration(
              color: kSuccess.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kSuccess.withOpacity(0.4)),
            ),
            child: Center(child: Text('ฉันโอนแล้ว — ยืนยันการชำระ', style: kHead(14, color: kSuccess))),
          ),
        ),
      ],
    ),
  );

  // ─── Tab 2: NFC ───────────────────────────────────────────
  Widget _buildNfcTab() => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          width: 160, height: 160,
          decoration: BoxDecoration(
            color: (_nfcScanning ? kSecondary : kSurface).withOpacity(_nfcScanning ? 0.15 : 1),
            shape: BoxShape.circle,
            border: Border.all(
              color: _nfcScanning ? kSecondary : kDivider,
              width: _nfcScanning ? 3 : 1,
            ),
          ),
          child: Icon(
            Icons.nfc_rounded,
            size: 72,
            color: _nfcScanning ? kSecondary : kTextMed,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _nfcScanning ? 'กำลังรอสแกน NFC...\nแตะบัตร/อุปกรณ์ที่ตัวเครื่อง' : 'แตะบัตร NFC เพื่อชำระเงิน',
          style: kHead(16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'รองรับ: บัตร NFC · มือถือที่เปิด NFC · สมาร์ทวอทช์',
          style: kBody(13, color: kTextMed),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        if (!_nfcScanning)
          GestureDetector(
            onTap: _startNfcScan,
            child: Container(
              width: double.infinity, height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2979FF), Color(0xFF00C2FF)]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: kSecondary.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Center(child: Text('เริ่มสแกน NFC', style: kHead(16, color: Colors.white))),
            ),
          )
        else
          OutlinedButton(
            onPressed: () => setState(() => _nfcScanning = false),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: kDivider),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('ยกเลิก', style: kBody(14, color: kTextMed)),
          ),
      ],
    ),
  );

  // ─── Tab 3: National ID verify ────────────────────────────
  Widget _buildIdTab() => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kSecondary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kSecondary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_rounded, color: kSecondary, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text('ยืนยันตัวตนผู้เช่าตาม พ.ร.บ. PDPA\nข้อมูลจะไม่ถูกเก็บโดยไม่ได้รับอนุญาต', style: kBody(12, color: kTextMed))),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('เลขบัตรประชาชน', style: kHead(16)),
        const SizedBox(height: 10),
        TextField(
          controller: _idCtrl,
          keyboardType: TextInputType.number,
          maxLength: 13,
          style: kBody(18, color: kTextHigh, w: FontWeight.w600),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'X-XXXX-XXXXX-XX-X',
            counterText: '',
            suffixIcon: _idVerified
                ? const Icon(Icons.verified_rounded, color: kSuccess)
                : null,
          ),
          onChanged: (_) => setState(() => _idError = ''),
        ),
        if (_idError.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(_idError, style: kBody(12, color: kError)),
        ],
        const SizedBox(height: 20),
        if (!_idVerified)
          GestureDetector(
            onTap: _verifyId,
            child: Container(
              width: double.infinity, height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Center(child: Text('ยืนยันตัวตน', style: kHead(16, color: Colors.white))),
            ),
          )
        else ...[
          Container(
            width: double.infinity, height: 56,
            decoration: BoxDecoration(
              color: kSuccess.withOpacity(0.1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: kSuccess.withOpacity(0.4)),
            ),
            child: Center(child: Text('✓ ยืนยันตัวตนเรียบร้อย', style: kHead(16, color: kSuccess))),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () { setState(() => _paymentDone = true); _showSuccess(); },
            child: Container(
              width: double.infinity, height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2979FF), Color(0xFF00C2FF)]),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(child: Text('ดำเนินการต่อ', style: kHead(16, color: Colors.white))),
            ),
          ),
        ],
        const SizedBox(height: 24),
        // Legal note
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: kDivider)),
          child: Text(
            'การยืนยันตัวตนนี้ดำเนินการโดย GTSALPHA MCP COMPANY LIMITED '
            'ทะเบียนเลขที่ 0445569000441 ตาม พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562\n\n'
            'อัลกอริทึมตรวจสอบ: Luhn check digit (กรมการปกครอง)',
            style: kBody(11, color: kTextLow),
          ),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: kTextMed),
      const SizedBox(width: 8),
      Text('$label: ', style: kBody(13, color: kTextMed)),
      Expanded(child: Text(value, style: kHead(13), overflow: TextOverflow.ellipsis)),
    ],
  );
}
