import 'package:flutter/material.dart';

// Kendi klasör yapına uygun olan importlar
import 'screens/01_layout_screen.dart';
import 'screens/02_markets_list_screen.dart'; 
import 'screens/03_transfer_form_screen.dart'; 

void main() {
  runApp(const DtmMasterApp());
}

class DtmMasterApp extends StatelessWidget {
  const DtmMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DTM Flutter Sınıfı",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      home: const LiveCanvasScreen(),
    );
  }
}

class LiveCanvasScreen extends StatefulWidget {
  const LiveCanvasScreen({super.key});

  @override
  State<LiveCanvasScreen> createState() => _LiveCanvasScreenState();
}

class _LiveCanvasScreenState extends State<LiveCanvasScreen> {
  int _currentIndex = 0;

  // Alt menüde gösterilecek ekranların listesi
  final List<Widget> _screens = [
    const LayoutStylingScreen(),
    const MarketsGridListScreen(),
    const TransferFormScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FaFC),
      appBar: AppBar(
        title: const Text(
          "DTM Canlı Arayüz",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 18, 
            color: Colors.black87
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {},
          ),
        ],
      ),
      // Seçili olan index'teki ekranı body'e yansıtıyoruz
      body: _screens[_currentIndex],
      
      // Alt Navigasyon Menüsü
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF6366F1), // Tema rengi
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Menüye tıklandığında index'i değiştir ve sayfayı yenile
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Cüzdan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
            label: 'Piyasalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_outlined),
            activeIcon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
        ],
      ),
    );
  }
}