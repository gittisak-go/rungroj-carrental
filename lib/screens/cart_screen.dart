import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class CartItem {
  final String carId;
  final String carName;
  final double pricePerDay;
  final DateTime startDate;
  final DateTime endDate;
  int quantity;

  CartItem({
    required this.carId,
    required this.carName,
    required this.pricePerDay,
    required this.startDate,
    required this.endDate,
    this.quantity = 1,
  });

  int get days => endDate.difference(startDate).inDays;
  double get subtotal => pricePerDay * days * quantity;

  Map<String, dynamic> toJson() => {
    'carId': carId, 'carName': carName, 'pricePerDay': pricePerDay,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> j) => CartItem(
    carId: j['carId'], carName: j['carName'],
    pricePerDay: (j['pricePerDay'] as num).toDouble(),
    startDate: DateTime.parse(j['startDate']),
    endDate: DateTime.parse(j['endDate']),
    quantity: j['quantity'] ?? 1,
  );
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _items = [];

  // demo item เพื่อทดสอบ
  static final _demoItem = CartItem(
    carId: '1',
    carName: 'Honda City',
    pricePerDay: 750,
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 3)),
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('cart_items');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      setState(() => _items = list.map((e) => CartItem.fromJson(e)).toList());
    } else {
      // demo
      setState(() => _items = [_demoItem]);
      _persist();
    }
  }

  Future<void> _persist() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('cart_items', jsonEncode(_items.map((e) => e.toJson()).toList()));
  }

  void _remove(int i) {
    setState(() => _items.removeAt(i));
    _persist();
  }

  void _clear() {
    setState(() => _items.clear());
    _persist();
  }

  void _changeQty(int i, int delta) {
    final newQty = _items[i].quantity + delta;
    if (newQty < 1) return;
    setState(() => _items[i].quantity = newQty);
    _persist();
  }

  double get _total => _items.fold(0, (s, e) => s + e.subtotal);
  double get _fee => _total * 0.03;
  double get _grand => _total + _fee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text('ตะกร้าการจอง (${_items.length})', style: kHead(18)),
        leading: GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_rounded)),
        actions: [
          if (_items.isNotEmpty)
            TextButton(
              onPressed: () { _clear(); },
              child: Text('ล้างตะกร้า', style: kBody(13, color: kError)),
            ),
        ],
      ),
      body: SafeArea(
        child: _items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 80, color: kDivider),
                    const SizedBox(height: 16),
                    Text('ตะกร้าว่างเปล่า', style: kHead(18, color: kTextMed)),
                    const SizedBox(height: 8),
                    Text('เลือกรถที่ต้องการเช่าก่อนนะครับ', style: kBody(14, color: kTextLow)),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => context.go('/cars'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(24)),
                        child: Text('เลือกรถ', style: kHead(15, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length,
                      itemBuilder: (_, i) => _CartCard(
                        item: _items[i],
                        onRemove: () => _remove(i),
                        onInc: () => _changeQty(i, 1),
                        onDec: () => _changeQty(i, -1),
                      ),
                    ),
                  ),
                  _buildSummary(context),
                ],
              ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: kSurface, border: Border(top: BorderSide(color: kDivider))),
    child: Column(
      children: [
        _Row('ค่าเช่ารวม', '฿${_total.toStringAsFixed(0)}'),
        const SizedBox(height: 4),
        _Row('ค่าบริการ 3%', '฿${_fee.toStringAsFixed(0)}'),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: kDivider)),
        _Row('ยอดรวมทั้งหมด', '฿${_grand.toStringAsFixed(0)}', bold: true, color: kPrimary),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.go('/promptpay?amount=${_grand.toStringAsFixed(0)}&bookingId=cart'),
          child: Container(
            width: double.infinity, height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]),
              borderRadius: BorderRadius.circular(27),
              boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Center(child: Text('ชำระเงิน ฿${_grand.toStringAsFixed(0)}', style: kHead(16, color: Colors.white))),
          ),
        ),
      ],
    ),
  );
}

class _CartCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove, onInc, onDec;
  const _CartCard({required this.item, required this.onRemove, required this.onInc, required this.onDec});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: kDivider)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(item.carName, style: kHead(16))),
            GestureDetector(onTap: onRemove, child: const Icon(Icons.close_rounded, color: kError, size: 20)),
          ],
        ),
        const SizedBox(height: 8),
        Text('฿${item.pricePerDay.toStringAsFixed(0)}/วัน × ${item.days} วัน', style: kBody(13, color: kTextMed)),
        Text('${item.startDate.day}/${item.startDate.month} → ${item.endDate.day}/${item.endDate.month}', style: kBody(12, color: kTextLow)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(onTap: onDec, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.remove, size: 16, color: kTextHigh))),
                SizedBox(width: 32, child: Center(child: Text('${item.quantity}', style: kHead(16)))),
                GestureDetector(onTap: onInc, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.add, size: 16, color: Colors.white))),
              ],
            ),
            Text('฿${item.subtotal.toStringAsFixed(0)}', style: kHead(16, color: kPrimary)),
          ],
        ),
      ],
    ),
  );
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool bold;
  final Color color;
  const _Row(this.label, this.value, {this.bold = false, this.color = kTextHigh});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: kBody(14, color: kTextMed)),
      Text(value, style: bold ? kHead(18, color: color) : kBody(14, color: color)),
    ],
  );
}
