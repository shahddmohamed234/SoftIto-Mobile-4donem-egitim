import 'package:flutter/material.dart';
import '../models/boulder_model.dart';

class AddClimbScreen extends StatefulWidget {
  const AddClimbScreen({super.key});

  @override
  State<AddClimbScreen> createState() => _AddClimbScreenState();
}

class _AddClimbScreenState extends State<AddClimbScreen> {
  final _formKey = GlobalKey<FormState>();

  String _secilenZorluk = 'V1';
  String _secilenRenk = 'Sarı';
  bool _isFlashed = false;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _attemptsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<String> _zorlukDereceleri = ['V0', 'V1', 'V2', 'V3', 'V4', 'V5', 'V6'];
  final List<String> _renkler = ['Sarı', 'Kırmızı', 'Mavi', 'Yeşil', 'Siyah'];

  @override
  void dispose() {
    _locationController.dispose();
    _attemptsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _kaydet() {
    if (_formKey.currentState!.validate()) {
      final yeniRota = Boulder(
        grade: _secilenZorluk,
        holdColor: _secilenRenk,
        locations: _locationController.text,
        attempts: int.parse(_attemptsController.text),
        isFlashed: _isFlashed,
        date: DateTime.now(),
        notes: _notesController.text,
      );
      Navigator.pop(context, yeniRota);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Rota Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Salon veya Konum',
                prefixIcon: const Icon(Icons.location_on_outlined), // İkon eklendi
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) => value!.isEmpty ? 'Bu alan boş bırakılamaz' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _secilenZorluk,
                    decoration: InputDecoration(
                      labelText: 'Zorluk', 
                      prefixIcon: const Icon(Icons.fitness_center_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    items: _zorlukDereceleri.map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
                    onChanged: (deger) => setState(() => _secilenZorluk = deger!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _secilenRenk,
                    decoration: InputDecoration(
                      labelText: 'Renk', 
                      prefixIcon: const Icon(Icons.color_lens_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    items: _renkler.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (deger) => setState(() => _secilenRenk = deger!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _attemptsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Kaçıncı Denemede Bitti?',
                prefixIcon: const Icon(Icons.numbers),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) => value!.isEmpty ? 'Lütfen deneme sayısını girin' : null,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text('İlk denemede (Flash) mi bitirdin?'),
                value: _isFlashed,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (deger) {
                  setState(() {
                    _isFlashed = deger;
                    if (deger) _attemptsController.text = '1';
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Aklında kalanlar (İsteğe bağlı)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _kaydet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary, // Buton rengi dolgunlaştı
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('✓ ROTAYI KAYDET', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // İkon ve kalın metin[cite: 11, 14]
            ),
          ],
        ),
      ),
    );
  }
}