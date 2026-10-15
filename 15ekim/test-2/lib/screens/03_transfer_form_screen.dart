import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key});
  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  double balance = 148950.00;

  final List<TransactionItem> _history = [
    const TransactionItem(
      id: "tx_init_1",
      title: 'Ahmet Yılmaz',
      category: 'Hızlı Transfer',
      date: 'bugün 11.30',
      amount: 1500.00,
      isExpense: true,
      icon: Icons.send,
    ),
    const TransactionItem(
      id: "tx_init_2",
      title: 'Merve Demir ',
      category: 'Hızlı Transfer',
      date: 'dün 15.45',
      amount: 2400.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
  ];


 void _openTransferModel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Klavye açıldığında formun yukarı kaymasını sağlar
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Klavye yüksekliği kadar boşluk bırakır
            left: 24,
            right: 24,
            top: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Para Gönder",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: "Alıcı IBAN veya İsim",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Tutar (₺)",
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Transfer işlemi tamamlandıktan sonra modalı kapat
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Gönder", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  // Sınıfın hata vermemesi için zorunlu olan build metodunu da ekliyoruz:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transferler"),
      ),
      body: Column(
        children: [
          // Bakiye ve Buton Alanı
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text("Kullanılabilir Bakiye", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  "₺$balance",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _openTransferModel, // Modalı açan fonksiyonu çağırdık
                  icon: const Icon(Icons.send),
                  label: const Text("Yeni Transfer"),
                ),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Geçmiş Transferler",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Liste Alanı
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final tx = _history[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(tx.icon, color: Colors.blue.shade700),
                  ),
                  title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${tx.category} - ${tx.date}"),
                  trailing: Text(
                    "- ₺${tx.amount}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

