import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/dsl_colors.dart';

/// Page 8: Financial Reports — Simple charts showing monthly income and expenses
class FinancialReportsScreen extends StatefulWidget {
  const FinancialReportsScreen({super.key});

  @override
  State<FinancialReportsScreen> createState() =>
      _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends State<FinancialReportsScreen> {
  int _touchedPieIndex = -1;

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รายงานการเงิน',
                        style: GoogleFonts.urbanist(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: DslColors.primaryText,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'อัปเดตล่าสุด: 24 ต.ค. 2566',
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: DslColors.secondaryText,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: DslColors.surface,
                      borderRadius: BorderRadius.circular(DslColors.radiusMd),
                      border: Border.all(color: DslColors.divider),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x260066FF),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.analytics_rounded,
                        color: DslColors.primary, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Stat cards
              Row(
                children: [
                  Expanded(
                    child: _StatisticCard(
                      label: 'รายได้รวม',
                      value: '฿435,750',
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: DslColors.success,
                      icon: Icons.payments_rounded,
                      trendText: '+12%',
                      trendUp: true,
                    ),
                  ),
                  const SizedBox(width: DslColors.spacingMd),
                  Expanded(
                    child: _StatisticCard(
                      label: 'ค่าใช้จ่ายรวม',
                      value: '฿89,200',
                      iconBg: const Color(0xFFFFEBEE),
                      iconColor: DslColors.error,
                      icon: Icons.money_off_rounded,
                      trendText: '-3%',
                      trendUp: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingMd),
              // Net profit card
              Container(
                padding: const EdgeInsets.all(DslColors.spacingMd),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0066FF), Color(0xFF0044CC)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(DslColors.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x260066FF),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'กำไรสุทธิ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withAlpha(180),
                          ),
                        ),
                        Text(
                          '฿346,550',
                          style: GoogleFonts.urbanist(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: DslColors.success.withAlpha(40),
                        borderRadius:
                            BorderRadius.circular(DslColors.radiusFull),
                        border: Border.all(
                            color: DslColors.success.withAlpha(80)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.trending_up_rounded,
                              color: DslColors.success, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '+79.5%',
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: DslColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Monthly income chart
              _ChartCard(
                title: 'รายได้รายเดือน',
                subtitle: 'เปรียบเทียบกับปีก่อน',
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Colors.transparent,
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
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
                              final idx = value.toInt();
                              if (idx >= 0 && idx < months.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    months[idx],
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
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 85000),
                            FlSpot(1, 92000),
                            FlSpot(2, 142500),
                            FlSpot(3, 110000),
                            FlSpot(4, 125000),
                            FlSpot(5, 132000),
                          ],
                          isCurved: true,
                          color: DslColors.primary,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: DslColors.primary.withAlpha(30),
                          ),
                        ),
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 70000),
                            FlSpot(1, 80000),
                            FlSpot(2, 95000),
                            FlSpot(3, 88000),
                            FlSpot(4, 102000),
                            FlSpot(5, 110000),
                          ],
                          isCurved: true,
                          color: DslColors.secondary.withAlpha(120),
                          barWidth: 2,
                          dashArray: [4, 4],
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                trailing: Row(
                  children: [
                    _LegendDot(color: DslColors.primary, label: 'ปี 2566'),
                    const SizedBox(width: DslColors.spacingMd),
                    _LegendDot(
                        color: DslColors.secondary.withAlpha(120),
                        label: 'ปี 2565'),
                  ],
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Expense breakdown pie
              _ChartCard(
                title: 'สัดส่วนค่าใช้จ่าย',
                subtitle: 'ประจำเดือน มี.ค. 2566',
                child: SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      pieTouchData: PieTouchData(
                        touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedPieIndex = -1;
                              return;
                            }
                            _touchedPieIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      sections: [
                        _pieSection(0, 40, DslColors.secondary, 'ซ่อมบำรุง'),
                        _pieSection(1, 25, DslColors.primary, 'ประกันภัย'),
                        _pieSection(2, 20, DslColors.success, 'ค่าน้ำมัน'),
                        _pieSection(
                            3, 15, DslColors.accent, 'ค่าดำเนินการ'),
                      ],
                    ),
                  ),
                ),
                trailing: Wrap(
                  spacing: DslColors.spacingMd,
                  runSpacing: DslColors.spacingXs,
                  children: [
                    _LegendDot(color: DslColors.secondary, label: 'ซ่อมบำรุง'),
                    _LegendDot(color: DslColors.primary, label: 'ประกันภัย'),
                    _LegendDot(color: DslColors.success, label: 'ค่าน้ำมัน'),
                    _LegendDot(color: DslColors.accent, label: 'ค่าดำเนินการ'),
                  ],
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Export button
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 18),
                label: Text(
                  'ส่งออกรายงาน PDF',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: DslColors.primary,
                  side: const BorderSide(color: DslColors.primary),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DslColors.radiusLg),
                  ),
                ),
              ),
              const SizedBox(height: DslColors.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  PieChartSectionData _pieSection(
      int idx, double value, Color color, String title) {
    final isTouched = _touchedPieIndex == idx;
    return PieChartSectionData(
      color: color,
      value: value,
      title: '$value%',
      radius: isTouched ? 60 : 50,
      titleStyle: GoogleFonts.urbanist(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String label;
  final String value;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String trendText;
  final bool trendUp;

  const _StatisticCard({
    required this.label,
    required this.value,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.trendText,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(DslColors.radiusSm),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: (trendUp ? DslColors.success : DslColors.error)
                      .withAlpha(26),
                  borderRadius: BorderRadius.circular(DslColors.radiusFull),
                ),
                child: Row(
                  children: [
                    Icon(
                      trendUp
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: trendUp ? DslColors.success : DslColors.error,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trendText,
                      style: GoogleFonts.urbanist(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: trendUp ? DslColors.success : DslColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DslColors.spacingSm),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: DslColors.primaryText,
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

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DslColors.spacingMd),
      decoration: BoxDecoration(
        color: DslColors.surface,
        borderRadius: BorderRadius.circular(DslColors.radiusMd),
        border: Border.all(color: DslColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: DslColors.primaryText,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: DslColors.secondaryText,
            ),
          ),
          const SizedBox(height: DslColors.spacingMd),
          child,
          if (trailing != null) ...[
            const SizedBox(height: DslColors.spacingMd),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: DslColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
