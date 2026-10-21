# Teknik Beceriler ve Uygulama Mimarisi (skills.md)

Bu doküman, Full Concentrate projesinin Flutter ile Clean Architecture ve SOLID prensiplerine uygun olarak nasıl geliştirileceğini ve temel algoritmaların (çıkış engeli, JSON veri yönetimi, dinamik süre hesabı) nasıl kurgulandığını gösterir.

## 1. Yerel Veri Yönetimi (JSON I/O)
Backend veya harici bir API kullanılmayacağı için veriler `path_provider` ile cihazda JSON formatında tutulacaktır. 

```dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonStorageService {
  Future<File> _getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName.json');
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final file = await _getFile('tasks');
    final String jsonString = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  Future<List<TaskModel>> loadTasks() async {
    final file = await _getFile('tasks');
    
    if (await file.exists()) {
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonResponse = jsonDecode(jsonString);
      return jsonResponse.map((data) => TaskModel.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}
```

## 2. Uygulamadan Çıkış Engeli ve Kırmızı Uyarı Sistemi
Kullanıcının pomodoro seansı sırasında uygulamayı arka plana atmasını yakalamak için WidgetsBindingObserver kullanılır. İhlal durumunda kırmızı uyarı (#E63946) tetiklenir.

```dart
class PomodoroSession extends StatefulWidget {
  @override
  _PomodoroSessionState createState() => _PomodoroSessionState();
}

class _PomodoroSessionState extends State<PomodoroSession> with WidgetsBindingObserver {
  bool isSessionActive = true;
  bool isViolationDetected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (isSessionActive) {
      if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
        setState(() {
          isViolationDetected = true;
          // Sayaç burada durdurulabilir veya odaklanma cezası kaydedilebilir
        });
      }
    }
  }
  
  Widget buildWarningMessage() {
    if (isViolationDetected) {
      return const Text(
        "UYARI: Uygulamadan çıktınız ve odaklanma seansını böldünüz!",
        style: TextStyle(
          color: Color(0xFFE63946), // İhlal kırmızısı
          fontSize: 16, 
          fontWeight: FontWeight.bold
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
```

## 3. Dinamik Mola Süresi Hesaplama (Equation)
Öğrencinin belirlediği çalışma süresine göre (en az 25 dk) mola süresini otomatik ve orantılı olarak hesaplayan algoritma.   

```dart
int calculateBreakDuration(int workDurationInMinutes) {
  int baseWork = 25;
  int baseBreak = 5;
  
  if (workDurationInMinutes >= baseWork) {
    // Her 25 dakika için 5 dakika mola eklenir. (Örn: 50 dk için 10 dk mola)
    double multiplier = workDurationInMinutes / baseWork;
    return (baseBreak * multiplier).round();
  } else {
    // Uygulama kuralları gereği minimum 25 dakika zorunludur.
    // Olası bir hata durumunda varsayılan olarak 5 döner.
    return baseBreak;
  }
}
```

## 4. Tema ve Renk Konfigürasyonu (ThemeData)
Uygulama arayüzünde yeşil tonlardan kaçınılmış; bordo, gül kurusu ve pudra gibi sıcak renkler merkeze alınmıştır. Tema ayarları inline stil vermek yerine doğrudan uygulamanın ThemeData kökünde tanımlanmıştır.
```dart
final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFF8EDEB), // Açık pudra zemin[cite: 3]
  primaryColor: const Color(0xFF721C24), // Koyu Bordo
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF721C24),
    secondary: Color(0xFFB56576), // Gül kurusu / Koyu Pembe
    error: Color(0xFFE63946), // Çıkış engeli uyarı kırmızısı
    surfaceTint: Color(0xFFE9C46A), // Sarı bilgilendirme yazısı[cite: 1]
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF2D2327)), // Koyu antrasit metin
  ),
);
```
