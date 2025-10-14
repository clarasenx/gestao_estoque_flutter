class Kpi {
  final int totalStock;
  final int totalProduct;
  final int belowMinimumStock;
  final int closeToTheExpirationDate;

  const Kpi({
    required this.totalStock,
    required this.totalProduct,
    required this.belowMinimumStock,
    required this.closeToTheExpirationDate,
  });

  factory Kpi.fromJson(Map<String, dynamic> json) {
    return Kpi(
      totalStock: json['totalStock'] as int,
      totalProduct: json['totalProduct'] as int,
      belowMinimumStock: json['belowMinimumStock'] as int,
      closeToTheExpirationDate: json['closeToTheExpirationDate'] as int,
    );
  }
}
