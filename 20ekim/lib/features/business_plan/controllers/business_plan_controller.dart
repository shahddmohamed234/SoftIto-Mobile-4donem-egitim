import 'package:flutter/foundation.dart';
import '../models/business_plan_model.dart';

class BusinessPlanController {
  final ValueNotifier<List<BusinessPlanItem>> _plans =
      ValueNotifier<List<BusinessPlanItem>>([
    BusinessPlanItem(
      id: 'bp_1',
      title: 'Yapay Zeka Destekli Lojistik SaaS',
      industry: 'Yazılım / Lojistik',
      targetMarket: 'KOBİ ve E-ticaret Şirketleri',
      budget: 1500000,
      status: 'Onaylandı',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    BusinessPlanItem(
      id: 'bp_2',
      title: 'Akıllı Dikey Tarım Otomasyonu',
      industry: 'AgriTech',
      targetMarket: 'Şehir İçi Üreticiler ve Restoranlar',
      budget: 850000,
      status: 'İncelemede',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ]);

  final ValueNotifier<bool> _isProcessing = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);

  ValueNotifier<List<BusinessPlanItem>> get plans => _plans;
  ValueNotifier<bool> get isProcessing => _isProcessing;
  ValueNotifier<String?> get errorMessage => _errorMessage;

  void addPlan(BusinessPlanItem plan) {
    _plans.value = [plan, ..._plans.value];
  }

  void updatePlanStatus(String id, String newStatus) {
    _plans.value = _plans.value.map((p) {
      if (p.id == id) {
        return p.copyWith(status: newStatus);
      }
      return p;
    }).toList();
  }

  void dispose() {
    _plans.dispose();
    _isProcessing.dispose();
    _errorMessage.dispose();
  }
}
