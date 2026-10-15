
import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/transaction_model.dart';


class MarketsGridListScreen extends StatelessWidget {
  const MarketsGridListScreen({super.key});

  static const List<Asset> assest = [
    Asset(
        symbol: 'BTC',
        name: 'Bitcoin',
        price: 67420.00,
        change24h: 4.20,
        balance: 0.4),
    Asset(
        symbol: 'ETH',
        name: 'Ethereum',
        price: 3500,
        change24h: -1.80,
        balance: 4.20),
    Asset(
        symbol: 'Sol',
        name: 'Solana',
        price: 200.00,
        change24h: 0.5,
        balance: 85.00)
  ];

  static const List<TransactionItem> transactions = [
    TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),

           TransactionItem(
        id: 'tx_2',
        title: 'Kodusta Danışmanlık Hakediş',
        category: 'Kurumsal Gelir',
        date: 'Dün 09:00',
        amount: 125000.00,
        isExpense: false,
        icon: Icons.account_balance),
    TransactionItem(
        id: 'tx_3',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
    TransactionItem(
        id: 'tx_4',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Piyasalar Başlığı
          const Text(
            "Piyasalar",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // GridView (Kripto Varlıklar)
          _buildMarketsGrid(),

          const SizedBox(height: 32),

          // Son İşlemler Başlığı
          const Text(
            "Son İşlemler",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ListView (İşlem Geçmişi)
          _buildTransactionsList(),
        ],
      ),
    );
  }

  // 1. GridView Widget'ı (Piyasalar için)
  Widget _buildMarketsGrid() {
    return GridView.builder(
      shrinkWrap: true, // SingleChildScrollView içinde düzgün çalışması için
      physics: const NeverScrollableScrollPhysics(), // Kaydırmayı ana SingleChildScrollView yapsın
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9, 
      ),
      itemCount: assest.length, // Senin yazdığın liste adı
      itemBuilder: (context, index) {
        final asset = assest[index];
        final bool isPositive = asset.change24h >= 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Text(
                      asset.symbol.substring(0, 1),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isPositive ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      Text(
                        "${asset.change24h}%",
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                asset.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${asset.balance} ${asset.symbol}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                "\$${asset.price}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  // 2. ListView Widget'ı (Son İşlemler için)
  Widget _buildTransactionsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length, // Senin yazdığın liste adı
      separatorBuilder: (context, index) => const Divider(height: 24, color: Colors.black12),
      itemBuilder: (context, index) {
        final tx = transactions[index];

        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tx.isExpense ? Colors.red.shade50 : Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                tx.icon,
                color: tx.isExpense ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${tx.category} • ${tx.date}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              tx.isExpense ? "- ₺${tx.amount}" : "+ ₺${tx.amount}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: tx.isExpense ? Colors.red : Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}