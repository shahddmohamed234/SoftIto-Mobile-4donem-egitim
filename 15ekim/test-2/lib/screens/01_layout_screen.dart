import 'package:flutter/material.dart';

class LayoutStylingScreen extends StatefulWidget {
  const LayoutStylingScreen({super.key});

  @override
  State<LayoutStylingScreen> createState() => _LayoutStylingScreenState();
}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> {
  bool _isBalanceVisible = true;
  String _lastAction = "Hazır- Butonlara Tıklayabilirsiniz";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //.Profil online rozeti;
          _buildProfileHeader(),
          //Cüzdan Kartı
          _buildWalletCard(),
          //aksiyon butonları
          _buildQuickActions(),
          //istatislik bölümü
          _buildFlexStatistics(),
          //notification bildirim banner
          _buildNotficationBanner(),

          //Canlı Durum Bildirimi
          Center(
              child: Padding(padding: const EdgeInsets.all(16.0),
                child: Text('Son İşlem : $_lastAction',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontStyle: FontStyle.italic)))),
             
        ],
      ),
    );
  }







  Widget _buildProfileHeader(){
    return Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child:Row(children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:  const Color(0x1F6366F1),
              border: Border.all(color: const Color(0xFF6366F1),width:2),
            ),
          )
        ],
      )
    ],),
    );
  }

  // 1. Cüzdan Kartı Widget'ı
  Widget _buildWalletCard() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Toplam Bakiye',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              IconButton(
                icon: Icon(
                  _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                    _lastAction = _isBalanceVisible
                        ? "Bakiye görünür yapıldı"
                        : "Bakiye gizlendi";
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isBalanceVisible ? '₺ 24.500,00' : '₺ •••••••',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Hızlı Aksiyon Butonları
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.send, "Gönder", "Para Gönderme Seçildi"),
          _buildActionButton(Icons.download, "Al", "Para Alma Seçildi"),
          _buildActionButton(Icons.qr_code, "QR Öde", "QR Kod Ödeme Seçildi"),
          _buildActionButton(Icons.more_horiz, "Daha Fazla", "Menü Açıldı"),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, String actionText) {
    return InkWell(
      onTap: () {
        setState(() {
          _lastAction = actionText;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 3. İstatistik Bölümü (Row, Expanded ve Flex kullanımı)
  Widget _buildFlexStatistics() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_downward, color: Colors.green),
                  SizedBox(height: 8),
                  Text("Aylık Gelir", style: TextStyle(color: Colors.grey)),
                  Text("₺ 15.200", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_upward, color: Colors.red),
                  SizedBox(height: 8),
                  Text("Aylık Gider", style: TextStyle(color: Colors.grey)),
                  Text("₺ 4.350", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Bildirim Banner'ı
  Widget _buildNotficationBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Profil bilgilerinizi güncellemeniz gerekmektedir.",
              style: TextStyle(color: Colors.orange.shade900, fontSize: 13),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            color: Colors.orange.shade700,
            onPressed: () {
              setState(() {
                _lastAction = "Bildirim detayına gidildi";
              });
            },
          )
        ],
      ),
    );
  }
}


