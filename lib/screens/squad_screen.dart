import 'package:flutter/material.dart';

import '../app/app_data.dart';
import '../widgets/hero_widgets.dart';
import 'hero_detail_screen.dart';

class SquadScreen extends StatefulWidget {
  const SquadScreen({super.key, required this.appData, this.onChanged});

  final AppData appData;
  final VoidCallback? onChanged;

  @override
  State<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends State<SquadScreen> {
  @override
  Widget build(BuildContext context) {
    final squad = widget.appData.squad;
    return Scaffold(
      appBar: AppBar(title: Text('Meu Esquadrão (${squad.length}/15)')),
      body: squad.isEmpty
          ? _EmptySquad(onRecruit: () => Navigator.pop(context))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: squad.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final hero = squad[index];
                return HeroCard(
                  hero: hero,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HeroDetailScreen(
                          hero: hero,
                          appData: widget.appData,
                          isSquadMember: true,
                          onChanged: () {
                            widget.onChanged?.call();
                            setState(() {});
                          },
                        ),
                      ),
                    );
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}

class _EmptySquad extends StatelessWidget {
  const _EmptySquad({required this.onRecruit});

  final VoidCallback onRecruit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 72),
            const SizedBox(height: 16),
            Text(
              'Seu esquadrão está vazio',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Acesse o Contrato Diário para recrutar seu primeiro agente.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRecruit,
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}
