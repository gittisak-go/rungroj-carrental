import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../widgets/car_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String _selectedFilter = 'ทั้งหมด';
  final _filters = ['ทั้งหมด', 'ว่าง', 'อีโค่', 'SUV', 'EV'];

  // Demo data
  final _cars = [
    {'id': '1', 'brand': 'Toyota', 'model': 'Yaris ATIV', 'price': 650.0, 'seats': 5, 'fuel': 'เบนซิน', 'status': 'available', 'img': ''},
    {'id': '2', 'brand': 'Honda', 'model': 'City', 'price': 750.0, 'seats': 5, 'fuel': 'เบนซิน', 'status': 'available', 'img': ''},
    {'id': '3', 'brand': 'Toyota', 'model': 'Camry Hybrid', 'price': 1800.0, 'seats': 5, 'fuel': 'ไฮบริด', 'status': 'rented', 'img': ''},
    {'id': '4', 'brand': 'MG', 'model': 'ZS EV', 'price': 1200.0, 'seats': 5, 'fuel': 'ไฟฟ้า (EV)', 'status': 'available', 'img': ''},
    {'id': '5', 'brand': 'Toyota', 'model': 'Fortuner', 'price': 2200.0, 'seats': 7, 'fuel': 'ดีเซล', 'status': 'available', 'img': ''},
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(child: _buildHeader()),
            // Search
            SliverToBoxAdapter(child: _buildSearch()),
            // Filter chips
            SliverToBoxAdapter(child: _buildFilters()),
            // Stats row
            SliverToBoxAdapter(child: _buildStats()),
            // Quick access
            SliverToBoxAdapter(child: _buildQuickAccess()),
            // Section title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('รถที่มีให้เช่า', style: kHead(18)),
                    TextButton(
                      onPressed: () => context.go('/cars'),
                      child: Text('ดูทั้งหมด', style: kBody(13, color: kSecondary)),
                    ),
                  ],
                ),
              ),
            ),
            // Car list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => CarCard(car: _cars[i], onTap: () => context.go('/car/${_cars[i]['id']}')),
                  childCount: _cars.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/add'),
        backgroundColor: kPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('ลงรถ', style: kHead(14, color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('สวัสดีครับ 👋', style: kBody(14, color: kTextMed)),
              Text('Rental-R', style: kHead(26)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/rdrive'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2979FF), Color(0xFF00C2FF)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.dashboard_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text('R-Drive', style: kHead(13, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildSearch() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
    child: TextField(
      controller: _search,
      style: kBody(14, color: kTextHigh),
      decoration: InputDecoration(
        hintText: 'ค้นหารถ ยี่ห้อ รุ่น...',
        prefixIcon: const Icon(Icons.search, color: kTextMed),
        suffixIcon: const Icon(Icons.tune_rounded, color: kPrimary),
      ),
    ),
  );

  Widget _buildFilters() => SizedBox(
    height: 40,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filters.length,
      itemBuilder: (_, i) {
        final selected = _selectedFilter == _filters[i];
        return GestureDetector(
          onTap: () => setState(() => _selectedFilter = _filters[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? kPrimary : kSurface,
              borderRadius: BorderRadius.circular(20),
              border: selected ? null : Border.all(color: kDivider),
            ),
            child: Text(
              _filters[i],
              style: kBody(13, color: selected ? Colors.white : kTextMed, w: FontWeight.w600),
            ),
          ),
        );
      },
    ),
  );

  Widget _buildStats() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Row(
      children: [
        _StatChip(label: 'ว่าง', value: '4', color: kSuccess),
        const SizedBox(width: 10),
        _StatChip(label: 'ถูกเช่า', value: '1', color: kAccent),
        const SizedBox(width: 10),
        _StatChip(label: 'รายรับวันนี้', value: '฿4,800', color: kPrimary),
      ],
    ),
  );

  Widget _buildQuickAccess() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('เมนูด่วน', style: kHead(16)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _QuickBtn(Icons.shopping_cart_rounded, 'ตะกร้า', kPrimary, () => context.go('/cart')),
              _QuickBtn(Icons.account_balance_rounded, 'บัญชีธนาคาร', kSecondary, () => context.go('/bank')),
              _QuickBtn(Icons.nfc_rounded, 'NFC', kSuccess, () => context.go('/nfc/demo')),
              _QuickBtn(Icons.qr_code_scanner_rounded, 'QR Scan', kAccent, () => context.go('/qr/demo')),
              _QuickBtn(Icons.qr_code_rounded, 'PromptPay', kPrimary, () => context.go('/promptpay?amount=1000&bookingId=demo')),
              _QuickBtn(Icons.credit_card_rounded, 'บัตรประชาชน', kSecondary, () => context.go('/national-id/demo')),
              _QuickBtn(Icons.bar_chart_rounded, 'รายงาน', kError, () => context.go('/finance')),
              _QuickBtn(Icons.history_rounded, 'ประวัติ', kTextMed, () => context.go('/payments')),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildBottomNav(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: kSurface,
      border: Border(top: BorderSide(color: kDivider)),
    ),
    child: BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: kPrimary,
      unselectedItemColor: kTextLow,
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (i) {
        switch (i) {
          case 0: context.go('/home'); break;
          case 1: context.go('/cars'); break;
          case 2: context.go('/bookings'); break;
          case 3: context.go('/settings'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'หน้าหลัก'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_car_rounded), label: 'รถ'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'การจอง'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'โปรไฟล์'),
      ],
    ),
  );
}

class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(value, style: kHead(16, color: color)),
          const SizedBox(height: 2),
          Text(label, style: kBody(11, color: kTextMed)),
        ],
      ),
    ),
  );
}

class _QuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickBtn(this.icon, this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: kBody(11, color: color, w: FontWeight.w600)),
        ],
      ),
    ),
  );
}
