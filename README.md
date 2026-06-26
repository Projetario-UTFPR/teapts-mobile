# 📱 TEA-PTS [mobile]

Esse repositório contém o aplicativo mobile do TEA-PTS, uma plataforma para elaboração e
manutenção de Programas Terapêuticos Singulares e atendimento de pessoas com Transtorno do Espectro
Autista (TEA).

## Pré-requisitos

- Flutter SDK 3.11.5+
- Dart SDK compatível
- Docker e Docker Compose
- VS Code ou Android Studio

## Instalação

### 1. Clonar o repositório

```bash
git clone https://github.com/Projetario-UTFPR/teapts-mobile.git
cd teapts-mobile
```

### 2. Configurar variáveis de ambiente

Crie um arquivo `.env` na raiz do projeto utilizando o arquivo de exemplo:

```bash
cp .env.sample .env
```

Gere as chaves pública e privada para o JWT do seguinte modo:
```bash
chmod u+x ./scripts/gen-keys.sh
./scripts/gen-keys.sh
```

Copie os valores gerados e cole nas respectivas variáveis de ambiente `JWT_PUBLIC_KEY` e `JWT_PRIVATE_KEY`.

### 3. Subir a infraestrutura local

```bash
docker compose up -d
```

Para configurações mais avançadas necessárias nos serviços relacionados ao back-end, confira o
[guia de desenvolvimento](https://github.com/Projetario-UTFPR/teapts-backend/blob/main/.github/docs/guia-de-desenvolvimento/index.md)
deste.

### 4. Instalar dependências

```bash
flutter pub get
```

### 5. Executar o aplicativo

```bash
flutter run
```

## Atualizando Dependências

Instalar dependências:

```bash
flutter pub get
```

Atualizar dependências:

```bash
flutter pub upgrade
```

## Estrutura

```text
lib/
├── config/
├── services/
├── screens/
├── widgets/
├── theme/
├── router.dart
└── main.dart
```

## Ambiente de Desenvolvimento

### Extensões Recomendadas (VS Code)

- Dart
- Flutter
- Awesome Flutter Snippets (opcional)

### Configuração Recomendada

Arquivo `.vscode/settings.json`:

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "always"
  }
}
```
