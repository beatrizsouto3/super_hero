# API local — Super Hero

Esta pasta contém a API REST local usada durante o desenvolvimento do
aplicativo. Ela segue o formato apresentado pelo professor com `json-server`.

## Preparação

Na pasta `api/`, instale a dependência:

```bash
npm install
```

O arquivo `db.json` deve conter uma propriedade `heroes` com o conteúdo da
lista oficial de heróis. Para preparar o arquivo a partir da referência do
trabalho:

```bash
curl -fL https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/all.json \
  -o all.json
node -e "const fs=require('fs'); const heroes=JSON.parse(fs.readFileSync('all.json','utf8')); fs.writeFileSync('db.json', JSON.stringify({heroes}, null, 2));"
```

## Execução

```bash
npm start
```

Endpoints esperados:

- `GET http://localhost:3000/heroes`
- `GET http://localhost:3000/heroes/1`
- `GET http://localhost:3000/heroes?_page=1&_limit=20`

O aplicativo Flutter deverá usar a URL `http://10.0.2.2:3000` no emulador
Android. Em um celular físico, deve ser usada a mesma rede local e o IP da
máquina que está executando o servidor. No Flutter, informe esse endereço com
`--dart-define=API_BASE_URL=http://IP_DA_MAQUINA:3000`. O servidor já escuta em
`0.0.0.0`, permitindo acesso pela rede local.
