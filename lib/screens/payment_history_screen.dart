import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  static const _payments = [
    {'renter': 'สมชาย ใจดี', 'car': 'Toyota Yaris', 'amount': '1,950', 'date': '24 มี.ค. 2567', 'method': 'โอนเงิน', 'status': 'paid'},
    {'renter': 'วิภา รักดี', 'car': 'Honda City', 'amount': '1,500', 'date': '22 มี.ค. 2567', 'method': 'พร้อมเพย์', 'status': 'paid'},
    {'renter': 'ธนพล มีสุข', 'car': 'MG ZS EV', 'amount': '6,000', 'date': '20 มี.ค. 2567', 'method': 'บัตรเครดิต', 'status': 'pending'},
    {'renter': 'อรุณ สว่างใจ', 'car': 'Fortuner', 'amount': '8,800', 'date': '15 มี.ค. 2567', 'method': 'โอนเงิน', 'status': 'paid'},
    {'renter': 'มานี มีนา', 'car': 'Camry Hybrid', 'amount': '5,400', 'date': '10 มี.ค. 2567', 'method': 'พร้อมเพย์', 'status': 'paid'},
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
                  GestureDetector(onTap: () => context.pop(), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_rounded, color: kTextHigh, size: 20))),
                  const SizedBox(width: 16),
                  Text('ประวัติการชำระเงิน', style: kHead(22)),
                ],
              ),
            ),
            // Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('รายรับเดือนนี้', style: kBody(13, color: Colors.white70)),
                      Text('฿23,650', style: kHead(28, color: Colors.white)),
                    ]),
                    Column(children: [
                      Text('5 รายการ', style: kBody(13, color: Colors.white70)),
                      Text('ชำระแล้ว 4', style: kBody(13, color: Colors.white70)),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('รายการทั้งหมด', style: kHead(18))),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _payments.length,
                itemBuilder: (_, i) {
                  final p = _payments[i];
                  final isPaid = p['status'] == 'paid';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: kDivider)),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: isPaid ? kSuccess.withOpacity(0.1) : kAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(isPaid ? Icons.check_circle_rounded : Icons.access_time_rounded, color: isPaid ? kSuccess : kAccent, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(p['renter']!, style: kHead(14)),
                            Text('${p['car']} · ${p['method']}', style: kBody(12, color: kTextMed)),
                            Text(p['date']!, style: kBody(11, color: kTextLow)),
                          ]),
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text('฿${p['amount']}', style: kHead(15, color: isPaid ? kSuccess : kAccent)),
                          Text(isPaid ? 'ชำระแล้ว' : 'รอชำระ', style: kBody(11, color: isPaid ? kSuccess : kAccent)),
                        ]),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
