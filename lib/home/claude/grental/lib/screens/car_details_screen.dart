import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class CarDetailsScreen extends StatefulWidget {
  final String carId;
  const CarDetailsScreen({super.key, required this.carId});
  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  DateTime _pickup = DateTime.now().add(const Duration(days: 1));
  DateTime _return = DateTime.now().add(const Duration(days: 3));

  int get _days => _return.difference(_pickup).inDays;
  double get _total => _days * 750.0;

  Future<void> _pickDate(bool isPickup) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isPickup ? _pickup : _return,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: kPrimary)),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isPickup) {
        _pickup = picked;
        if (_return.isBefore(_pickup.add(const Duration(days: 1)))) {
          _return = _pickup.add(const Duration(days: 1));
        }
      } else {
        _return = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: kBackground,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: kSurface.withOpacity(0.8), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: kSurface,
                child: const Center(child: Icon(Icons.directions_car_rounded, size: 100, color: kDivider)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Honda City', style: kHead(26)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('฿750', style: kHead(24, color: kPrimary)),
                          Text('/วัน', style: kBody(12, color: kTextMed)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: kAccent, size: 16),
                      const SizedBox(width: 4),
                      Text('4.8 (32 รีวิว)', style: kBody(13, color: kTextMed)),
                      const SizedBox(width: 12),
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(color: kSuccess, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text('ว่าง', style: kBody(13, color: kSuccess)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Specs
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Spec(Icons.people_rounded, '5 ที่นั่ง'),
                        _Spec(Icons.local_gas_station_rounded, 'เบนซิน'),
                        _Spec(Icons.settings_rounded, 'ออโต้'),
                        _Spec(Icons.speed_rounded, '14 กม./ล.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('เลือกวันเช่า', style: kHead(18)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _DateBox(label: 'รับรถ', date: _pickup, onTap: () => _pickDate(true))),
                      const SizedBox(width: 12),
                      Expanded(child: _DateBox(label: 'คืนรถ', date: _return, onTap: () => _pickDate(false))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kPrimary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kPrimary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ราคารวม $_days วัน', style: kBody(13, color: kTextMed)),
                            Text('฿750 × $_days วัน', style: kBody(12, color: kTextLow)),
                          ],
                        ),
                        Text('฿${_total.toStringAsFixed(0)}', style: kHead(24, color: kPrimary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => _showConfirmDialog(context),
                    child: Container(
                      width: double.infinity, height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Center(child: Text('จองรถเลย', style: kHead(16, color: Colors.white))),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: kDivider, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('ยืนยันการจอง', style: kHead(20)),
            const SizedBox(height: 16),
            _ConfirmRow('รถ', 'Honda City'),
            _ConfirmRow('รับรถ', '${_pickup.day}/${_pickup.month}/${_pickup.year + 543}'),
            _ConfirmRow('คืนรถ', '${_return.day}/${_return.month}/${_return.year + 543}'),
            _ConfirmRow('จำนวน', '$_days วัน'),
            _ConfirmRow('ราคารวม', '฿${_total.toStringAsFixed(0)}'),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () { Navigator.pop(context); context.go('/bookings'); },
              child: Container(
                width: double.infinity, height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Center(child: Text('ยืนยันจอง', style: kHead(16, color: Colors.white))),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Spec(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: kSecondary, size: 22),
      const SizedBox(height: 6),
      Text(label, style: kBody(12, color: kTextMed)),
    ],
  );
}

class _DateBox extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  const _DateBox({required this.label, required this.date, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kBody(12, color: kTextMed)),
          const SizedBox(height: 4),
          Text('${date.day}/${date.month}/${date.year + 543}', style: kHead(15)),
        ],
      ),
    ),
  );
}

class _ConfirmRow extends StatelessWidget {
  final String label, value;
  const _ConfirmRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: kBody(14, color: kTextMed)),
        Text(value, style: kHead(14)),
      ],
    ),
  );
}
