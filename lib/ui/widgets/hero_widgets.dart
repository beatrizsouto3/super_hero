import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

import 'package:super_hero/domain/models/super_hero.dart';

class HeroAvatar extends StatelessWidget {
  const HeroAvatar({super.key, required this.hero, this.radius = 32});

  final SuperHero hero;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Text(
        hero.name.substring(0, 1),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: radius * .75,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: hero.imageUrl.isEmpty
            ? fallback
            : CachedNetworkImage(
                imageUrl: hero.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

class HeroPortrait extends StatelessWidget {
  const HeroPortrait({super.key, required this.hero, this.width = 126});

  final SuperHero hero;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * 1.32;
    final fallback = Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Text(
        hero.name.substring(0, 1),
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: width,
        height: height,
        child: hero.imageUrl.isEmpty
            ? fallback
            : CachedNetworkImage(
                imageUrl: hero.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.hero, required this.onTap});

  final SuperHero hero;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              HeroPortrait(hero: hero),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Maior atributo: ${hero.highestStat}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Inteligência: ${hero.stat(HeroStat.intelligence)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Força: ${hero.stat(HeroStat.strength)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Combate: ${hero.stat(HeroStat.combat)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class StatBars extends StatelessWidget {
  const StatBars({super.key, required this.hero});

  final SuperHero hero;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: HeroStat.values.map((attribute) {
        // A barra do Primer exige valores inteiros entre 0 e 100. A
        // normalização protege a tela contra cache/API com dados inválidos.
        final value = hero.stat(attribute).clamp(0, 100).toInt();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SizedBox(width: 100, child: Text(attribute.label)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: PrimerProgressBar(
                    segments: [
                      Segment(
                        value: value,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                    maxTotalValue: 100,
                    showLegend: false,
                  ),
                ),
              ),
              SizedBox(
                width: 38,
                child: Text('$value', textAlign: TextAlign.end),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
