# inpecao_campo

Aplicativo Flutter de inspeção de campo com persistência local offline-first.

## Ordens de serviço no mapa

Administradores podem criar ordens de serviço pelo mapa. Essas ordens são
persistidas no banco local Drift e permanecem disponíveis no dispositivo.
O contrato da API atual só define `GET /work-orders`; não há endpoint de criação
de ordens. Por isso, a sincronização não envia ordens criadas localmente ao
servidor, e elas não são compartilhadas entre dispositivos.

Quando a API disponibilizar uma operação de criação, o envio poderá ser
integrado à fila de sincronização existente sem alterar a persistência local.

## Desenvolvimento

Execute `flutter analyze` e `flutter test` na pasta do projeto para validar as
alterações.
