import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  //firebase kullanmak için motor çalıştırmamız gerekiyor
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const SofitoFirestoreUygulamasi());
}

class SofitoFirestoreUygulamasi extends StatelessWidget {

  const SofitoFirestoreUygulamasi ({super.key});

  @override
  Widget build (BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cloud Firestore",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const FireStoreYonetimEkrani(),
    );
  }
}
