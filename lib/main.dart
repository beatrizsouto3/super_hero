import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ContadorPage());
  }
}

class ContadorPage extends StatefulWidget {
  const ContadorPage({super.key});

  @override
  State<ContadorPage> createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  // 1. Variável que armazena o valor do contador
  int _counter = 0;

  // 2. Função padrão para incrementar o valor
  void _incrementCounter() {
    setState(() {
      // O setState avisa ao Flutter que o estado mudou e a tela precisa ser reconstruída
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exemplo de Incrementar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Você apertou o botão tantas vezes:'),
            Text(
              '$_counter', // Exibe o valor atual da variável
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // Chama a função ao ser clicado
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
