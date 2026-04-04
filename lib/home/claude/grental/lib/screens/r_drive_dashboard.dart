import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class RDriveDashboard extends StatelessWidget {
  const RDriveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildRevenueCard()),
            SliverToBoxAdapter(child: _buildFleetGrid()),
            SliverToBoxAdapter(child: _buildQuickActions(context)),
            SliverToBoxAdapter(child: _buildRecentBookings()),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/home'),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_rounded, color: kTextHigh, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('R-Drive', style: kHead(22)),
              Text('แดชบอร์ดเจ้าของรถ', style: kBody(13, color: kTextMed)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/add'),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
        ),
      ],
    ),
  );

  Widget _buildRevenueCard() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kPrimary.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายรับเดือนนี้', style: kBody(13, color: kTextMed)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kSuccess.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('+12.4%', style: kBody(12, color: kSuccess, w: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('฿128,400', style: kHead(36, color: kPrimary)),
          const SizedBox(height: 20),
          Row(
            children: [
              _RevItem(label: 'รายรับวันนี้', value: '฿4,800', color: kAccent),
              const SizedBox(width: 24),
              _RevItem(label: 'รอรับเงิน', value: '฿12,000', color: kSecondary),
              const SizedBox(width: 24),
              _RevItem(label: 'เดือนก่อน', value: '฿114,200', color: kTextMed),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildFleetGrid() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('สถานะกองรถ', style: kHead(18)),
        const SizedBox(height: 14),
        Row(
          children: [
            _FleetCard(label: 'รถทั้งหมด', value: '5', icon: Icons.directions_car_rounded, color: kSecondary),
            const SizedBox(width: 12),
            _FleetCard(label: 'ว่าง', value: '4', icon: Icons.check_circle_rounded, color: kSuccess),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _FleetCard(label: 'ถูกเช่า', value: '1', icon: Icons.key_rounded, color: kAccent),
            const SizedBox(width: 12),
            _FleetCard(label: 'ซ่อมบำรุง', value: '0', icon: Icons.build_rounded, color: kError),
          ],
        ),
      ],
    ),
  );

  Widget _buildQuickActions(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('เมนูด่วน', style: kHead(18)),
        const SizedBox(height: 14),
        Row(
          children: [
            _ActionBtn(icon: Icons.bar_chart_rounded, label: 'รายงาน', color: kPrimary, onTap: () => context.go('/finance')),
            const SizedBox(width: 10),
            _ActionBtn(icon: Icons.receipt_long_rounded, label: 'ประวัติ', color: kSecondary, onTap: () => context.go('/payments')),
            const SizedBox(width: 10),
            _ActionBtn(icon: Icons.calendar_month_rounded, label: 'การจอง', color: kAccent, onTap: () => context.go('/bookings')),
            const SizedBox(width: 10),
            _ActionBtn(icon: Icons.grid_view_rounded, label: 'รายการรถ', color: kSuccess, onTap: () => context.go('/cars')),
          ],
        ),
      ],
    ),
  );

  Widget _buildRecentBookings() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('การจองล่าสุด', style: kHead(18)),
        const SizedBox(height: 14),
        ..._demoBookings.map((b) => _BookingRow(booking: b)),
      ],
    ),
  );

  static const _demoBookings = [
    {'name': 'สมชาย ใจดี', 'car': 'Toyota Yaris', 'days': '3 วัน', 'amount': '฿1,950', 'status': 'active'},
    {'name': 'วิภา รักดี', 'car': 'Honda City', 'days': '2 วัน', 'amount': '฿1,500', 'status': 'confirmed'},
    {'name': 'ธนพล มีสุข', 'car': 'MG ZS EV', 'days': '5 วัน', 'amount': '฿6,000', 'status': 'pending'},
  ];
}

class _RevItem extends StatelessWidget {
  final String label, value;
  final Color color;
  const _RevItem({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: kHead(15, color: color)),
      Text(label, style: kBody(11, color: kTextMed)),
    ],
  );
}

class _FleetCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _FleetCard({required this.label, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: kHead(22, color: color)),
              Text(label, style: kBody(11, color: kTextMed)),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: kDivider)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: kBody(11, color: kTextMed), textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}

class _BookingRow extends StatelessWidget {
  final Map<String, String> booking;
  const _BookingRow({required this.booking});
  Color get _color {
    switch (booking['status']) {
      case 'active': return kSuccess;
      case 'confirmed': return kSecondary;
      default: return kAccent;
    }
  }
  String get _label {
    switch (booking['status']) {
      case 'active': return 'กำลังเช่า';
      case 'confirmed': return 'ยืนยันแล้ว';
      default: return 'รอยืนยัน';
    }
  }
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: kDivider)),
    child: Row(
      children: [
        CircleAvatar(radius: 20, backgroundColor: kPrimary.withOpacity(0.15), child: Text(booking['name']![0], style: kHead(16, color: kPrimary))),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(booking['name']!, style: kHead(14)),
              Text('${booking['car']} · ${booking['days']}', style: kBody(12, color: kTextMed)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(booking['amount']!, style: kHead(14, color: kPrimary)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: _color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(_label, style: kBody(10, color: _color, w: FontWeight.w600)),
            ),
          ],
        ),
      ],
    ),
  );
}
