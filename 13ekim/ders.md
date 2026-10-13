1.Widget Tree
*iskelet
*immutable(değişmez)
*Çok ucuz (hafif)
*saniyede 6-120 kez ÇÖPE atılıp yeniden üretilir
*ekrand çizim yapmaz
*sadece şablon sunar
*siliniyor

2.Element Tree
*Yönetici & yaşayan omurga
*mutable (durumu ve referanslı hafızada canlı tutar değişir)
*widget ile renderobject arasındaki koordinatördür (organizasyonu sunar)
*güncelleniyor

Flutter en çok oyun sektöründe kullanılır

//canUpdate

//her widgetin bir anahtarı (key) olmalı key aynı değilse element güncellenir ama eşitse widget atılır yenisi gelir ve element güncellenir"

static bool canUpdate (Widget oldWidget,Widget newWidget){
    return oldWidget.runtimeType= newWidget.runtimeType && oldWidget.key == newWidget.key; //ramı tüketmez hızlıca ve cihazı ısıtmaz
}


State Yaşam Döngüsü

*StatefulWidget immutable (olarak değişmez) her rebuild'de yeniden oluşturulur


*State mutable (durumu saklar) rebuild sırasında çöpe atılmaz element tarafından devam eder

Eğer iki sınıf birleşk olsaydı her rebuild esnasında kullanıcı girdiler yayaçlar controller vb. sıfırlanırdı