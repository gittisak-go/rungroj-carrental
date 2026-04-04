import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class FinancialReportsScreen extends StatefulWidget {
  const FinancialReportsScreen({super.key});
  @override
  State<FinancialReportsScreen> createState() => _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends State<FinancialReportsScreen> {
  String _period = 'เดือนนี้';
  final _periods = ['สัปดาห์นี้', 'เดือนนี้', '3 เดือน', '6 เดือน', 'ปีนี้'];

  final _monthlyData = [
    {'month': 'ต.ค.', 'revenue': 98000.0, 'expense': 22000.0},
    {'month': 'พ.ย.', 'revenue': 105000.0, 'expense': 19000.0},
    {'month': 'ธ.ค.', 'revenue': 142000.0, 'expense': 28000.0},
    {'month': 'ม.ค.', 'revenue': 114000.0, 'expense': 21000.0},
    {'month': 'ก.พ.', 'revenue': 119000.0, 'expense': 23000.0},
    {'month': 'มี.ค.', 'revenue': 128400.0, 'expense': 24000.0},
  ];

  double get _maxRev => _monthlyData.map((m) => m['revenue'] as double).reduce((a, b) => a > b ? a : b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildSummaryCards()),
            SliverToBoxAdapter(child: _buildPeriodSelector()),
            SliverToBoxAdapter(child: _buildBarChart()),
            SliverToBoxAdapter(child: _buildExpenseBreakdown()),
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
          onTap: () => context.pop(),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_rounded, color: kTextHigh, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Text('รายงานการเงิน', style: kHead(22)),
      ],
    ),
  );

  Widget _buildSummaryCards() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Row(
          children: [
            _SummaryCard(label: 'รายรับรวม', value: '฿128,400', sub: '+12.4% จากเดือนก่อน', color: kPrimary),
            const SizedBox(width: 12),
            _SummaryCard(label: 'ค่าใช้จ่าย', value: '฿24,000', sub: '-4.2% จากเดือนก่อน', color: kError),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _SummaryCard(label: 'กำไรสุทธิ', value: '฿104,400', sub: 'อัตรากำไร 81%', color: kSuccess),
            const SizedBox(width: 12),
            _SummaryCard(label: 'การจองทั้งหมด', value: '48 ครั้ง', sub: 'เฉลี่ย 1.6 ครั้ง/วัน', color: kSecondary),
          ],
        ),
      ],
    ),
  );

  Widget _buildPeriodSelector() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ภาพรวมรายรับ', style: kHead(18)),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _periods.length,
            itemBuilder: (_, i) {
              final sel = _period == _periods[i];
              return GestureDetector(
                onTap: () => setState(() => _period = _periods[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: sel ? kPrimary : kSurface,
                    borderRadius: BorderRadius.circular(18),
                    border: sel ? null : Border.all(color: kDivider),
                  ),
                  child: Text(_periods[i], style: kBody(13, color: sel ? Colors.white : kTextMed, w: FontWeight.w600)),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );

  Widget _buildBarChart() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(20), border: Border.all(color: kDivider)),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _monthlyData.map((m) {
                final rev = m['revenue'] as double;
                final exp = m['expense'] as double;
                final revH = (rev / _maxRev) * 160;
                final expH = (exp / _maxRev) * 160;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _Bar(height: revH, color: kPrimary),
                        const SizedBox(width: 3),
                        _Bar(height: expH, color: kError.withOpacity(0.6)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(m['month'] as String, style: kBody(10, color: kTextMed)),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(color: kPrimary, label: 'รายรับ'),
              const SizedBox(width: 20),
              _Legend(color: kError.withOpacity(0.6), label: 'ค่าใช้จ่าย'),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildExpenseBreakdown() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ค่าใช้จ่ายแยกประเภท', style: kHead(18)),
        const SizedBox(height: 14),
        _ExpenseRow('ค่าซ่อมบำรุง', 12000, 24000, kError),
        _ExpenseRow('ค่าประกันภัย', 6000, 24000, kAccent),
        _ExpenseRow('ค่าน้ำมัน', 4000, 24000, kSecondary),
        _ExpenseRow('ค่าใช้จ่ายอื่นๆ', 2000, 24000, kTextMed),
      ],
    ),
  );
}

class _SummaryCard extends StatelessWidget {
  final String label, value, sub;
  final Color color;
  const _SummaryCard({required this.label, required this.value, required this.sub, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kBody(12, color: kTextMed)),
          const SizedBox(height: 6),
          Text(value, style: kHead(18, color: color)),
          const SizedBox(height: 4),
          Text(sub, style: kBody(10, color: kTextLow)),
        ],
      ),
    ),
  );
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;
  const _Bar({required this.height, required this.color});
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 600),
    width: 14, height: height,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
  );
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 6),
      Text(label, style: kBody(12, color: kTextMed)),
    ],
  );
}

class _ExpenseRow extends StatelessWidget {
  final String label;
  final double amount, total;
  final Color color;
  const _ExpenseRow(this.label, this.amount, this.total, this.color);
  @override
  Widget build(BuildContext context) {
    final pct = amount / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: kBody(14, color: kTextMed)),
              Text('฿${amount.toStringAsFixed(0)}', style: kHead(14, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct, minHeight: 6,
              backgroundColor: kDivider,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
