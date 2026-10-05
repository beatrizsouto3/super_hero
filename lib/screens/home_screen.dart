import 'package:flutter/material.dart';

import '../app/app_data.dart';
import 'agent_catalog_screen.dart';
import 'daily_contract_screen.dart';
import 'mission_screen.dart';
import 'squad_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.appData});

  final AppData appData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final squadProgress = appData.squad.length / AppData.squadLimit;

    return Scaffold(
      appBar: AppBar(title: const Text('Super Hero')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text(
            'Central de agentes',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Escolha uma operação para continuar.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people_outline),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Meu esquadrão',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text('${appData.squad.length}/15'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: squadProgress),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Operações',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.55,
            children: [
              _OperationButton(
                icon: Icons.groups_outlined,
                label: 'Agentes',
                onPressed: () =>
                    _open(context, AgentCatalogScreen(appData: appData)),
              ),
              _OperationButton(
                icon: Icons.person_add_alt_1,
                label: 'Contrato diário',
                onPressed: () =>
                    _open(context, DailyContractScreen(appData: appData)),
              ),
              _OperationButton(
                icon: Icons.people_alt_outlined,
                label: 'Esquadrão',
                onPressed: () => _open(context, SquadScreen(appData: appData)),
              ),
              _OperationButton(
                icon: Icons.bolt_outlined,
                label: 'Missões',
                onPressed: () =>
                    _open(context, MissionScreen(appData: appData)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _OperationButton extends StatelessWidget {
  const _OperationButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
