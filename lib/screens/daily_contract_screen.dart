import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_data.dart';
import '../providers/daily_contract_provider.dart';
import '../widgets/hero_widgets.dart';

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
    return Consumer<DailyContractProvider>(
      builder: (context, contract, _) {
        if (widget.appData.heroes.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Contrato Diário')),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nenhum agente disponível. Conecte-se à internet para '
                  'carregar o catálogo pela primeira vez.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final hero = contract.dailyHero;
        final recruited = contract.isRecruited(hero.id);
        final full = contract.squadIsFull;
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
              Text(
                'Um novo agente fica disponível a cada '
                '${AppData.contractInterval.inSeconds} segundos.',
              ),
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
                      const SizedBox(height: 20),
                      StatBars(hero: hero),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: recruited || full ? null : _recruit,
                          icon: Icon(
                            recruited ? Icons.check : Icons.person_add,
                          ),
                          label: Text(
                            recruited
                                ? 'Já recrutado'
                                : full
                                ? 'Esquadrão cheio'
                                : 'Recrutar para o Esquadrão',
                          ),
                        ),
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _recruit() async {
    if (await context.read<DailyContractProvider>().recruit()) {
      if (!mounted) return;
      final hero = context.read<DailyContractProvider>().dailyHero;
      widget.onChanged?.call();
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${hero.name} recrutado!')));
    }
  }
}
