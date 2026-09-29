//Spread ... ...? ve collection if ve collection for

void main(){
  print("Pipeline Konfigürasyonu");

final bool productionMu = true;
final bool debugLoggingAktif = false;
final List<String>? cloudWatchEklentileri = 
["datadog-agent:v7","prometheus-exporter"];
final List<String>? geciciTestYamalari = null;

final List<String> aktifPipelineAdimlari=[
  "git-checkout",
  "security-sast-scan",

  if (productionMu) "production-kms-check",
  if(debugLoggingAktif) "verbose-debug-logger" else 
  "minified-json-logger",

  ...["docker-build","helm-chart-package"],

  ...?cloudWatchEklentileri,
  ...?geciciTestYamalari,//Null olduğu için hiçbir işlem yapamaz/çökmez

];

for(int i = 0; i <aktifPipelineAdimlari.length;i++){
  print("Adım ${i+1}: ${aktifPipelineAdimlari[i]}");
}

final List<int> izinliPortlar = [8080,8443,9090];
final List<String> firewallGuvenliKurallari =[
  "INGRESS-DEFAULT-DROP",
  for(var port in izinliPortlar) "ALLOW-TCP_PORT-Sport (VPC_INTERNAL)",
  "EGRESS_ALL_ALLOW",
];
print("Dinamik Güvenlik Kuralları (collection for):---");
firewallGuvenliKurallari.forEach((kural)=> print(" * $kural"));


}