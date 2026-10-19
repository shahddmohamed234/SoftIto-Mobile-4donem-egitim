# Reaktif State Yönetimi ve Veri Akış Kılavuzu (State Flow Reference)

Bu döküman, **Susadım** fitness ve su takip uygulamasında uygulanan `ValueNotifier` tabanlı reaktif mimarinin, veri akış kurallarının ve yaşam döngüsü standartlarının bağlayıcı referansıdır.

---

## 1. Mimari Felsefe ve Kırmızı Çizgiler

Flutter ekosisteminde harici ağır paketler (Bloc, MobX, Redux vb.) eklemek yerine, projemizin temel ilkeleri doğrultusunda **Flutter'ın yerel çekirdek API'leri (`ValueNotifier` ve `ValueListenableBuilder`)** tercih edilmiştir.

### Temel Prensipler:
1. **Sıfır Ağır Harici Bağımlılık:** Harici paket yükü olmadan hafif, hızlı ve yüksek performanslı çalışma.
2. **Sayfa Düzeyinde `setState` Yasağı:** Ekranın tamamını yeniden çizdiren kontrolsüz `setState` çağrıları kesinlikle yasaktır. Sadece yerel görsel durumlar (örneğin ufak buton animasyonları) için dar kapsamlı `StatefulWidget` kabul edilir.
3. **İzole Yeniden Çizim (Selective Rebuild):** Yalnızca değeri değişen veri alanını dinleyen `ValueListenableBuilder` alt ağacı yeniden çizilir; ekranın geri kalanı `const` widget olarak sabit kalır.
4. **İmmutable (Değiştirilemez) Durum Mimarisi:** State nesneleri `final` alanlardan oluşur; değişiklikler doğrudan mutasyonla değil, `copyWith` metodu üzerinden yeni bir kopya oluşturularak gerçekleştirilir.

---

## 2. Reaktif Veri Akış Şeması (Data Flow)

Aşağıdaki şema, kullanıcı etkileşiminden arayüzün izole olarak güncellenmesine kadar geçen tam döngüyü özetler:

```mermaid
flowchart TD
    subgraph UI_Katmani ["Arayüz Katmanı (Views & Widgets)"]
        UserAction["Kullanıcı Etkileşimi (Örn: +250 ml Butonu)"]
        Screen["Screen / View (Stateless / Const)"]
        VLB["ValueListenableBuilder<WaterTrackerState>"]
        SpecificCard["WaterProgressCard (İzole Rebuild)"]
        StaticWidgets["LogoHeader, Navigation vb. (Rebuild Olmaz - const)"]
    end

    subgraph Controller_Katmani ["İş Mantığı Katmanı (Controller)"]
        Controller["WaterTrackerController"]
        Method["addWater(250)"]
        StateNotifier["ValueNotifier<WaterTrackerState>"]
    end

    subgraph Model_Katmani ["Veri Katmanı (Immutable Model)"]
        CurrentState["Current State (consumedMl: 1000)"]
        CopyWith["state.copyWith(consumedMl: 1250)"]
        NewState["New State (consumedMl: 1250)"]
    end

    UserAction -->|Tıklama Tetiklenir| Method
    Method -->|Mevcut Durumu Oku| CurrentState
    CurrentState -->|Yeni Durum Oluştur| CopyWith
    CopyWith -->|Atama Yapılır| NewState
    NewState -->|state.value = NewState| StateNotifier
    StateNotifier -->|Değişikliği Bildirir (Notify)| VLB
    VLB -->|Yalnızca İlgili Kartı Çizer| SpecificCard
    StaticWidgets -.->|Sabit Kalır (Atlanır)| Screen
```

---

## 3. Katmanlar ve Sorumluluk Dağılımı

### 3.1 Model Katmanı (`models/`)
- Tüm modeller `immutable` olmalıdır (`final` alanlar).
- Constructor'lar mümkünse `const` olmalıdır.
- Nesnelerin klonlanarak güncellenmesi için `copyWith` metodu zorunludur.
- Veri serileştirme ve kalıcılık için `toJson` ve `fromJson` factory metotları eksiksiz uygulanmalıdır.

```dart
// Örnek Model Standardı
class WaterTrackerState {
  final int baseGoalMl;
  final int workoutBonusMl;
  final int consumedMl;
  final List<WaterLogEntry> history;

  const WaterTrackerState({
    this.baseGoalMl = 2000,
    this.workoutBonusMl = 0,
    this.consumedMl = 0,
    this.history = const [],
  });

  int get totalTargetMl => baseGoalMl + workoutBonusMl;
  double get progressRatio => totalTargetMl <= 0 ? 0.0 : (consumedMl / totalTargetMl).clamp(0.0, 1.0);

  WaterTrackerState copyWith({
    int? baseGoalMl,
    int? workoutBonusMl,
    int? consumedMl,
    List<WaterLogEntry>? history,
  }) {
    return WaterTrackerState(
      baseGoalMl: baseGoalMl ?? this.baseGoalMl,
      workoutBonusMl: workoutBonusMl ?? this.workoutBonusMl,
      consumedMl: consumedMl ?? this.consumedMl,
      history: history ?? this.history,
    );
  }
}
```

### 3.2 Controller Katmanı (`controllers/`)
- Durum değişkenleri `final ValueNotifier<T>` olarak tanımlanır.
- UI bileşenleri state'i doğrudan mutate edemez; tüm mutasyonlar controller metotları üzerinden yürütülür.
- Controller yaşam döngüsü sonlandığında bellek sızıntısını (memory leak) önlemek için `dispose()` metodu zorunludur.

```dart
class WaterTrackerController {
  final ValueNotifier<WaterTrackerState> state = ValueNotifier<WaterTrackerState>(
    const WaterTrackerState(),
  );

  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    final current = state.value;
    state.value = current.copyWith(
      consumedMl: current.consumedMl + amountMl,
    );
  }

  void dispose() {
    state.dispose();
  }
}
```

### 3.3 Arayüz Katmanı (`views/` & `widgets/`)
- **40 Satır Kuralı:** 40 satırı geçen `build` metotları kesinlikle alt widget'lara (custom widgets) parçalanmalıdır.
- **Const Kullanımı:** Değişmeyen tüm widget'larda `const` zorunludur.
- **İzole Dinleme:** Ekran genelini sarmalayan tek bir devasa dinleyici yerine, sadece değişen alanı sarmalayan atomik `ValueListenableBuilder` blokları kullanılır.

---

## 4. Modüller Arası İletişim (Cross-Feature Reactive Sync)

Uygulamada bir özelliğin durumu (örn: tamamlanan egzersizler), başka bir özelliğin durumunu (örn: içilmesi gereken su miktarı) etkileyebilir.

### Örnek: Egzersizden Su Takibine Bonus Eklenmesi
```dart
class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();

    // Reaktif Dinleyici Entegrasyonu
    _workoutController.workouts.addListener(_syncWorkoutBonus);
  }

  void _syncWorkoutBonus() {
    _waterController.updateWorkoutBonus(_workoutController.totalRecommendedWaterMl);
  }

  @override
  void dispose() {
    _workoutController.workouts.removeListener(_syncWorkoutBonus);
    _waterController.dispose();
    _workoutController.dispose();
    super.dispose();
  }
}
```

---

## 5. Çift Tema (Dark / Light) ve Global State Akışı

Tema yönetimi de aynı `ValueNotifier` prensibiyle çalışır:
- **`ThemeController`**: `ValueNotifier<ThemeMode>` barındırır.
- **`MaterialApp`**: `ValueListenableBuilder<ThemeMode>` ile dinlenir.
- Tema değiştiğinde yalnızca uygulamanın tema modu güncellenir; ekranlar `Theme.of(context)` ve `AppColors` üzerinden renkleri anında devralır.

```dart
// main.dart içerisinde
ValueListenableBuilder<ThemeMode>(
  valueListenable: ThemeController.instance.themeMode,
  builder: (context, currentMode, _) {
    return MaterialApp(
      themeMode: currentMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const WaterTrackerScreen(),
    );
  },
);
```

---

## 6. Bellek ve Yaşam Döngüsü Kontrol Listesi

1. [ ] Her `ValueNotifier` için controller'da `dispose()` çağrısı yapıldı mı?
2. [ ] `addListener` ile bağlanan dinleyiciler için `removeListener` yazıldı mı?
3. [ ] `build()` metodu içerisinde yeni bir `ValueNotifier` örneği yaratılmasından kaçınıldı mı?
4. [ ] `ValueListenableBuilder`'da widget ağacını gereksiz yere büyük sarmalayan bloklar var mı?
5. [ ] `flutter analyze` 0 hata ve 0 uyarı veriyor mu?
