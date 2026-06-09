// lib/screens/simulation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/budget_provider.dart';
import '../models/grant_model.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _sliderValue = 1.0; // multiplier

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.accentCyan));
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      FadeInDown(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SIMULATION',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(fontSize: 26),
                                ),
                                Text(
                                  'Modélisation de scénarios budgétaires',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 11),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.resetForecast();
                                setState(() => _sliderValue = 1.0);
                              },
                              child: GlassCard(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                borderRadius: BorderRadius.circular(14),
                                child: Row(
                                  children: [
                                    const Icon(Icons.restart_alt,
                                        color: AppColors.accentCyan, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Reset',
                                      style: TextStyle(
                                          color: AppColors.accentCyan,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tab bar
                      FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        child: GlassCard(
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(16),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: AppColors.accentGradient,
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white38,
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                            tabs: const [
                              Tab(text: 'Scénario A — Réel'),
                              Tab(text: 'Scénario B — Prév.'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Multiplier slider
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: GlassCard(
                          gradient: const LinearGradient(
                            colors: [Color(0x221A7FD4), Color(0x1100D4FF)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'COEFFICIENT BUDGÉTAIRE',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontSize: 11),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.accentGradient,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '×${_sliderValue.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.accentCyan,
                                  inactiveTrackColor:
                                      Colors.white.withOpacity(0.1),
                                  thumbColor: AppColors.brightBlue,
                                  overlayColor:
                                      AppColors.accentCyan.withOpacity(0.2),
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 10),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('−50%',
                                      style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11)),
                                  Text(
                                    '${((_sliderValue - 1) * 100).toStringAsFixed(0)}% vs budget actuel',
                                    style: TextStyle(
                                      color: _sliderValue >= 1
                                          ? AppColors.successGreen
                                          : AppColors.errorRed,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text('+100%',
                                      style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Comparison chart
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'COMPARATIF BUDGÉTAIRE',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _LegendDot(color: AppColors.brightBlue),
                                  const SizedBox(width: 4),
                                  Text('Réel',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 11)),
                                  const SizedBox(width: 12),
                                  _LegendDot(color: AppColors.accentCyan),
                                  const SizedBox(width: 4),
                                  Text('Prévisionnel',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 11)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: _ComparisonChart(
                                  realItems: provider.realItems,
                                  forecastItems: provider.forecastItems,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Delta summary
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: _DeltaSummaryCard(provider: provider),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'AJUSTEMENTS INDIVIDUELS — SCÉNARIO B',
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

            // Per-item adjustments
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final real = provider.realItems[i];
                  final forecast = provider.forecastItems[i];
                  return FadeInUp(
                    delay: Duration(milliseconds: 450 + i * 60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: _ItemAdjustCard(
                        real: real,
                        forecast: forecast,
                        onAmendmentChanged: (v) =>
                            provider.updateForecastAmendment(real.id, v),
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

// ─── Bar Chart ────────────────────────────────────────────────────────────────

class _ComparisonChart extends StatelessWidget {
  final List<GrantItem> realItems;
  final List<GrantItem> forecastItems;

  const _ComparisonChart(
      {required this.realItems, required this.forecastItems});

  @override
  Widget build(BuildContext context) {
    final maxVal = [
      ...realItems.map((e) => e.amendment),
      ...forecastItems.map((e) => e.amendment),
    ].reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal * 1.15,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppColors.oceanBlue,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final label = rodIndex == 0 ? 'Réel' : 'Prév.';
              return BarTooltipItem(
                '$label\n${rod.toY.toUSD()}',
                const TextStyle(color: Colors.white, fontSize: 11),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final labels = [
                  'CAPEX',
                  'O&M',
                  'CONS',
                  'TRAIN',
                  'RES',
                  'COM',
                  'ADM',
                  'VIS',
                ];
                final idx = value.toInt();
                if (idx >= 0 && idx < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      labels[idx],
                      style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 8,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 24,
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withOpacity(0.06),
            strokeWidth: 1,
          ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(realItems.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: realItems[i].amendment,
                color: AppColors.brightBlue,
                width: 10,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4)),
              ),
              BarChartRodData(
                toY: forecastItems[i].amendment,
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [AppColors.brightBlue, AppColors.accentCyan],
                ),
                width: 10,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4)),
              ),
            ],
            barsSpace: 3,
          );
        }),
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}

// ─── Delta Summary Card ───────────────────────────────────────────────────────

class _DeltaSummaryCard extends StatelessWidget {
  final BudgetProvider provider;

  const _DeltaSummaryCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final delta =
        provider.totalForecastAmendment - provider.totalRealAmendment;
    final deltaRest =
        provider.totalForecastRest - provider.totalRealRest;
    final isPositive = delta >= 0;

    return GlassCard(
      gradient: LinearGradient(
        colors: isPositive
            ? [
                AppColors.accentTeal.withOpacity(0.15),
                AppColors.accentCyan.withOpacity(0.05),
              ]
            : [
                AppColors.errorRed.withOpacity(0.15),
                AppColors.errorRed.withOpacity(0.05),
              ],
      ),
      borderColor: (isPositive ? AppColors.accentTeal : AppColors.errorRed)
          .withOpacity(0.4),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? AppColors.accentTeal : AppColors.errorRed,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IMPACT SCÉNARIO B',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 4),
                Text(
                  '${isPositive ? '+' : ''}${delta.toUSD()} budget total',
                  style: TextStyle(
                    color: isPositive ? AppColors.accentTeal : AppColors.errorRed,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${deltaRest.toUSD()} solde restant',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Individual Item Adjustment ───────────────────────────────────────────────

class _ItemAdjustCard extends StatefulWidget {
  final GrantItem real;
  final GrantItem forecast;
  final ValueChanged<double> onAmendmentChanged;

  const _ItemAdjustCard({
    required this.real,
    required this.forecast,
    required this.onAmendmentChanged,
  });

  @override
  State<_ItemAdjustCard> createState() => _ItemAdjustCardState();
}

class _ItemAdjustCardState extends State<_ItemAdjustCard> {
  late TextEditingController _ctrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
        text: widget.forecast.amendment.toStringAsFixed(0));
  }

  @override
  void didUpdateWidget(covariant _ItemAdjustCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing) {
      _ctrl.text = widget.forecast.amendment.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final changed = widget.forecast.amendment != widget.real.amendment;
    final delta = widget.forecast.amendment - widget.real.amendment;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: changed
          ? AppColors.accentCyan.withOpacity(0.4)
          : AppColors.glassBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.real.costCategory,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              if (changed)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${delta >= 0 ? '+' : ''}${delta.toUSD()}',
                    style: TextStyle(
                      color: delta >= 0
                          ? AppColors.accentCyan
                          : AppColors.errorRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AMENDEMENT RÉEL',
                      style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.real.amendment.toUSD(),
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward,
                  color: Colors.white24, size: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRÉVISIONNEL',
                      style: TextStyle(
                          color: AppColors.accentCyan,
                          fontSize: 9,
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 32,
                      child: TextField(
                        controller: _ctrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: AppColors.accentCyan.withOpacity(0.4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: AppColors.accentCyan),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.15)),
                          ),
                          prefixText: '\$ ',
                          prefixStyle: TextStyle(
                              color: Colors.white54, fontSize: 14),
                        ),
                        onTap: () => setState(() => _editing = true),
                        onSubmitted: (v) {
                          final parsed = double.tryParse(v);
                          if (parsed != null && parsed >= 0) {
                            widget.onAmendmentChanged(parsed);
                          }
                          setState(() => _editing = false);
                        },
                        onEditingComplete: () {
                          final parsed = double.tryParse(_ctrl.text);
                          if (parsed != null && parsed >= 0) {
                            widget.onAmendmentChanged(parsed);
                          }
                          setState(() => _editing = false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Restant prév.: ${widget.forecast.restAgainstAmendment.toUSD()}',
                style: TextStyle(
                  color: widget.forecast.restAgainstAmendment < 0
                      ? AppColors.errorRed
                      : Colors.white54,
                  fontSize: 11,
                ),
              ),
              Text(
                'Dépensé: ${widget.real.totalSpend.toUSD()}',
                style:
                    const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Legend Dot ───────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
