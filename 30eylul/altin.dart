class AltinKasasi{
  final String oyuncuAdi;
  int _altin = 0;

  AltinKasasi({
    required this.oyuncuAdi,
  });

  int get altin{
    return _altin;
  }

  set altin(int yeniAltin){
    if(yeniAltin <0){
      print("Sahte altın eklenemez!");
    }else{
      _altin =yeniAltin;
      print("Yeni altın eklenebilir!");
    }
  }
}

void main(){
  final oyuncuKasasi = AltinKasasi(oyuncuAdi: "Shushu");

  print("Kasa Sahibi: ${oyuncuKasasi.oyuncuAdi}");
  print("Başlangıç Bakiyesi: ${oyuncuKasasi.altin} Altın\n");

  oyuncuKasasi.altin = 500;
  oyuncuKasasi.altin = -100;

  print("Son Kasa Durumu: ${oyuncuKasasi.altin} Altın");
}

