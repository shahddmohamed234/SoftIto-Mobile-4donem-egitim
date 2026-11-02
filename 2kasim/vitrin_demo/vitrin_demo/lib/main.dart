import 'package:flutter/material.dart';
// uygulamaRotalari değişkeninin bulunduğu dosyayı import edin
import '../route/routes.dart'; 

void main() {
  runApp(const BenimUygulamam());
}

class BenimUygulamam extends StatelessWidget {
  const BenimUygulamam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Uygulama Adı',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      // GoRouter yapılandırmasını buraya bağlıyoruz
      routerConfig: uygulamaRotalari,
      debugShowCheckedModeBanner: false,
    );
  }
}