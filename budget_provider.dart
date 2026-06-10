import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'grant_model.dart';

class BudgetProvider extends ChangeNotifier {
  final List<GrantItem> _items = [];
  String _searchQuery = '';
  bool _isLoading = true;
  String? _error;

  List<GrantItem> get allItems => List.unmodifiable(_items);
  List<GrantItem> get filteredItems {
    if (_searchQuery.isEmpty) return allItems;
    return _items.where((item) => item.matchesQuery(_searchQuery)).toList();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  int get resultCount => filteredItems.length;

  double get totalAmendment =>
      _items.fold(0, (sum, item) => sum + item.amendment);
  double get totalSpend =>
      _items.fold(0, (sum, item) => sum + item.totalSpend);
  double get totalRest =>
      _items.fold(0, (sum, item) => sum + item.restAgainstAmendment);

  double get overallUtilization =>
      totalAmendment > 0 ? (totalSpend / totalAmendment) * 100 : 0;

  Future<void> loadData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final String jsonString =
          await rootBundle.loadString('assets/data/spend_against_budget.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _items.clear();
      _items.addAll(jsonList
          .map((e) => GrantItem.fromJson(e as Map<String, dynamic>))
          .toList());

      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = 'Erreur de chargement : $e';
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
