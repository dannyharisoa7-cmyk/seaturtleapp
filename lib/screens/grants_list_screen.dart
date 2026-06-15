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
        if (provider.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.accentCyan));
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
                      FadeInDown(child: Text('SUBVENTIONS', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 26))),
                      FadeInDown(delay: const Duration(milliseconds: 100), child: Text('Toutes les catégories de coûts', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.5)))),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: GlassCard(
                          gradient: const LinearGradient(colors: [Color(0x2200B8A0), Color(0x1100D4FF)]),
                          borderColor: AppColors.accentTeal.withOpacity(0.4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _SummaryItem(label: 'AMENDEMENT', value: scenario.totalAmendment.toUSD(), color: AppColors.brightBlue),
                              Container(width: 1, height: 36, color: Colors.white12),
                              _SummaryItem(label: 'DÉPENSÉ', value: scenario.totalSpend.toUSD(), color: AppColors.accentTeal),
                              Container(width: 1, height: 36, color: Colors.white12),
                              _SummaryItem(label: 'RESTANT', value: scenario.totalRest.toUSD(), color: AppColors.accentCyan),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('${scenario.items.length} CATÉGORIES', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 11, letterSpacing: 1.8)),
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
                  return FadeInUp(delay: Duration(milliseconds: 300 + i * 70), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6), child: _GrantDetailCard(item: item)));
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
  final String label, value;
  final Color color;
  const _SummaryItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
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
    final color = util > 0.9 ? AppColors.errorRed : util > 0.7 ? AppColors.warningAmber : AppColors.accentTeal;

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
                      Text(widget.item.costCategory, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(
                        widget.item.description.isNotEmpty ? widget.item.description : 'Pas de description disponible',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.info_outline, color: Colors.white70, size: 22),
                  onPressed: _showDetails,
                  tooltip: 'Détails',
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.2), border: Border.all(color: color.withOpacity(0.4))),
                  child: Center(child: Text('${util * 100 > 100 ? 100 : (util * 100).toStringAsFixed(0)}%', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13))),
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              _ProgressBar(util: util),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('AMENDEMENT', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w600)),
                    Text(widget.item.amendment.toFullUSD(), style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.w600)),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('DÉPENSÉ', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w600)),
                    Text(widget.item.totalSpend.toFullUSD(), style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600)),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('SOLDE', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w600)),
                    Text(widget.item.restAgainstAmendment.toFullUSD(), style: const TextStyle(color: AppColors.accentTeal, fontWeight: FontWeight.w600)),
                  ]),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDetails() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0D162A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(widget.item.costCategory, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description', style: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                widget.item.description.isNotEmpty ? widget.item.description : 'Pas de description disponible',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              _DetailLine(label: 'Amendement', value: widget.item.amendment.toFullUSD()),
              const SizedBox(height: 8),
              _DetailLine(label: 'Dépensé', value: widget.item.totalSpend.toFullUSD()),
              const SizedBox(height: 8),
              _DetailLine(label: 'Solde', value: widget.item.restAgainstAmendment.toFullUSD()),
              const SizedBox(height: 8),
              _DetailLine(label: 'Utilisation', value: '${widget.item.utilizationRate.toStringAsFixed(1)} %'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer', style: TextStyle(color: AppColors.accentCyan)),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double util;
  const _ProgressBar({required this.util});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: util > 1 ? 1 : util,
        minHeight: 6,
        backgroundColor: Colors.white.withOpacity(0.1),
        valueColor: AlwaysStoppedAnimation(util > 0.9 ? AppColors.errorRed : util > 0.7 ? AppColors.warningAmber : AppColors.accentTeal),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
