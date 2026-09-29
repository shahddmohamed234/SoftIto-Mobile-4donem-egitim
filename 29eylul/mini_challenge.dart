void main() {
  final Set<String> aktifServisler = {
    "auth-api",
    "payment-gateway",
    "auth-api",
  };

  bool isProduction = true;

  final List<String> servisler = [
    ...aktifServisler,
    if (isProduction) "vault-secret-manager",
  ];
  print("Liste: $servisler");
}
