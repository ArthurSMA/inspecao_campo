# Inspecao de Campo
Aplicativo Flutter de inspeção de campo com persistência local offline-first destinado a registrar as ordens de serviço.

Estados das ordens de serviço:
- Em andamento 
- Continuar inspeção
- Concluir inspeção

## Como iniciar

### Necessário
Ter Flutter(Dart) configurado

Atualizar os pacotes:
```bash
flutter pub get 
```

Rodar a aplicação
```bash
flutter run
```

## Arquitetura do projeto

```Plaintext
lib/
├── core/
│    ├── network/
│    ├── utils/
│    └── widgets/
│
├── features/
│   ├── auth/
|   |    ├── data/
│   |    ├── domain/
│   |    └── presentation/
│   |
│   ├── home/
|   |    └── presentation/
|   |
│   ├── maps/
|   |    └── presentation/
|   |
│   └── work-orders/
|          └── presentation/
|
└── main.dart

```

## Ordens de serviço no mapa

Administradores podem criar ordens de serviço pelo mapa.
Funcionários técnicos podem efetuar as ordens de seviço já existentes na aplicação.
As ordens de serviço são persistidas para o funcionamento offline da aplicação.

## Desenvolvimento

Execute `flutter analyze` e `flutter test` na pasta do projeto para validar as
alterações.
