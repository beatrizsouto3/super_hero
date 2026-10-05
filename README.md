# Super Hero

Aplicativo Flutter com catálogo carregado pela API local em `api/`.

## Rodar a API

Em um terminal:

```bash
cd api
npm start
```

## Conectar o aplicativo

No emulador Android, a URL padrão já está configurada:

```text
http://10.0.2.2:3000
```

Em um celular físico conectado à mesma rede Wi-Fi do computador, descubra o
IP local do computador e passe-o ao Flutter:

```bash
flutter run --dart-define=API_BASE_URL=http://IP_DO_COMPUTADOR:3000
```

Por exemplo: `http://192.168.1.25:3000`.

Também é possível conectar por USB usando o encaminhamento do ADB:

```bash
adb reverse tcp:3000 tcp:3000
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

O celular precisa estar autorizado para depuração USB. Para o acesso pela
rede, computador e celular devem estar na mesma rede e o firewall deve liberar
a porta `3000`.

## API publicada

Quando a API estiver no Render, execute o Flutter usando a URL pública:

```bash
flutter run --dart-define=API_BASE_URL=https://SUA-API.onrender.com
```

A URL não fica fixa no código; a configuração padrão continua apontando para o
emulador Android local.
