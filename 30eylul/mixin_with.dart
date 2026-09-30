//mixin & with

mixin UcmaYetisi {
  int ucusIrtifasiMetre = 100;

  void gogeYuksel() {
    print(
      "Uçuş Yetisi: Kanatlarını Açtı ve $ucusIrtifasiMetre metreye yükseldi.",
    );
  }
}

mixin GorunmezlikYetisi {
  void pelerinOrt() {
    print("Görünmezlik: Düşmanların gözünden tamamen kayboldu!");
  }
}

mixin AtesGucuYetiis {
  void alevSaldirisi() {
    print("Ateş Gücü: Kılıcını alevlendirdi ve alanı yaktı");
  }
}

class TemelKarakter{
  final String ad;
  TemelKarakter({required this.ad});
}

class EfsaneviBinicisi extends TemelKarakter with UcmaYetisi,AtesGucuYetiis{
  final String ejderhaAdi;

  EfsaneviBinicisi({
    required this.ejderhaAdi,
    required super.ad,
  });


  void hucumEt(){
    print("$ad ve ejderhası $ejderhaAdi savaşa katılıyor.");
    gogeYuksel();
    alevSaldirisi();
  }
}



class GolgeSuikastci extends TemelKarakter with GorunmezlikYetisi{
  GolgeSuikastci({required super.ad});

  void suikastYap(){
    print("$ad hedefe sessizce yaklaşıyor.");
    pelerinOrt();
    print("Kritik Darbe Vurdu");
  }
}

void main(){
  print("Süper Güçler Başlatılıyor");
  final birinci=EfsaneviBinicisi(ejderhaAdi: "Aslıhan", ad: "Gencer");
  birinci.hucumEt();
  final ikinci = GolgeSuikastci(ad: "Adil Murat");
  ikinci.suikastYap();
}
