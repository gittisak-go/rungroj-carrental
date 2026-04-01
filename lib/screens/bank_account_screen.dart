import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class BankAccountScreen extends StatefulWidget {
  const BankAccountScreen({super.key});
  @override
  State<BankAccountScreen> createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankCtrl    = TextEditingController();
  final _accNumCtrl  = TextEditingController();
  final _accNameCtrl = TextEditingController();
  final _promptCtrl  = TextEditingController();
  bool _saved = false;

  static const _banks = [
    'กสิกรไทย (KBank)',
    'ไทยพาณิชย์ (SCB)',
    'กรุงเทพ (BBL)',
    'กรุงไทย (KTB)',
    'ทหารไทยธนชาต (TTB)',
    'กรุงศรี (BAY)',
    'ออมสิน (GSB)',
    'ธ.ก.ส. (BAAC)',
    'ซิตี้แบงก์ (Citi)',
    'อื่นๆ',
  ];
  String _selectedBank = 'กสิกรไทย (KBank)';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _bankCtrl.dispose();
    _accNumCtrl.dispose();
    _accNameCtrl.dispose();
    _promptCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _selectedBank     = p.getString('bank_name')    ?? 'กสิกรไทย (KBank)';
      _accNumCtrl.text  = p.getString('bank_accnum')  ?? '';
      _accNameCtrl.text = p.getString('bank_accname') ?? '';
      _promptCtrl.text  = p.getString('bank_prompt')  ?? '';
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final p = await SharedPreferences.getInstance();
    await p.setString('bank_name',    _selectedBank);
    await p.setString('bank_accnum',  _accNumCtrl.text.trim());
    await p.setString('bank_accname', _accNameCtrl.text.trim());
    await p.setString('bank_prompt',  _promptCtrl.text.trim());
    if (!mounted) return;
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกบัญชีธนาคารแล้ว ✅')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text('บัญชีธนาคารร้าน', style: kHead(18)),
        leading: GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_rounded)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kSecondary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kSecondary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_rounded, color: kSecondary),
                      const SizedBox(width: 12),
                      Expanded(child: Text('ข้อมูลบัญชีใช้สำหรับรับโอนเงินจากผู้เช่า', style: kBody(13, color: kTextMed))),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('ธนาคาร', style: kHead(14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedBank,
                  dropdownColor: kSurface,
                  style: kBody(14, color: kTextHigh),
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.account_balance_rounded, color: kSecondary)),
                  items: _banks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                  onChanged: (v) => setState(() => _selectedBank = v!),
                ),
                const SizedBox(height: 14),

                Text('เลขบัญชี', style: kHead(14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _accNumCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: kHead(18, color: kTextHigh),
                  decoration: const InputDecoration(hintText: '0000000000', prefixIcon: Icon(Icons.credit_card_rounded, color: kSecondary)),
                  validator: (v) => (v == null || v.length < 10) ? 'กรุณากรอกเลขบัญชีให้ครบ' : null,
                ),
                const SizedBox(height: 14),

                Text('ชื่อบัญชี', style: kHead(14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _accNameCtrl,
                  style: kBody(16, color: kTextHigh),
                  decoration: const InputDecoration(hintText: 'ชื่อ-นามสกุลเจ้าของบัญชี', prefixIcon: Icon(Icons.person_rounded, color: kSecondary)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'กรุณากรอกชื่อบัญชี' : null,
                ),
                const SizedBox(height: 14),

                Text('เลขพร้อมเพย์ (ถ้ามี)', style: kHead(14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _promptCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: kBody(16, color: kTextHigh),
                  decoration: const InputDecoration(hintText: 'เบอร์โทร หรือ เลขบัตร 13 หลัก', prefixIcon: Icon(Icons.qr_code_rounded, color: kPrimary)),
                ),
                const SizedBox(height: 32),

                GestureDetector(
                  onTap: _save,
                  child: Container(
                    width: double.infinity, height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF2979FF), Color(0xFF00C2FF)]),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: kSecondary.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: Center(child: Text('บันทึกบัญชี', style: kHead(16, color: Colors.white))),
                  ),
                ),

                if (_saved) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: kSuccess.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: kSuccess.withOpacity(0.3))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ข้อมูลที่บันทึก', style: kHead(14, color: kSuccess)),
                        const SizedBox(height: 8),
                        Text('ธนาคาร: $_selectedBank', style: kBody(13, color: kTextMed)),
                        Text('เลขบัญชี: ${_accNumCtrl.text}', style: kBody(13, color: kTextMed)),
                        Text('ชื่อบัญชี: ${_accNameCtrl.text}', style: kBody(13, color: kTextMed)),
                        if (_promptCtrl.text.isNotEmpty)
                          Text('พร้อมเพย์: ${_promptCtrl.text}', style: kBody(13, color: kTextMed)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
