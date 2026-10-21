// Flutter ve test kütüphanelerini içeri aktarır
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rent/features/home/data/models/car_model.dart';
import 'package:easy_rent/features/home/presentation/controllers/home_controller.dart';
import 'package:easy_rent/features/reservations/data/models/reservation_model.dart';

void main() {
  group('Kiralama ve Fiyat Hesaplama Testleri', () {
    const testCar = CarModel(
      id: 'car_test',
      brand: 'Renault',
      model: 'Clio 1.0 TCe',
      year: '2024',
      fuelType: 'Benzin',
      transmission: 'Otomatik',
      seats: 5,
      dailyRate: 1000,
      weeklyRate: 6300, // Günlüğü 900 TL'ye denk gelir
      monthlyRate: 24000, // Günlüğü 800 TL'ye denk gelir
      isAvailable: true,
      stationName: 'Test İstasyonu',
    );

    test('Günlük tarifede gün sayısı ile günlük ücret doğru çarpılmalıdır', () {
      expect(testCar.calculateTotal(type: PricingType.daily, days: 1), 1000.0);
      expect(testCar.calculateTotal(type: PricingType.daily, days: 3), 3000.0);
      expect(testCar.calculateTotal(type: PricingType.daily, days: 5), 5000.0);
    });

    test('Haftalık tarifede 7 gün tam paket ücreti olmalıdır', () {
      expect(testCar.calculateTotal(type: PricingType.weekly, days: 7), 6300.0);
    });

    test('Haftalık tarifede 7 günden az seçim yapılırsa müşteri aleyhine yüksek tutar çıkmamalıdır', () {
      // 3 gün kiralama haftalık seçilse dahi günlük bazdan hesaplanmalı (3 x 1000 = 3000)
      expect(testCar.calculateTotal(type: PricingType.weekly, days: 3), 3000.0);
    });

    test('Haftalık tarifede artık günler haftalık birim fiyattan doğru hesaplanmalıdır', () {
      // 8 gün: 1 hafta (6300) + 1 gün (6300 / 7 = 900) = 7200
      expect(testCar.calculateTotal(type: PricingType.weekly, days: 8), 7200.0);
      // 10 gün: 1 hafta (6300) + 3 gün (3 x 900 = 2700) = 9000
      expect(testCar.calculateTotal(type: PricingType.weekly, days: 10), 9000.0);
    });

    test('Aylık tarifede 30 gün tam aylık paket ücreti olmalıdır', () {
      expect(testCar.calculateTotal(type: PricingType.monthly, days: 30), 24000.0);
    });

    test('Aylık tarifede 30 günden fazla kiralama aylık birim fiyattan orantılı hesaplanmalıdır', () {
      // 35 gün: 1 ay (24000) + 5 gün (5 x 800 = 4000) = 28000
      expect(testCar.calculateTotal(type: PricingType.monthly, days: 35), 28000.0);
    });

    test('Aylık tarifede 30 günden az seçim yapılırsa orantılı/haftalık hesaplanmalıdır', () {
      // 10 gün aylık seçilirse haftalık mantığına düşmeli: 1 hafta (6300) + 3 x 900 = 9000
      expect(testCar.calculateTotal(type: PricingType.monthly, days: 10), 9000.0);
      // 2 gün seçilirse günlük mantığına düşmeli: 2 x 1000 = 2000
      expect(testCar.calculateTotal(type: PricingType.monthly, days: 2), 2000.0);
    });
  });

  group('HomeController Tarih ve Tarife Senkronizasyonu Testleri', () {
    late HomeController controller;

    setUp(() {
      controller = HomeController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Aynı gün seçildiğinde rentalDays en az 1 gün dönmelidir', () {
      final today = DateTime.now();
      controller.setDateRange(DateTimeRange(start: today, end: today));
      expect(controller.rentalDays, 1);
    });

    test('Takvimden 3 gün seçildiğinde tarife otomatik olarak Günlük olmalıdır', () {
      final start = DateTime(2026, 5, 1);
      final end = DateTime(2026, 5, 4);
      controller.setDateRange(DateTimeRange(start: start, end: end));

      expect(controller.rentalDays, 3);
      expect(controller.pricingType.value, PricingType.daily);
    });

    test('Takvimden 10 gün seçildiğinde tarife otomatik olarak Haftalık olmalıdır', () {
      final start = DateTime(2026, 5, 1);
      final end = DateTime(2026, 5, 11);
      controller.setDateRange(DateTimeRange(start: start, end: end));

      expect(controller.rentalDays, 10);
      expect(controller.pricingType.value, PricingType.weekly);
    });

    test('Takvimden 35 gün seçildiğinde tarife otomatik olarak Aylık olmalıdır', () {
      final start = DateTime(2026, 5, 1);
      final end = DateTime(2026, 6, 5);
      controller.setDateRange(DateTimeRange(start: start, end: end));

      expect(controller.rentalDays, 35);
      expect(controller.pricingType.value, PricingType.monthly);
    });

    test('Aylık tarifeden sonra tekrar 3 gün seçilirse tarife Günlük moduna geri dönmelidir', () {
      // Önce 35 gün seçip aylık yap
      controller.setDateRange(
        DateTimeRange(start: DateTime(2026, 5, 1), end: DateTime(2026, 6, 5)),
      );
      expect(controller.pricingType.value, PricingType.monthly);

      // Sonra tarihi 3 güne düşür
      controller.setDateRange(
        DateTimeRange(start: DateTime(2026, 5, 1), end: DateTime(2026, 5, 4)),
      );
      expect(controller.rentalDays, 3);
      // BUG FIX: Tarife aylıkta takılı kalmamalı, günlüğe dönmelidir!
      expect(controller.pricingType.value, PricingType.daily);
    });

    test('Kullanıcı Haftalık tarifeye tıkladığında gün sayısı en az 7 olmalıdır', () {
      controller.setDateRange(
        DateTimeRange(start: DateTime(2026, 5, 1), end: DateTime(2026, 5, 3)),
      );
      controller.setPricingType(PricingType.weekly);

      expect(controller.pricingType.value, PricingType.weekly);
      expect(controller.rentalDays, 7);
    });

    test('Kullanıcı Aylık tarifeye tıkladığında gün sayısı en az 30 olmalıdır', () {
      controller.setDateRange(
        DateTimeRange(start: DateTime(2026, 5, 1), end: DateTime(2026, 5, 3)),
      );
      controller.setPricingType(PricingType.monthly);

      expect(controller.pricingType.value, PricingType.monthly);
      expect(controller.rentalDays, 30);
    });
  });

  group('Rezervasyon ve Süre Uzatma Hesaplama Testleri', () {
    test('Rezervasyon modeli aracın kendi günlük birim fiyatını korumalıdır', () {
      final rez = ReservationModel(
        id: 'REZ-TEST',
        carModel: 'BMW 320i M Sport',
        stationName: 'Kadıköy',
        startDate: DateTime(2026, 5, 1),
        endDate: DateTime(2026, 5, 4),
        status: ReservationStatus.active,
        totalAmount: 10800.0,
        dailyRate: 3600.0,
      );

      expect(rez.dailyRate, 3600.0);
      // 2 gün uzatma bedeli: 2 x 3600 = 7200 olmalıdır
      final extraCost = 2 * rez.dailyRate;
      expect(extraCost, 7200.0);
    });
  });
}
