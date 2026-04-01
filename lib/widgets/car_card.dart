import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CarCard extends StatelessWidget {
  final Map<String, dynamic> car;
  final VoidCallback onTap;
  const CarCard({super.key, required this.car, required this.onTap});

  Color get _statusColor {
    switch (car['status']) {
      case 'available': return kSuccess;
      case 'rented': return kAccent;
      default: return kTextMed;
    }
  }

  String get _statusLabel {
    switch (car['status']) {
      case 'available': return 'ว่าง';
      case 'rented': return 'ถูกเช่า';
      default: return 'ซ่อมบำรุง';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kDivider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    color: kSurface2,
                    child: car['img'] != ''
                        ? Image.network(car['img'] as String, fit: BoxFit.cover)
                        : const Center(
                            child: Icon(Icons.directions_car_rounded, size: 64, color: kDivider),
                          ),
                  ),
                  // Status badge
                  Positioned(
                    top: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _statusColor.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6, height: 6,
                            decoration: BoxDecoration(color: _statusColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 5),
                          Text(_statusLabel, style: kBody(11, color: _statusColor, w: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${car['brand']} ${car['model']}', style: kHead(16)),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '฿${(car['price'] as double).toStringAsFixed(0)}',
                              style: kHead(18, color: kPrimary),
                            ),
                            TextSpan(text: '/วัน', style: kBody(12, color: kTextMed)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Chip(Icons.people_rounded, '${car['seats']} ที่นั่ง'),
                      const SizedBox(width: 8),
                      _Chip(Icons.local_gas_station_rounded, car['fuel'] as String),
                      const SizedBox(width: 8),
                      _Chip(Icons.settings_rounded, 'ออโต้'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: kBackground,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: kTextMed),
        const SizedBox(width: 4),
        Text(label, style: kBody(11, color: kTextMed)),
      ],
    ),
  );
}
