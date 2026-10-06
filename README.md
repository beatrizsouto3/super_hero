# Super Hero

Aplicativo Flutter com catálogo carregado pela API hospedada no Render.

## Rodar a API

Em um terminal:

```bash
cd api
npm start
```

## Conectar o aplicativo

Por padrão, o app usa a API publicada:

```text
https://super-hero-api-lvx2.onrender.com
```

Para sobrescrever a URL em outro ambiente, use `API_BASE_URL`.

Para usar a API local no emulador Android, informe:

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

Quando quiser informar explicitamente a API publicada, execute o Flutter usando
a URL pública:

```bash
flutter run --dart-define=API_BASE_URL=https://super-hero-api-lvx2.onrender.com
```

Para voltar a usar a API local no emulador Android, informe explicitamente:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```
