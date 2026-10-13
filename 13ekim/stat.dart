1.createState()

2.mounted == true // state ağacını başlatıyor

3.initState() // 

4.didChangeDependencies() (widget değişimlerinde tetiklenir(Thema.of(context) bu adımda güvenli olarak çalıştırılır)) //sadece elementler değişti

5.build(BuildContext context) (UI burada döndürülür (ASLA İÇİNDE ASENKRON İŞLEM YAPILMAZ)) //EKRANI BASACAĞIMIZ BÖLÜM

6.didUpdateWidget(oldWidget) (üst ebeveyn yeni bir parametre yolladığında çalışır)  //5.adım yeniden çalıştırır güncelleme olduğundan

7.deactive() (ağaçtan geçici olarak kopma). //

8.dispose() (kalıcı olarak kapatma (controller.dispose Stream.cancel) burada yapılır). // 

9.mounted == false