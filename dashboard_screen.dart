// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/budget_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/sea_turtle_logo.dart';
import 'grants_list_screen.dart';
import 'simulation_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    _DashboardHome(),
    GrantsListScreen(),
    SimulationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.oceanGradient),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ─── Bottom Navigation ────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.oceanBlue.withOpacity(0.8),
            AppColors.deepOcean,
          ],
        ),
        border: Border(
          top: BorderSide(
              color: AppColors.glassBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Dashboard',
                selected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.list_alt_rounded,
                label: 'Subventions',
                selected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.science_rounded,
                label: 'Simulation',
                selected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? AppColors.brightBlue.withOpacity(0.2)
              : Colors.transparent,
          border: selected
              ? Border.all(color: AppColors.accentCyan.withOpacity(0.3))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.accentCyan : Colors.white38,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.accentCyan : Colors.white38,
                fontSize: 11,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dashboard Home Page ──────────────────────────────────────────────────────

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentCyan),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      FadeInDown(
                        child: Row(
                          children: [
                            const SeaTurtleLogo(size: 42, showLabel: false),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (b) =>
                                        AppColors.accentGradient
                                            .createShader(b),
                                    child: Text(
                                      'SEA TURTLE',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                              fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    'Grants Management System',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            GlassCard(
                              padding: const EdgeInsets.all(10),
                              borderRadius: BorderRadius.circular(14),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: AppColors.accentCyan,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Main KPI card
                      FadeInUp(
                        delay: const Duration(milliseconds: 150),
                        child: _HeroKpiCard(provider: provider),
                      ),

                      const SizedBox(height: 16),

                      // Stat grid
                      FadeInUp(
                        delay: const Duration(milliseconds: 250),
                        child: Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                label: 'Budget Total',
                                value: provider.totalRealAmendment.toUSD(),
                                accentColor: AppColors.brightBlue,
                                icon: Icons.account_balance_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatCard(
                                label: 'Dépensé',
                                value: provider.totalRealSpend.toUSD(),
                                accentColor: AppColors.accentTeal,
                                icon: Icons.payments_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      FadeInUp(
                        delay: const Duration(milliseconds: 350),
                        child: Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                label: 'Solde Restant',
                                value: provider.totalRealRest.toUSD(),
                                accentColor: AppColors.accentCyan,
                                icon: Icons.savings_outlined,
                                subtitle: 'Contre amendement',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatCard(
                                label: 'Utilisation',
                                value:
                                    '${provider.overallUtilization.toStringAsFixed(1)}%',
                                accentColor: _utilizationColor(
                                    provider.overallUtilization),
                                icon: Icons.donut_large_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Section title
                      FadeInLeft(
                        delay: const Duration(milliseconds: 450),
                        child: Text(
                          'CATÉGORIES DE COÛTS',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontSize: 12, letterSpacing: 1.8),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),

            // Grant items list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = provider.realItems[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 500 + index * 80),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: _GrantListTile(item: item),
                    ),
                  );
                },
                childCount: provider.realItems.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }

  Color _utilizationColor(double rate) {
    if (rate >= 90) return AppColors.errorRed;
    if (rate >= 70) return AppColors.warningAmber;
    return AppColors.successGreen;
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
