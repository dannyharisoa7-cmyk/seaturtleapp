// lib/providers/budget_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/grant_model.dart';

class BudgetProvider extends ChangeNotifier {
  List<GrantItem> _realItems = [];
  List<GrantItem> _forecastItems = [];
  double _globalMultiplier = 1.0;
  bool _isLoading = true;
  String? _error;

  // Getters
  List<GrantItem> get realItems => _realItems;
  List<GrantItem> get forecastItems => _forecastItems;
  double get globalMultiplier => _globalMultiplier;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BudgetScenario get realScenario => BudgetScenario(
        name: 'Scénario A — Réel',
        type: 'real',
        items: _realItems,
      );

  BudgetScenario get forecastScenario => BudgetScenario(
        name: 'Scénario B — Prévisionnel',
        type: 'forecast',
        items: _forecastItems,
        multiplier: _globalMultiplier,
      );

  // ─── Data Loading ─────────────────────────────────────────────────────────

  Future<void> loadData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final String jsonString =
          await rootBundle.loadString('assets/data/grants.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      _realItems = jsonList
          .map((e) => GrantItem.fromJson(e as Map<String, dynamic>))
          .toList();

      // Initialize forecast as copy of real
      _forecastItems = List.from(_realItems);

      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = 'Erreur de chargement : $e';
    }
    notifyListeners();
  }

  // ─── Simulation Logic ──────────────────────────────────────────────────────

  void applyGlobalMultiplier(double multiplier) {
    _globalMultiplier = multiplier;
    _forecastItems = _realItems.map((item) {
      final newAmendment = item.amendment * multiplier;
      final newRest = newAmendment - item.totalSpend;
      return item.copyWith(
        amendment: newAmendment,
        restAgainstAmendment: newRest,
      );
    }).toList();
    notifyListeners();
  }

  void updateForecastAmendment(String id, double newAmendment) {
    _forecastItems = _forecastItems.map((item) {
      if (item.id == id) {
        final newRest = newAmendment - item.totalSpend;
        return item.copyWith(
          amendment: newAmendment,
          restAgainstAmendment: newRest,
        );
      }
      return item;
    }).toList();
    notifyListeners();
  }

  void resetForecast() {
    _globalMultiplier = 1.0;
    _forecastItems = List.from(_realItems);
    notifyListeners();
  }

  // ─── Computed Totals ───────────────────────────────────────────────────────

  double get totalRealAmendment =>
      _realItems.fold(0, (s, i) => s + i.amendment);
  double get totalRealSpend =>
      _realItems.fold(0, (s, i) => s + i.totalSpend);
  double get totalRealRest =>
      _realItems.fold(0, (s, i) => s + i.restAgainstAmendment);

  double get totalForecastAmendment =>
      _forecastItems.fold(0, (s, i) => s + i.amendment);
  double get totalForecastRest =>
      _forecastItems.fold(0, (s, i) => s + i.restAgainstAmendment);

  double get overallUtilization =>
      totalRealAmendment > 0
          ? (totalRealSpend / totalRealAmendment) * 100
          : 0;
}
