# 📱 teapts-mobile

Aplicativo mobile do projeto TEA PTS desenvolvido em Flutter.

## Pré-requisitos

- Flutter SDK 3.11.5+
- Dart SDK compatível
- Docker e Docker Compose
- VS Code ou Android Studio

## Instalação

### 1. Clonar o repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd teapts-mobile
```

### 2. Configurar variáveis de ambiente

Crie um arquivo `.env` na raiz do projeto utilizando o arquivo de exemplo:

```bash
cp .env.sample .env
```

### 3. Subir a infraestrutura local

```bash
docker compose up -d
```

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