// ════════════════ add_listing_screen.dart ════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});
  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brand = TextEditingController();
  final _model = TextEditingController();
  final _plate = TextEditingController();
  final _price = TextEditingController();
  String _fuel = 'เบนซิน';
  String _trans = 'เกียร์อัตโนมัติ';
  int _seats = 5;

  @override
  void dispose() {
    _brand.dispose(); _model.dispose(); _plate.dispose(); _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Row(
                    children: [
                      GestureDetector(onTap: () => context.pop(), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_rounded, color: kTextHigh, size: 20))),
                      const SizedBox(width: 16),
                      Text('เพิ่มรถใหม่', style: kHead(22)),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo upload
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 160, width: double.infinity,
                          decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(20), border: Border.all(color: kDivider, style: BorderStyle.solid)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 52, height: 52, decoration: BoxDecoration(color: kPrimary.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.camera_alt_rounded, color: kPrimary, size: 26)),
                              const SizedBox(height: 10),
                              Text('เพิ่มรูปรถ', style: kHead(14, color: kPrimary)),
                              Text('อัปโหลดได้สูงสุด 5 รูป', style: kBody(12, color: kTextMed)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('ข้อมูลรถ', style: kHead(18)),
                      const SizedBox(height: 14),
                      _Field(_brand, 'ยี่ห้อรถ', 'Toyota, Honda, MG...'),
                      const SizedBox(height: 12),
                      _Field(_model, 'รุ่นรถ', 'Yaris, City, ZS EV...'),
                      const SizedBox(height: 12),
                      _Field(_plate, 'ทะเบียนรถ', 'กข-1234'),
                      const SizedBox(height: 20),
                      Text('รายละเอียด', style: kHead(18)),
                      const SizedBox(height: 14),
                      // Fuel dropdown
                      _DropField(
                        label: 'ประเภทเชื้อเพลิง',
                        value: _fuel,
                        items: ['เบนซิน', 'ดีเซล', 'ไฟฟ้า (EV)', 'ไฮบริด'],
                        onChanged: (v) => setState(() => _fuel = v!),
                      ),
                      const SizedBox(height: 12),
                      _DropField(
                        label: 'เกียร์',
                        value: _trans,
                        items: ['เกียร์อัตโนมัติ', 'เกียร์ธรรมดา'],
                        onChanged: (v) => setState(() => _trans = v!),
                      ),
                      const SizedBox(height: 12),
                      // Seats
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: kDivider)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('จำนวนที่นั่ง', style: kBody(14, color: kTextMed)),
                            Row(
                              children: [
                                GestureDetector(onTap: () => setState(() => _seats = (_seats - 1).clamp(2, 15)), child: Container(width: 32, height: 32, decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.remove, size: 16, color: kTextHigh))),
                                SizedBox(width: 32, child: Center(child: Text('$_seats', style: kHead(16)))),
                                GestureDetector(onTap: () => setState(() => _seats = (_seats + 1).clamp(2, 15)), child: Container(width: 32, height: 32, decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.add, size: 16, color: Colors.white))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('ราคา', style: kHead(18)),
                      const SizedBox(height: 14),
                      _Field(_price, 'ราคาต่อวัน (บาท)', '800', keyboardType: TextInputType.number),
                      const SizedBox(height: 32),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) context.go('/rdrive');
                        },
                        child: Container(
                          width: double.infinity, height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                          ),
                          child: Center(child: Text('บันทึกรถ', style: kHead(16, color: Colors.white))),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final TextInputType? keyboardType;
  const _Field(this.ctrl, this.label, this.hint, {this.keyboardType});
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: ctrl,
    keyboardType: keyboardType,
    style: kBody(14, color: kTextHigh),
    validator: (v) => (v == null || v.isEmpty) ? 'กรุณากรอก$label' : null,
    decoration: InputDecoration(labelText: label, hintText: hint),
  );
}

class _DropField extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropField({required this.label, required this.value, required this.items, required this.onChanged});
  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    value: value,
    dropdownColor: kSurface,
    style: kBody(14, color: kTextHigh),
    decoration: InputDecoration(labelText: label),
    items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
    onChanged: onChanged,
  );
}
