import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'budget_provider.dart';
import 'utils/app_theme.dart';
import 'glass_card.dart';
import 'sea_turtle_logo.dart';

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
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accentCyan),
                );
              }

              if (provider.error != null) {
                return Center(
                  child: Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
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
                              Text(
                                'Sea Turtle Budget',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Recherche budgétaire par mot-clé sur chaque ligne',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                              ),
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
                          hintText: 'Rechercher code, catégorie, montant...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.accentCyan,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassCard(
                      gradient: const LinearGradient(
                        colors: [Color(0x221A7FD4), Color(0x1100D4FF)],
                      ),
                      borderColor: AppColors.accentCyan.withOpacity(0.4),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SummaryValue(
                              label: 'Lignes',
                              value: provider.resultCount.toString(),
                            ),
                            _SummaryValue(
                              label: 'Budget total',
                              value: provider.totalAmendment.toStringAsFixed(0),
                            ),
                            _SummaryValue(
                              label: 'Dépensé',
                              value: provider.totalSpend.toStringAsFixed(0),
                            ),
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
                                  ? 'Aucune ligne trouvée pour le moment.'
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
        Text(
          label.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(
                color: AppColors.accentCyan,
                fontSize: 10,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _BudgetRowCard extends StatelessWidget {
  final GrantItem item;

  const _BudgetRowCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.costCategory,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                item.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
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
              value: item.amendment > 0
                  ? (item.totalSpend / item.amendment).clamp(0.0, 1.0)
                  : 0,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(
                item.utilizationRate >= 100
                    ? AppColors.errorRed
                    : AppColors.accentCyan,
              ),
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
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ─── Hero KPI Card ────────────────────────────────────────────────────────────

class _HeroKpiCard extends StatelessWidget {
  final BudgetProvider provider;

  const _HeroKpiCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final util = provider.overallUtilization / 100;

    return GlassCard(
      padding: const EdgeInsets.all(22),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x331A7FD4),
          Color(0x1500D4FF),
        ],
      ),
      borderColor: AppColors.brightBlue.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TAUX D\'EXÉCUTION GLOBAL',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: AppColors.accentCyan.withOpacity(0.4)),
                ),
                child: Text(
                  'SCÉNARIO A — RÉEL',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 9, letterSpacing: 1.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ShaderMask(
            shaderCallback: (b) =>
                AppColors.accentGradient.createShader(b),
            child: Text(
              '${provider.overallUtilization.toStringAsFixed(1)}%',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: util.clamp(0, 1),
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                util > 0.9
                    ? AppColors.errorRed
                    : util > 0.7
                        ? AppColors.warningAmber
                        : AppColors.accentCyan,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${provider.totalRealSpend.toUSD()} dépensés sur ${provider.totalRealAmendment.toUSD()} alloués',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}

// ─── Grant List Tile ──────────────────────────────────────────────────────────

class _GrantListTile extends StatelessWidget {
  final dynamic item;

  const _GrantListTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final util = item.utilizationRate / 100;
    final color = util > 0.9
        ? AppColors.errorRed
        : util > 0.7
            ? AppColors.warningAmber
            : AppColors.accentCyan;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 6,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.costCategory,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${item.utilizationRate.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: util.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniStat(label: 'Amendement', value: item.amendment.toUSD()),
              _MiniStat(label: 'Dépensé', value: item.totalSpend.toUSD()),
              _MiniStat(
                  label: 'Restant',
                  value: item.restAgainstAmendment.toUSD(),
                  color: item.isOverBudget
                      ? AppColors.errorRed
                      : AppColors.softWhite),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _MiniStat({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 9,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
