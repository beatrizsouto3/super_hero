import 'package:flutter/material.dart';

import '../app/app_data.dart';
import '../models/super_hero.dart';
import '../widgets/hero_widgets.dart';
import 'hero_detail_screen.dart';

class DailyContractScreen extends StatefulWidget {
  const DailyContractScreen({super.key, required this.appData, this.onChanged});

  final AppData appData;
  final VoidCallback? onChanged;

  @override
  State<DailyContractScreen> createState() => _DailyContractScreenState();
}

class _DailyContractScreenState extends State<DailyContractScreen> {
  @override
  Widget build(BuildContext context) {
    final hero = widget.appData.dailyHero;
    final recruited = widget.appData.isRecruited(hero.id);
    final full = widget.appData.squadIsFull;
    return Scaffold(
      appBar: AppBar(title: const Text('Contrato Diário')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Convocação do dia',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('Um novo agente é disponibilizado a cada dia.'),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  HeroAvatar(hero: hero, radius: 70),
                  const SizedBox(height: 16),
                  Text(
                    hero.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(hero.publisher),
                  const SizedBox(height: 20),
                  StatBars(hero: hero),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: recruited || full
                          ? null
                          : () => _recruit(hero),
                      icon: Icon(recruited ? Icons.check : Icons.person_add),
                      label: Text(
                        recruited
                            ? 'Já recrutado'
                            : full
                            ? 'Esquadrão cheio'
                            : 'Recrutar para o Esquadrão',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HeroDetailScreen(
                          hero: hero,
                          appData: widget.appData,
                        ),
                      ),
                    ),
                    child: const Text('Ver detalhes do agente'),
                  ),
                ],
              ),
            ),
          ),
          if (full)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                'O esquadrão atingiu sua capacidade máxima de 15 agentes.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _recruit(SuperHero hero) async {
    if (await widget.appData.recruit(hero.id)) {
      if (!mounted) return;
      widget.onChanged?.call();
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${hero.name} recrutado!')));
    }
  }
}
