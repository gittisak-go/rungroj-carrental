// ════════════════════════════════════════════════════════════════
// active_bookings_screen.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class ActiveBookingsScreen extends StatelessWidget {
  const ActiveBookingsScreen({super.key});

  static const _bookings = [
    {'name': 'สมชาย ใจดี', 'car': 'Toyota Yaris ATIV', 'plate': 'กข-1234', 'from': '24 มี.ค. 2567', 'to': '27 มี.ค. 2567', 'amount': '฿1,950', 'status': 'active'},
    {'name': 'วิภา รักดี', 'car': 'Honda City', 'plate': 'คง-5678', 'from': '25 มี.ค. 2567', 'to': '27 มี.ค. 2567', 'amount': '฿1,500', 'status': 'confirmed'},
    {'name': 'ธนพล มีสุข', 'car': 'MG ZS EV', 'plate': 'จจ-9012', 'from': '26 มี.ค. 2567', 'to': '31 มี.ค. 2567', 'amount': '฿6,000', 'status': 'pending'},
    {'name': 'อรุณ สว่างใจ', 'car': 'Toyota Fortuner', 'plate': 'ชช-3456', 'from': '20 มี.ค. 2567', 'to': '24 มี.ค. 2567', 'amount': '฿8,800', 'status': 'completed'},
  ];

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
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(width: 40, height: 40, decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_rounded, color: kTextHigh, size: 20)),
                  ),
                  const SizedBox(width: 16),
                  Text('การจองทั้งหมด', style: kHead(22)),
                ],
              ),
            ),
            // Filter tabs
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ['ทั้งหมด', 'กำลังเช่า', 'รอยืนยัน', 'เสร็จสิ้น']
                    .map((t) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: t == 'ทั้งหมด' ? kPrimary : kSurface,
                            borderRadius: BorderRadius.circular(18),
                            border: t != 'ทั้งหมด' ? Border.all(color: kDivider) : null,
                          ),
                          child: Text(t, style: kBody(13, color: t == 'ทั้งหมด' ? Colors.white : kTextMed, w: FontWeight.w600)),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _bookings.length,
                itemBuilder: (_, i) => _BookingCard(booking: _bookings[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Map<String, String> booking;
  const _BookingCard({required this.booking});

  Color get _color {
    switch (booking['status']) {
      case 'active': return kSuccess;
      case 'confirmed': return kSecondary;
      case 'completed': return kTextMed;
      default: return kAccent;
    }
  }

  String get _label {
    switch (booking['status']) {
      case 'active': return 'กำลังเช่า';
      case 'confirmed': return 'ยืนยันแล้ว';
      case 'completed': return 'เสร็จสิ้น';
      default: return 'รอยืนยัน';
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: kDivider)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 18, backgroundColor: kPrimary.withOpacity(0.15), child: Text(booking['name']![0], style: kHead(14, color: kPrimary))),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking['name']!, style: kHead(14)),
                    Text(booking['plate']!, style: kBody(12, color: kTextMed)),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(_label, style: kBody(11, color: _color, w: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: kDivider),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.directions_car_rounded, size: 14, color: kTextMed),
            const SizedBox(width: 6),
            Text(booking['car']!, style: kBody(13, color: kTextMed)),
            const Spacer(),
            Text(booking['amount']!, style: kHead(16, color: kPrimary)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 14, color: kTextMed),
            const SizedBox(width: 6),
            Text('${booking['from']} → ${booking['to']}', style: kBody(12, color: kTextMed)),
          ],
        ),
      ],
    ),
  );
}
