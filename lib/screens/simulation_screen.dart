// lib/screens/simulation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/budget_provider.dart';
import '../models/grant_model.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  double _sliderValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.accentCyan));
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SIMULATION', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 26)),
                                Text('Modélisation de scénarios budgétaires', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.5), fontSize: 11)),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.resetForecast();
                                setState(() => _sliderValue = 1.0);
                              },
                              child: GlassCard(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                borderRadius: BorderRadius.circular(14),
                                child: Row(
                                  children: [const Icon(Icons.restart_alt, color: AppColors.accentCyan, size: 16), const SizedBox(width: 6), Text('Reset', style: TextStyle(color: AppColors.accentCyan, fontSize: 13))],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: GlassCard(
                          gradient: const LinearGradient(colors: [Color(0x221A7FD4), Color(0x1100D4FF)]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('COEFFICIENT BUDGÉTAIRE', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 11)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(20)),
                                    child: Text('×${_sliderValue.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.accentCyan,
                                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                                  thumbColor: AppColors.brightBlue,
                                  overlayColor: AppColors.accentCyan.withOpacity(0.2),
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                                  trackHeight: 5,
                                ),
                                child: Slider(
                                  value: _sliderValue,
                                  min: 0.5,
                                  max: 2.0,
                                  divisions: 30,
                                  onChanged: (v) {
                                    setState(() => _sliderValue = v);
                                    provider.applyGlobalMultiplier(v);
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('−50%', style: TextStyle(color: Colors.white38, fontSize: 11)),
                                  Text('${((_sliderValue - 1) * 100).toStringAsFixed(0)}% vs budget actuel',
                                    style: TextStyle(color: _sliderValue >= 1 ? AppColors.successGreen : AppColors.errorRed, fontWeight: FontWeight.w600, fontSize: 12)),
                                  Text('+100%', style: TextStyle(color: Colors.white38, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: _DeltaSummaryCard(provider: provider),
                      ),
                      const SizedBox(height: 20),
                      Text('AJUSTEMENTS INDIVIDUELS — SCÉNARIO B',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 11, letterSpacing: 1.8)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final real = provider.realItems[i];
                  final forecast = provider.forecastItems[i];
                  return FadeInUp(
                    delay: Duration(milliseconds: 350 + i * 60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: _ItemAdjustCard(
                        real: real,
                        forecast: forecast,
                        onAmendmentChanged: (v) => provider.updateForecastAmendment(real.id, v),
                      ),
                    ),
                  );
                },
                childCount: provider.realItems.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      },
    );
  }
}

class _DeltaSummaryCard extends StatelessWidget {
  final BudgetProvider provider;
  const _DeltaSummaryCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final delta = provider.totalForecastAmendment - provider.totalRealAmendment;
    final isPositive = delta >= 0;
    return GlassCard(
      gradient: LinearGradient(
        colors: isPositive ? [AppColors.accentTeal.withOpacity(0.15), AppColors.accentCyan.withOpacity(0.05)]
          : [AppColors.errorRed.withOpacity(0.15), AppColors.errorRed.withOpacity(0.05)],
      ),
      borderColor: (isPositive ? AppColors.accentTeal : AppColors.errorRed).withOpacity(0.4),
      child: Row(
        children: [
          Icon(isPositive ? Icons.trending_up : Icons.trending_down, color: isPositive ? AppColors.accentTeal : AppColors.errorRed, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IMPACT SCÉNARIO B', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10)),
                const SizedBox(height: 4),
                Text('${isPositive ? '+' : ''}${delta.toUSD()} budget total',
                  style: TextStyle(color: isPositive ? AppColors.accentTeal : AppColors.errorRed, fontWeight: FontWeight.w700, fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemAdjustCard extends StatefulWidget {
  final GrantItem real;
  final GrantItem forecast;
  final Function(double) onAmendmentChanged;
  const _ItemAdjustCard({required this.real, required this.forecast, required this.onAmendmentChanged});

  @override
  State<_ItemAdjustCard> createState() => _ItemAdjustCardState();
}

class _ItemAdjustCardState extends State<_ItemAdjustCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.forecast.amendment.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delta = widget.forecast.amendment - widget.real.amendment;
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.real.costCategory, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RÉEL', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9)),
                    Text(widget.real.amendment.toUSD(), style: const TextStyle(color: AppColors.brightBlue, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.white.withOpacity(0.3), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    final val = double.tryParse(v);
                    if (val != null) widget.onAmendmentChanged(val);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: (delta >= 0 ? AppColors.successGreen : AppColors.errorRed).withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: Text('${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(0)}', style: TextStyle(color: delta >= 0 ? AppColors.successGreen : AppColors.errorRed, fontWeight: FontWeight.w600, fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
