import 'package:flutter/material.dart';

import 'package:super_hero/app/app_data.dart';

import 'agent_catalog_screen.dart';
import 'daily_contract_screen.dart';
import 'mission_screen.dart';
import 'squad_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.appData});

  final AppData appData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super Hero')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
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
                onPressed: () => _open(context, const AgentCatalogScreen()),
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
