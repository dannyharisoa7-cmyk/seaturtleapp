// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/budget_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/sea_turtle_logo.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.oceanGradient),
        child: SafeArea(
          child: Consumer<BudgetProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.accentCyan));
              }

              if (provider.error != null) {
                return Center(
                  child: Text(
                    provider.error ?? 'Erreur inconnue',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              return Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const SeaTurtleLogo(size: 42, showLabel: false),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sea Turtle Budget', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('Recherche par mot-clé sur chaque ligne de la base de données', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassCard(
                      child: TextField(
                        key: const Key('searchField'),
                        onChanged: provider.updateSearchQuery,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Rechercher par code, catégorie, montant, etc.',
                          hintStyle: TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.search, color: AppColors.accentCyan),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassCard(
                      gradient: const LinearGradient(colors: [Color(0x221A7FD4), Color(0x1100D4FF)]),
                      borderColor: AppColors.accentCyan.withOpacity(0.4),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SummaryValue(label: 'Lignes', value: provider.resultCount.toString()),
                            _SummaryValue(label: 'Budget total', value: provider.totalAmendment.toStringAsFixed(0)),
                            _SummaryValue(label: 'Dépensé', value: provider.totalSpend.toStringAsFixed(0)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: provider.filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              provider.searchQuery.isEmpty
                                  ? 'Chargement terminé, aucune ligne trouvée.'
                                  : 'Aucune ligne ne correspond à "${provider.searchQuery}"',
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: provider.filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = provider.filteredItems[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _BudgetRowCard(item: item),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.accentCyan, fontSize: 10, letterSpacing: 1.5)),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _BudgetRowCard extends StatelessWidget {
  final dynamic item;

  const _BudgetRowCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.costCategory, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(item.description, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DataLabel(label: 'Amendement', value: item.formattedAmendment),
                _DataLabel(label: 'Dépensé', value: item.formattedTotalSpend),
                _DataLabel(label: 'Solde', value: item.formattedRest),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: item.amendment > 0 ? (item.totalSpend / item.amendment).clamp(0.0, 1.0) : 0,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(item.utilizationRate >= 100 ? AppColors.errorRed : AppColors.accentCyan),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataLabel extends StatelessWidget {
  final String label;
  final String value;

  const _DataLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
