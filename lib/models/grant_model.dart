// lib/models/grant_model.dart

class GrantItem {
  final String id;
  final String costCategory;
  final double amendment;
  final double totalSpend;
  final double restAgainstAmendment;
  final String description;

  GrantItem({
    required this.id,
    required this.costCategory,
    required this.amendment,
    required this.totalSpend,
    required this.restAgainstAmendment,
    required this.description,
  });

  factory GrantItem.fromJson(Map<String, dynamic> json) {
    return GrantItem(
      id: json['id'] as String,
      costCategory: json['cost_category'] as String,
      amendment: (json['amendment'] as num).toDouble(),
      totalSpend: (json['total_spend'] as num).toDouble(),
      restAgainstAmendment: (json['rest_against_amendment'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cost_category': costCategory,
        'amendment': amendment,
        'total_spend': totalSpend,
        'rest_against_amendment': restAgainstAmendment,
        'description': description,
      };

  GrantItem copyWith({
    String? id,
    String? costCategory,
    double? amendment,
    double? totalSpend,
    double? restAgainstAmendment,
    String? description,
  }) {
    return GrantItem(
      id: id ?? this.id,
      costCategory: costCategory ?? this.costCategory,
      amendment: amendment ?? this.amendment,
      totalSpend: totalSpend ?? this.totalSpend,
      restAgainstAmendment: restAgainstAmendment ?? this.restAgainstAmendment,
      description: description ?? this.description,
    );
  }

  double get utilizationRate => amendment > 0 ? (totalSpend / amendment) * 100 : 0;
  bool get isOverBudget => totalSpend > amendment;
}

// ─── Scenario Model ───────────────────────────────────────────────────────────

class BudgetScenario {
  final String name;
  final String type; // 'real' or 'forecast'
  final List<GrantItem> items;
  final double? multiplier;

  BudgetScenario({
    required this.name,
    required this.type,
    required this.items,
    this.multiplier,
  });

  double get totalAmendment =>
      items.fold(0, (sum, item) => sum + item.amendment);
  double get totalSpend =>
      items.fold(0, (sum, item) => sum + item.totalSpend);
  double get totalRest =>
      items.fold(0, (sum, item) => sum + item.restAgainstAmendment);
  double get overallUtilization =>
      totalAmendment > 0 ? (totalSpend / totalAmendment) * 100 : 0;
}
