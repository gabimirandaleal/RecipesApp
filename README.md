# RecipesApp 🍽️

App iOS em SwiftUI para explorar receitas por categoria, consumindo a API pública [TheMealDB](https://www.themealdb.com/api.php), com tradução do conteúdo por IA, analytics e experimento A/B.

## :shipit: Evidências

<details>
  <summary>Visualizar</summary>

  | App rodando | Experimento botão YouTube |
  |--------------|--------------|
  | <video src="https://github.com/user-attachments/assets/50c9756e-c248-454c-8a22-c229ba196e38"> | <video src="https://github.com/user-attachments/assets/7c716ce4-8ba3-4180-8935-19830fcbe1d1"> |

</details>


## Sobre o projeto

Projeto pessoal para praticar decisões de arquitetura, testes e integração com serviços externos em um app SwiftUI moderno. A TheMealDB foi escolhida por ser **gratuita e sem chave de API**: qualquer pessoa pode clonar e rodar o app sem configurar nada.

## Como rodar

1. Clone o repositório
2. Abra `RecipesApp.xcodeproj` no Xcode 16 ou superior
3. Rode em um simulador ou iPhone com **iOS 17+**
4. Testes: `Cmd + U`

Não há dependências externas.

### Tradução com IA (opcional)

Sem configuração, o app funciona normalmente e mostra o conteúdo como vem da API, em inglês. Para ativar a tradução:

1. Crie um arquivo `Secrets.xcconfig` na raiz do projeto, ao lado do `Config.xcconfig`
2. Adicione a linha `ANTHROPIC_API_KEY = sua-chave`
3. Rode o app com o idioma do aparelho (ou do Scheme) em português

O `Secrets.xcconfig` está no `.gitignore` e nunca vai para o repositório.

## Funcionalidades

- Lista de categorias de receitas
- Receitas de cada categoria
- Detalhe da receita: foto, origem, tags, ingredientes com medidas, modo de preparo e link para o vídeo
- Estados de carregamento, lista vazia e erro em todas as telas
- Interface em inglês e português (String Catalog)
- Tradução automática do conteúdo da API para o idioma do app, usando a API do Claude
- Analytics dos principais eventos do funil
- Experimento A/B na posição do botão do YouTube
- Menu de debug, aberto ao chacoalhar o aparelho, para forçar variantes do experimento

O fluxo usa três rotas da API:

```
categories.php  →  filter.php?c={categoria}  →  lookup.php?i={id}
```

## Arquitetura

**MVVM-C**, com um `Router` no papel do Coordinator.

```
RecipesApp/
  App/           Ponto de entrada, Router, composição das telas e menu de debug
  Domain/        Modelos e protocolos (repositórios e tradutores), sem dependência de rede
  Data/          DTOs, mappers, repositórios remotos e tradutores com IA
  Features/      Uma pasta por tela: View + ViewModel
  Analytics/     Eventos e rastreadores
  Experiments/   Experimentos, variantes e provedores
RecipesAppTests/
  Mocks/, Stub/  Implementações falsas usadas pelos testes
```

### Decisões técnicas

**SwiftUI com `@Observable` (iOS 17+).** Menos boilerplate que `ObservableObject`, e a View só se atualiza quando a propriedade que ela lê muda.

**Router com `NavigationStack(path:)`.** A navegação é um array de rotas (`enum Route: Hashable`) controlado num único lugar. As telas não se conhecem e a navegação pode ser testada sem abrir tela nenhuma. Existe um único `NavigationStack`, na raiz.

**MVVM-C.** Para o tamanho deste app, MVVM com um Router dá a separação necessária (a View só desenha, a ViewModel decide, o Router navega) com pouca cerimônia. Camadas adicionais trariam boilerplate sem ganho real.

**DTO, domínio e mapper separados.** Os DTOs espelham a API como ela é (campos opcionais, strings vazias, `null`). Os mappers convertem para modelos de domínio limpos. Se a API mudar, só DTO e mapper mudam.

**Modelo leve para a lista, completo para o detalhe.** O `filter.php` devolve só id, nome e foto; o `lookup.php`, a receita completa. Um modelo único cheio de opcionais esconderia a diferença entre "a receita não tem ingredientes" e "os ingredientes ainda não foram buscados".

**Leitura defensiva dos ingredientes.** A API entrega `strIngredient1...20` e `strMeasure1...20` como campos soltos, às vezes com buracos na numeração. Eles são lidos por índice com uma `DynamicCodingKey` (sem force unwrap), pareados com `zip` e filtrados com `compactMap`.

**Dados inválidos não derrubam a tela.** Receita sem id ou nome é descartada pelo mapper; `meals: null` vira lista vazia.

**Dependências atrás de protocolos.** Repositórios, tradutores, analytics e experimentos são protocolos injetados nas ViewModels. Isso permite trocar implementações nos testes e plugar serviços reais sem mexer nas telas.

**Estado da tela como `enum`.** Cada ViewModel expõe `idle`, `loading`, `success`, `empty` e `error`, com escrita privada. Estados impossíveis não podem existir.

**Carga única por tela.** As listas carregam só quando o estado ainda é `idle`. Voltar de outra tela não repete a requisição (nem a tradução, que tem custo).

**Concorrência.** ViewModels, Router, analytics e experimentos são `@MainActor`; repositórios e modelos de domínio são `Sendable`.

### Tradução com IA

- A interface usa **String Catalog** e segue o idioma do sistema, inclusive a escolha de idioma por app nos Ajustes do iOS.
- O conteúdo da API é traduzido pela **API do Claude** (`claude-haiku-5-5`) para o mesmo idioma da interface (`Bundle.main.preferredLocalizations`). Uma IA entende o contexto de cozinha: "1 cup" vira "1 xícara", "pinch" vira "uma pitada".
- Só os campos traduzíveis são enviados, num JSON com a mesma estrutura de volta. Nome do prato, imagens e links nunca passam pela IA.
- O nome da categoria usado na API e no analytics (`apiName`) é mantido separado do nome exibido. Assim a busca continua funcionando e os eventos são os mesmos em qualquer idioma.
- Se a tradução falhar, o conteúdo original é exibido. Uma falha da IA nunca vira tela de erro.
- Com o app em inglês ou sem chave configurada, nenhuma chamada é feita.

### Analytics e experimento A/B

- `AnalyticsEvent` é um `enum`: o compilador impede eventos com nome digitado errado. `ConsoleAnalyticsTracker` imprime os eventos; um tracker para Amplitude ou similar seria outra implementação do mesmo protocolo.
- Eventos: `category_selected`, `recipe_detail_viewed`, `youtube_link_tapped` e `experiment_exposed`.
- **Experimento:** botão do YouTube no fim da tela (controle) ou logo abaixo da foto (tratamento). Hipótese: no topo, mais pessoas tocam no vídeo. Métrica: `youtube_link_tapped` / `recipe_detail_viewed` em cada grupo.
- A variante é sorteada uma vez e persistida, para que a mesma pessoa veja sempre a mesma versão.
- **Menu de debug** (somente DEBUG): chacoalhe o aparelho para forçar uma variante ou sortear de novo.

## Testes

Escritos com **Swift Testing**, sem chamadas de rede.

| Alvo | O que garante |
|---|---|
| Mappers | Conversão da API para o domínio: campos ausentes, strings vazias, buracos na numeração dos ingredientes, tags |
| ViewModels | Transições de estado (sucesso, vazio, erro), mensagens de erro corretas e eventos de analytics |
| Router | Rotas empilhadas na ordem correta |

Mocks, spies e stubs ficam no target de testes, então nunca entram no app. As mensagens de erro são comparadas via `String(localized:)`, então os testes passam em qualquer idioma de máquina.

## Limitações conhecidas

- A chave da API fica no binário do app. É aceitável para um projeto pessoal, não para produção.
- Sem cache: cada abertura de receita em português gera uma nova chamada de tradução.
- Se a tradução falhar, o usuário não é avisado; ele apenas vê o conteúdo original.
- Repositórios remotos e tradutores não têm testes próprios.
- Os previews usam os repositórios reais e dependem de internet.
- Sem pipeline de CI.
- Revisão de acessibilidade (VoiceOver e Dynamic Type) pendente.

## Próximos passos

- **Backend próprio para a IA:** o app chamaria um serviço que guarda a chave e repassa o pedido, sem expor a chave no aplicativo.
- **Cache como decorator dos repositórios e tradutores:** a ViewModel continuaria igual, e a mesma tradução nunca seria paga duas vezes.
- **Testes de rede** com um `URLProtocol` falso, validando URL, status HTTP e decodificação sem chamar as APIs reais.
- **Snapshot tests** dos estados de cada tela, com simulador fixo no CI.
- **CI** com GitHub Actions rodando `xcodebuild test` a cada pull request.
- **Feature flags remotas** no lugar do sorteio local, para controlar a divisão dos grupos sem nova versão do app.
- **Modularização** em Swift Packages (Domain, Data e cada Feature).
- **Paginação:** a TheMealDB não pagina. Com uma API que paginasse, a próxima página seria carregada quando o último item aparecesse.
