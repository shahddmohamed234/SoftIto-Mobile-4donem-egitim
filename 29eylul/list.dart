void main(){
  final List<String> aktifMikroservisler = [
    "auth-service:v2.1",
    "gateway-service:v1.9",
    "payment-processor",
  ];

  aktifMikroservisler.add("telemetry-collector:v1.0");
  print("Aktif Servisler: (${aktifMikroservisler.length} adet): $aktifMikroservisler ");

  //sabit uzunluktaki liste(fixed-length)

  final List<String> cekirdekYukDengeleyiciler = List.filled(4, "Port-Kapalı",growable: false);
  cekirdekYukDengeleyiciler[0] ="LB-NODE-01 ; 192.168.1.10 (Online)";
  cekirdekYukDengeleyiciler[1] ="LB-NODE-02 ; 192.168.1.11 (Online)";
  //cekirdekYukDengeleyiciler.add("LB-NODE-05"); //HATA: fixed-length listeye eleman eklenmez
  print("Çekirdek Yük Dengeleyici Portları: $cekirdekYukDengeleyiciler");

  //Programatik List Üreticisi
  final List<String> kubernetPodlari=List.generate(13, 
    (index)=>"pod-node-eu-west-${index+1} [RAM:16 GB, CPU:4 Cores]",
  );

  print("Oluşturulan K8s Podları $kubernetPodlari");

  //Değiştirlemez List
  final List<String> guvenlikDuvariPortlari = List.unmodifiable([
    "22/TCP (SSH)"
    "443/TCP (HTTPS)"
    "6443/TCP (K8s-API)"
  ]);

  //guvenlikDuvariPortlari[0]="80/TCP"; //Hata cannot modify an unmodifiable list
  print("Güvenlik Duvarı Korumalı Portlar: $guvenlikDuvariPortlari");

}