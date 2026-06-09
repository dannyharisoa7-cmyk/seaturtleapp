// lib/screens/grants_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/budget_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';

class GrantsListScreen extends StatelessWidget {
  const GrantsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.accentCyan));
        }

        final scenario = provider.realScenario;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: Text(
                          'SUBVENTIONS',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(fontSize: 26),
                        ),
                      ),
                      FadeInDown(
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          'Toutes les catégories de coûts',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Summary row
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: GlassCard(
                          gradient: const LinearGradient(
                            colors: [Color(0x2200B8A0), Color(0x1100D4FF)],
                          ),
                          borderColor: AppColors.accentTeal.withOpacity(0.4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _SummaryItem(
                                label: 'AMENDEMENT',
                                value: scenario.totalAmendment.toUSD(),
                                color: AppColors.brightBlue,
                              ),
                              Container(
                                  width: 1,
                                  height: 36,
                                  color: Colors.white12),
                              _SummaryItem(
                                label: 'DÉPENSÉ',
                                value: scenario.totalSpend.toUSD(),
                                color: AppColors.accentTeal,
                              ),
                              Container(
                                  width: 1,
                                  height: 36,
                                  color: Colors.white12),
                              _SummaryItem(
                                label: 'RESTANT',
                                value: scenario.totalRest.toUSD(),
                                color: AppColors.accentCyan,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${scenario.items.length} CATÉGORIES',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontSize: 11, letterSpacing: 1.8),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final item = scenario.items[i];
                  return FadeInUp(
                    delay: Duration(milliseconds: 300 + i * 70),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: _GrantDetailCard(item: item),
                    ),
                  );
                },
                childCount: scenario.items.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: 9,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _GrantDetailCard extends StatefulWidget {
  final dynamic item;

  const _GrantDetailCard({required this.item});

  @override
  State<_GrantDetailCard> createState() => _GrantDetailCardState();
}

class _GrantDetailCardState extends State<_GrantDetailCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final util = widget.item.utilizationRate / 100;
    final color = util > 0.9
        ? AppColors.errorRed
        : util > 0.7
            ? AppColors.warningAmber
            : AppColors.accentTeal;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.costCategory,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.item.description,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.45), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white38,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Taux d\'exécution',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11),
                          ),
                          Text(
                            '${widget.item.utilizationRate.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: util.clamp(0.0, 1.0),
                          backgroundColor: Colors.white.withOpacity(0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.08),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DetailRow(
                            'Amendement',
                            widget.item.amendment.toFullUSD(),
                            AppColors.brightBlue),
                        _DetailRow(
                            'Total Dépensé',
                            widget.item.totalSpend.toFullUSD(),
                            AppColors.accentTeal),
                        _DetailRow(
                            'Restant',
                            widget.item.restAgainstAmendment.toFullUSD(),
                            widget.item.isOverBudget
                                ? AppColors.errorRed
                                : AppColors.accentCyan),
                      ],
                    ),
                    if (widget.item.isOverBudget) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.errorRed.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: AppColors.errorRed, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Dépassement de budget détecté',
                              style: TextStyle(
                                  color: AppColors.errorRed, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DetailRow(this.label, this.value, this.color);

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
              letterSpacing: 0.8),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }
}
