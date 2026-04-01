import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/car_card.dart';

class CarDirectoryScreen extends StatefulWidget {
  const CarDirectoryScreen({super.key});
  @override
  State<CarDirectoryScreen> createState() => _CarDirectoryScreenState();
}

class _CarDirectoryScreenState extends State<CarDirectoryScreen> {
  String _status = 'ทั้งหมด';
  String _fuel = 'ทั้งหมด';

  final _cars = [
    {'id': '1', 'brand': 'Toyota', 'model': 'Yaris ATIV', 'price': 650.0, 'seats': 5, 'fuel': 'เบนซิน', 'status': 'available', 'img': ''},
    {'id': '2', 'brand': 'Honda', 'model': 'City', 'price': 750.0, 'seats': 5, 'fuel': 'เบนซิน', 'status': 'available', 'img': ''},
    {'id': '3', 'brand': 'Toyota', 'model': 'Camry Hybrid', 'price': 1800.0, 'seats': 5, 'fuel': 'ไฮบริด', 'status': 'rented', 'img': ''},
    {'id': '4', 'brand': 'MG', 'model': 'ZS EV', 'price': 1200.0, 'seats': 5, 'fuel': 'ไฟฟ้า (EV)', 'status': 'available', 'img': ''},
    {'id': '5', 'brand': 'Toyota', 'model': 'Fortuner', 'price': 2200.0, 'seats': 7, 'fuel': 'ดีเซล', 'status': 'available', 'img': ''},
  ];

  List<Map<String, dynamic>> get _filtered => _cars.where((c) {
    final statusOk = _status == 'ทั้งหมด' || c['status'] == (_status == 'ว่าง' ? 'available' : _status == 'ถูกเช่า' ? 'rented' : 'maintenance');
    final fuelOk = _fuel == 'ทั้งหมด' || c['fuel'] == _fuel;
    return statusOk && fuelOk;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  GestureDetector(onTap: () => context.pop(), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_rounded, color: kTextHigh, size: 20))),
                  const SizedBox(width: 16),
                  Expanded(child: Text('รายการรถทั้งหมด', style: kHead(22))),
                  GestureDetector(
                    onTap: () => context.go('/add'),
                    child: Container(width: 40, height: 40, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.add, color: Colors.white, size: 22)),
                  ),
                ],
              ),
            ),
            // Status filter
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ['ทั้งหมด', 'ว่าง', 'ถูกเช่า', 'ซ่อมบำรุง'].map((s) {
                  final sel = _status == s;
                  return GestureDetector(
                    onTap: () => setState(() => _status = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: sel ? kPrimary : kSurface, borderRadius: BorderRadius.circular(18), border: sel ? null : Border.all(color: kDivider)),
                      child: Text(s, style: kBody(13, color: sel ? Colors.white : kTextMed, w: FontWeight.w600)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            // Fuel filter
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ['ทั้งหมด', 'เบนซิน', 'ดีเซล', 'ไฟฟ้า (EV)', 'ไฮบริด'].map((f) {
                  final sel = _fuel == f;
                  return GestureDetector(
                    onTap: () => setState(() => _fuel = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: sel ? kSecondary : kSurface, borderRadius: BorderRadius.circular(18), border: sel ? null : Border.all(color: kDivider)),
                      child: Text(f, style: kBody(13, color: sel ? Colors.white : kTextMed, w: FontWeight.w600)),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text('${_filtered.length} คัน', style: kBody(13, color: kTextMed)),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => CarCard(car: _filtered[i], onTap: () => context.go('/car/${_filtered[i]['id']}')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
