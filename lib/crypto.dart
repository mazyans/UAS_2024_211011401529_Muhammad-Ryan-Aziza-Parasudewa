class Crypto {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final double marketCap;
  final double volume;

  Crypto({
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.marketCap,
    required this.volume,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      name: json['name'] ?? 'Unknown',
      symbol: json['symbol'] ?? '',
      price: json['price_usd'] != null ? double.parse(json['price_usd']) : 0.0,
      change: json['percent_change_24h'] != null
          ? double.parse(json['percent_change_24h'])
          : 0.0,
      marketCap: json['market_cap_usd'] != null
          ? double.parse(json['market_cap_usd'])
          : 0.0,
      volume: json['24h_volume_usd'] != null
          ? double.parse(json['24h_volume_usd'])
          : 0.0,
    );
  }
}
