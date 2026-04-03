import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────
// national_id_screen.dart
// ยืนยันบัตรประชาชนผู้เช่าก่อนรับรถ
// TODO: เชื่อม API (DOPA / provider ที่ติดต่อไว้)
// ─────────────────────────────────────────────────────────────────

class NationalIdScreen extends StatefulWidget {
  final String bookingId;
  const NationalIdScreen({super.key, required this.bookingId});

  @override
  State<NationalIdScreen> createState() => _NationalIdScreenState();
}

class _NationalIdScreenState extends State<NationalIdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  _VerifyState _state = _VerifyState.idle;
  String? _errorMsg;

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  String _formatId(String raw) {
    final digits = raw.replaceAll('-', '');
    if (digits.length <= 1) return digits;
    if (digits.length <= 5) return '${digits.substring(0,1)}-${digits.substring(1)}';
    if (digits.length <= 10) return '${digits.substring(0,1)}-${digits.substring(1,5)}-${digits.substring(5)}';
    if (digits.length <= 12) return '${digits.substring(0,1)}-${digits.substring(1,5)}-${digits.substring(5,10)}-${digits.substring(10)}';
    return '${digits.substring(0,1)}-${digits.substring(1,5)}-${digits.substring(5,10)}-${digits.substring(10,12)}-${digits.substring(12)}';
  }

  bool _validateThaiId(String id) {
    final digits = id.replaceAll('-', '');
    if (digits.length != 13) return false;
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(digits[i]) * (13 - i);
    }
    final check = (11 - (sum % 11)) % 10;
    return check == int.parse(digits[12]);
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _state = _VerifyState.verifying; _errorMsg = null; });

    await Future.delayed(const Duration(seconds: 2)); // simulate API
    if (!mounted) return;

    // TODO: เชื่อม API จริง
    // final result = await NationalIdService.verify(
    //   idNumber: _idCtrl.text.replaceAll('-', ''),
    //   fullName: _nameCtrl.text,
    //   dateOfBirth: _dobCtrl.text,
    // );

    final idDigits = _idCtrl.text.replaceAll('-', '');
    final valid = _validateThaiId(idDigits);

    if (valid) {
      setState(() => _state = _VerifyState.success);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) context.go('/nfc/${widget.bookingId}?mode=checkin');
    } else {
      setState(() {
        _state = _VerifyState.failed;
        _errorMsg = 'เลขบัตรประชาชนไม่ถูกต้อง\nกรุณาตรวจสอบและลองใหม่';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text('ยืนยันตัวตนผู้เช่า', style: kHead(18)),
        leading: GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_rounded)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kSecondary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kSecondary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card_rounded, color: kSecondary, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('บัตรประชาชน', style: kHead(16)),
                            Text('กรอกข้อมูลให้ตรงกับบัตรประชาชนผู้เช่า', style: kBody(13, color: kTextMed)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ID Number
                Text('เลขบัตรประชาชน 13 หลัก', style: kHead(14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _idCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 17, // with dashes: 1-4444-55555-66-7
                  style: kHead(18, color: kTextHigh),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  onChanged: (v) {
                    final formatted = _formatId(v);
                    if (formatted != v) {
                      _idCtrl.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '0-0000-00000-00-0',
                    counterText: '',
                    prefixIcon: const Icon(Icons.badge_rounded, color: kSecondary),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'กรุณากรอกเลขบัตรประชาชน';
                    if (!_validateThaiId(v.replaceAll('-', ''))) return 'เลขบัตรประชาชนไม่ถูกต้อง';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Full name
                Text('ชื่อ-นามสกุล (ภาษาไทย)', style: kHead(14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  style: kBody(16, color: kTextHigh),
                  decoration: const InputDecoration(
                    hintText: 'นาย/นาง/นางสาว ชื่อ นามสกุล',
                    prefixIcon: Icon(Icons.person_rounded, color: kSecondary),
                  ),
                  validator: (v) => (v == null || v.trim().length < 4) ? 'กรุณากรอกชื่อ-นามสกุล' : null,
                ),
                const SizedBox(height: 16),

                // Date of birth
                Text('วันเกิด (วว/ดด/ปปปป พ.ศ.)', style: kHead(14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dobCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: kBody(16, color: kTextHigh),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9/]'))],
                  decoration: const InputDecoration(
                    hintText: '01/01/2540',
                    counterText: '',
                    prefixIcon: Icon(Icons.cake_rounded, color: kSecondary),
                  ),
                  validator: (v) => (v == null || v.length < 10) ? 'กรุณากรอกวันเกิด' : null,
                ),
                const SizedBox(height: 32),

                // Status / Error
                if (_state == _VerifyState.verifying)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: kSecondary.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: kSecondary, strokeWidth: 2)),
                        const SizedBox(width: 16),
                        Text('กำลังยืนยันตัวตน...', style: kBody(14, color: kSecondary)),
                      ],
                    ),
                  )
                else if (_state == _VerifyState.success)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: kSuccess.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: kSuccess),
                        const SizedBox(width: 12),
                        Text('ยืนยันตัวตนสำเร็จ!', style: kHead(16, color: kSuccess)),
                      ],
                    ),
                  )
                else if (_state == _VerifyState.failed && _errorMsg != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: kError.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: kError.withOpacity(0.3))),
                    child: Row(
                      children: [
                        const Icon(Icons.error_rounded, color: kError),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_errorMsg!, style: kBody(13, color: kError))),
                      ],
                    ),
                  ),

                if (_state != _VerifyState.verifying && _state != _VerifyState.success) ...[
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _verify,
                    child: Container(
                      width: double.infinity, height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF2979FF), Color(0xFF00C2FF)]),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [BoxShadow(color: kSecondary.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
                      ),
                      child: Center(child: Text('ยืนยันตัวตน', style: kHead(16, color: Colors.white))),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_rounded, color: kTextLow, size: 16),
                      const SizedBox(width: 10),
                      Expanded(child: Text('ข้อมูลเข้ารหัสและเก็บตาม พ.ร.บ. PDPA พ.ศ. 2562', style: kBody(12, color: kTextLow))),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _VerifyState { idle, verifying, success, failed }
