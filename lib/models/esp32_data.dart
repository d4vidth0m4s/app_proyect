class ESP32Data {
  final bool estado;
  final int rpm;
  final double temperatura;
  final int timeon;
  final double corriente;

  ESP32Data({
    required this.estado,
    required this.rpm,
    required this.temperatura,
    required this.corriente,
    required this.timeon,
  });

  factory ESP32Data.fromJson(Map<String, dynamic> json) {
    return ESP32Data(
      estado: json['estado'] ?? false,
      rpm: json['rpm'] ?? 0,
      temperatura: (json['temperatura'] ?? 0).toDouble(),
      corriente: (json['corriente'] ?? 0).toDouble(),
      timeon: json['timeon'] ?? 0,
    );
  }
}
