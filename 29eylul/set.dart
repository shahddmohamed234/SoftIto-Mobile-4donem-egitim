//Set ve Ağ güvenlik kümeleri
void main() {
  print("Beyaz Liste v eKüme Analizi");

  final Set<String> istanbulVeriMerkeziIpleri = {
    "10.0.1.10",
    "10.0.1.11",
    "10.0.1.12",
    "10.0.1.13",
    "10.0.1.10", //çift kayıt set burayı anında tek kale getirir
  };

  print("İstanbul ipleri: $istanbulVeriMerkeziIpleri");

  final Set<String> frakfurtVeriMerkeziIpleri = {
    "10.0.1.13",
    "10.0.1.30",
    "10.0.1.45",
  };

  print("Frakfurt İpleri: $frakfurtVeriMerkeziIpleri");

  final ortakKopruIpleri = istanbulVeriMerkeziIpleri.intersection(
    frakfurtVeriMerkeziIpleri,
  );
  print("Ortak Ağ İpleri(kesişim): $ortakKopruIpleri");

  final tumGlobalIpleri = istanbulVeriMerkeziIpleri.union(
    frakfurtVeriMerkeziIpleri,
  );
  print("Toplam Global İpleri: $tumGlobalIpleri");

  final sadeceIstanbul = istanbulVeriMerkeziIpleri.difference(
    frakfurtVeriMerkeziIpleri,
  );
  print("Sadece İstanbul: $sadeceIstanbul");
}
