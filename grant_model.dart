class GrantItem {
  final String id;
  final String costCategory;
  final String description;
  final double amendment;
  final double totalSpend;
  final double restAgainstAmendment;

  GrantItem({
    required this.id,
    required this.costCategory,
    required this.description,
    required this.amendment,
    required this.totalSpend,
    required this.restAgainstAmendment,
  });

  factory GrantItem.fromJson(Map<String, dynamic> json) {
    final category = json['-Cost category']?.toString() ?? '';
    return GrantItem(
      id: category,
      costCategory: category,
      description: json['Description']?.toString() ?? '',
      amendment: _parseAmount(json['AMENDMENT']?.toString() ?? '0'),
      totalSpend: _parseAmount(json['TOTAL SPEND']?.toString() ?? '0'),
      restAgainstAmendment:
          _parseAmount(json['REST AGAINST AMENDMENT']?.toString() ?? '0'),
    );
  }

  static double _parseAmount(String raw) {
    final normalized = raw.replaceAll(',', '').trim();
    return double.tryParse(normalized) ?? 0.0;
  }

  String get formattedAmendment => _formatMoney(amendment);
  String get formattedTotalSpend => _formatMoney(totalSpend);
  String get formattedRest => _formatMoney(restAgainstAmendment);

  static String _formatMoney(double value) {
    final sign = value < 0 ? '-' : '';
    final amount = value.abs().toStringAsFixed(2);
    final parts = amount.split('.');
    final integer = parts[0];
    final decimals = parts[1];
    final formatted = integer.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',${match.group(0)}',
    );
    return '$sign\\$$formatted.$decimals';
  }

  double get utilizationRate =>
      amendment > 0 ? (totalSpend / amendment) * 100 : 0;

  bool matchesQuery(String query) {
    final normalized = query.toLowerCase().trim();
    if (normalized.isEmpty) return true;
    final line = '$costCategory $description ${amendment.toStringAsFixed(2)} ${totalSpend.toStringAsFixed(2)} ${restAgainstAmendment.toStringAsFixed(2)}'.toLowerCase();
    return line.contains(normalized);
  }
}
