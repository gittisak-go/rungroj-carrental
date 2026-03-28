import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/dsl_colors.dart';

/// Page 6: Payment History — A ledger showing rent payments received and outstanding balances
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _selectedPeriod = 'เดือนนี้';
  final List<String> _periods = ['สัปดาห์นี้', 'เดือนนี้', '3 เดือน', 'ปีนี้'];

  final List<_PaymentData> _payments = [
    _PaymentData(
      tenant: 'สมชาย ใจดี',
      initials: 'ส',
      initBg: DslColors.secondary,
      car: 'Toyota Camry 2.5V',
      amount: '฿22,400',
      date: '28 มี.ค. 2026',
      method: 'โอนธนาคาร',
      status: 'ชำระแล้ว',
      isSuccess: true,
    ),
    _PaymentData(
      tenant: 'วิภา รักสะอาด',
      initials: 'ว',
      initBg: DslColors.primary,
      car: 'BMW X5 M Sport',
      amount: '฿41,300',
      date: '27 มี.ค. 2026',
      method: 'บัตรเครดิต',
      status: 'ชำระแล้ว',
      isSuccess: true,
    ),
    _PaymentData(
      tenant: 'ประเสริฐ มีทรัพย์',
      initials: 'ป',
      initBg: DslColors.accent,
      car: 'Mercedes C-Class AMG',
      amount: '฿31,500',
      date: '25 มี.ค. 2026',
      method: 'QR Code',
      status: 'ค้างชำระ',
      isSuccess: false,
    ),
    _PaymentData(
      tenant: 'อนุชา พรสวรรค์',
      initials: 'อ',
      initBg: DslColors.hint,
      car: 'Honda Accord 2.0EL',
      amount: '฿17,500',
      date: '20 มี.ค. 2026',
      method: 'โอนธนาคาร',
      status: 'ชำระแล้ว',
      isSuccess: true,
    ),
    _PaymentData(
      tenant: 'จันทร์ศรี สดใส',
      initials: 'จ',
      initBg: const Color(0xFF636366),
      car: 'Toyota Fortuner 2.8',
      amount: '฿19,500',
      date: '15 มี.ค. 2026',
      method: 'เงินสด',
      status: 'ชำระแล้ว',
      isSuccess: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DslColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DslColors.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nav header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: DslColors.surface,
                        borderRadius:
                            BorderRadius.circular(DslColors.radiusMd),
                        border: Border.all(color: DslColors.divider),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: DslColors.primaryText, size: 18),
                    ),
                  ),
                  const SizedBox(width: DslColors.spacingMd),
                  Text(
                    'ประวัติการชำระเงิน',
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: DslColors.primaryText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded,
                        color: DslColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'รับชำระแล้ว',
                      value: '฿1,245,000',
                      color: DslColors.success,
                      icon: Icons.check_circle_rounded,
                    ),
                  ),
                  const SizedBox(width: DslColors.spacingMd),
                  Expanded(
                    child: _SummaryCard(
                      label: 'ยอดค้างชำระ',
                      value: '฿84,200',
                      color: DslColors.error,
                      icon: Icons.error_outline_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Chart section
              Container(
                padding: const EdgeInsets.all(DslColors.spacingMd),
                decoration: BoxDecoration(
                  color: DslColors.surface,
                  borderRadius: BorderRadius.circular(DslColors.radiusMd),
                  border: Border.all(color: DslColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'แนวโน้มรายได้ค่าเช่า',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: DslColors.primaryText,
                                height: 1.3,
                              ),
                            ),
                            Text(
                              'ผลประกอบการรายเดือนปี 2566',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: DslColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: DslColors.surface,
                            borderRadius: BorderRadius.circular(
                                DslColors.radiusFull),
                            border: Border.all(color: DslColors.divider),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'รายเดือน',
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: DslColors.secondaryText,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down_rounded,
                                  color: DslColors.secondaryText, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DslColors.spacingLg),
                    // Bar chart using fl_chart
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          backgroundColor: Colors.transparent,
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 50000,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: DslColors.divider,
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = [
                                    'ม.ค.',
                                    'ก.พ.',
                                    'มี.ค.',
                                    'เม.ย.',
                                    'พ.ค.',
                                    'มิ.ย.'
                                  ];
                                  if (value.toInt() < months.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        months[value.toInt()],
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: DslColors.secondaryText,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                          barGroups: [
                            _barGroup(0, 95000, false),
                            _barGroup(1, 110000, false),
                            _barGroup(2, 142500, true),
                            _barGroup(3, 88000, false),
                            _barGroup(4, 125000, false),
                            _barGroup(5, 132000, false),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Filter period
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'รายการธุรกรรม',
                    style: GoogleFonts.urbanist(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: DslColors.primaryText,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _periods.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: DslColors.spacingXs),
                      itemBuilder: (context, i) {
                        final selected = _periods[i] == _selectedPeriod;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedPeriod = _periods[i]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: selected
                                  ? DslColors.primary
                                  : DslColors.surface,
                              borderRadius: BorderRadius.circular(
                                  DslColors.radiusFull),
                              border: Border.all(
                                color: selected
                                    ? DslColors.primary
                                    : DslColors.divider,
                              ),
                            ),
                            child: Text(
                              _periods[i],
                              style: GoogleFonts.urbanist(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? Colors.white
                                    : DslColors.secondaryText,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingMd),

              // Payment list
              ..._payments.map(
                (p) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: DslColors.spacingMd),
                  child: _PaymentRow(data: p),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double value, bool isHighlight) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: isHighlight ? DslColors.secondary : DslColors.primary,
          width: 18,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DslColors.spacingMd),
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: DslColors.spacingSm),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.2,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: DslColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentData {
  final String tenant;
  final String initials;
  final Color initBg;
  final String car;
  final String amount;
  final String date;
  final String method;
  final String status;
  final bool isSuccess;

  const _PaymentData({
    required this.tenant,
    required this.initials,
    required this.initBg,
    required this.car,
    required this.amount,
    required this.date,
    required this.method,
    required this.status,
    required this.isSuccess,
  });
}

class _PaymentRow extends StatelessWidget {
  final _PaymentData data;

  const _PaymentRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DslColors.spacingMd),
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: DslColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.initBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                data.initials,
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: DslColors.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.tenant,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: DslColors.primaryText,
                  ),
                ),
                Text(
                  '${data.car} • ${data.method}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: DslColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.amount,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: data.isSuccess ? DslColors.success : DslColors.error,
                ),
              ),
              Text(
                data.date,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: DslColors.hint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
