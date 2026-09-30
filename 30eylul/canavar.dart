abstract class Canavar {
  final String canavarAdi;

  Canavar({required this.canavarAdi});
  

  void kukre();
  

 
}


class Kurt extends Canavar {
  Kurt({required super.canavarAdi});

  @override
  void kukre() {
    print("$canavarAdi: Aauuuuuuu!");
  }
}

// Ejderha Sınıfı - Canavar'dan miras alır
class Ejderha extends Canavar {

  Ejderha({required super.canavarAdi});

  @override
  void kukre() {
    print("$canavarAdi: Rooooaaarrrr! *ateş püskürtür*");
  }
}


class Zombi extends Canavar {
  Zombi({required super.canavarAdi});
  
  @override
  void kukre() {
    print("$canavarAdi: Grrrrrr... Beyiiin...");
  }
}

void tplucaKukre(List<Canavar> team) {

  for (var t in team) {

    t.kukre();
  }
}

void main() {
  
 print("Canavar Alemi");
  final List<Canavar> canavarlar = [
    Kurt(canavarAdi: "Kurt"),
    Ejderha(canavarAdi: "Ejderha"),
    Zombi(canavarAdi: "Zombi"),
  ];

  //hepsine tek bir emir ile çalıştırıyoruz
  tplucaKukre(canavarlar);
}