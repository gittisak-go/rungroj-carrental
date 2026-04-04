import 'package:cloud_firestore/cloud_firestore.dart';

class CarModel {
  final String id;
  final String ownerId;
  final String brand;
  final String model;
  final String plateNumber;
  final String fuelType;
  final String transmission;
  final int seats;
  final double pricePerDay;
  final String status; // available | rented | maintenance
  final List<String> imageUrls;
  final bool isActive;
  final DateTime createdAt;

  const CarModel({
    required this.id,
    required this.ownerId,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.fuelType,
    required this.transmission,
    required this.seats,
    required this.pricePerDay,
    required this.status,
    required this.imageUrls,
    required this.isActive,
    required this.createdAt,
  });

  factory CarModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CarModel(
      id: doc.id,
      ownerId: d['ownerId'] ?? '',
      brand: d['brand'] ?? '',
      model: d['model'] ?? '',
      plateNumber: d['plateNumber'] ?? '',
      fuelType: d['fuelType'] ?? 'เบนซิน',
      transmission: d['transmission'] ?? 'เกียร์อัตโนมัติ',
      seats: (d['seats'] ?? 4) as int,
      pricePerDay: (d['pricePerDay'] ?? 0).toDouble(),
      status: d['status'] ?? 'available',
      imageUrls: List<String>.from(d['imageUrls'] ?? []),
      isActive: d['isActive'] ?? true,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'ownerId': ownerId, 'brand': brand, 'model': model,
    'plateNumber': plateNumber, 'fuelType': fuelType,
    'transmission': transmission, 'seats': seats,
    'pricePerDay': pricePerDay, 'status': status,
    'imageUrls': imageUrls, 'isActive': isActive,
    'createdAt': FieldValue.serverTimestamp(),
  };

  String get displayName => '$brand $model';
  bool get isAvailable => status == 'available';
  String get statusLabel {
    switch (status) {
      case 'available': return 'ว่าง';
      case 'rented': return 'ถูกเช่า';
      case 'maintenance': return 'ซ่อมบำรุง';
      default: return status;
    }
  }
}

class BookingModel {
  final String id;
  final String carId;
  final String carName;
  final String carImageUrl;
  final String renterId;
  final String renterName;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String status; // pending|confirmed|active|completed|cancelled
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.carId,
    required this.carName,
    required this.carImageUrl,
    required this.renterId,
    required this.renterName,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      carId: d['carId'] ?? '',
      carName: d['carName'] ?? '',
      carImageUrl: d['carImageUrl'] ?? '',
      renterId: d['renterId'] ?? '',
      renterName: d['renterName'] ?? '',
      ownerId: d['ownerId'] ?? '',
      startDate: (d['startDate'] as Timestamp).toDate(),
      endDate: (d['endDate'] as Timestamp).toDate(),
      totalPrice: (d['totalPrice'] ?? 0).toDouble(),
      status: d['status'] ?? 'pending',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  int get days => endDate.difference(startDate).inDays;

  String get statusLabel {
    switch (status) {
      case 'pending': return 'รอยืนยัน';
      case 'confirmed': return 'ยืนยันแล้ว';
      case 'active': return 'กำลังเช่า';
      case 'completed': return 'เสร็จสิ้น';
      case 'cancelled': return 'ยกเลิก';
      default: return status;
    }
  }
}
