/*
Future<void> fetchDashboardData() async{
  try{
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchnotification(),
    ], eagerError: true);

    print("Tüm veriler geldi: $result");
  }catch (e){
    print("İsteklerden Biri başarızsız oldu: $e");
  }
}

*/

//Future: tek bir kere veri çekileceği zaman kullanılır ya hata ya da değer dönüp bitirir.
//Stream: bir boru hattı şeklinde çalışır (pipe),  zaman içinde 1 10 100 ya da sonsuz sayıda veri akılı sağlanabilir
//(Borsa fiyatları GPS konum güncelleme, Firebase canlı dinleme)

import 'dart:async';

void main(){

  //Controller oluşturma
  final controller= StreamController<int>();

  //dinleyici (listener) bağlama
  final subscription = controller.stream.listen(
    (data)=>print("Yeni Veri : $data"),
    onError: (err)=> print("Hata oluştu: $err"),
    onDone:() => print("Yayın Tamamlandı"),
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

  controller.close();



}