# Capítulo 1 — Entreguei. Não contei. E ninguém soube.

::: capitulo-meta
**Tema:** visibilidade proativa  
**Origem do feedback:** todos os ciclos, de 2022 a 2025
:::

::: capitulo-epigrafe
*"The single biggest problem in communication is the illusion that it has taken place."*

— George Bernard Shaw
:::

## A origem

Este é o feedback mais persistente de toda a minha trajetória. Ele apareceu nos quatro anos, por todos os líderes que tive e em comentários de colegas em praticamente todos os ciclos. Em 2022 ele vinha embrulhado como "fale mais nas cerimônias". Em 2025 já tinha virado "metrics-driven storytelling". A linguagem foi ficando mais sofisticada a cada ano. O gap por trás dela continuou exatamente o mesmo.

Quando um feedback atravessa quatro anos e várias pessoas diferentes, dizendo a mesma coisa com palavras diferentes, ele para de ser uma observação pontual. Vira um diagnóstico.

É também a primeira peça concreta do paradoxo que abre este livro: ser bem avaliado tecnicamente e, ainda assim, travar. Esse é o gap mais recorrente de toda a minha jornada — o mesmo que, lá no Capítulo 20, eu descubro que atravessou os quatro anos inteiros. Entendê-lo aqui, logo no começo, ajuda a reconhecê-lo nos outros capítulos.

## Onde errei

Eu fiz o trabalho. E fiz bem. Mas não contei para ninguém.

Eu acreditava, com uma convicção quase ingênua, que entregar era suficiente. Que bons resultados falam por si só. Que se o trabalho fosse bom o bastante, alguém naturalmente perceberia. Passei anos operando nessa crença.

Não funciona assim. Resultados não falam por si. Em quatro anos consecutivos, líderes e colegas diferentes me disseram a mesma frase com pequenas variações: *você está presente, mas parece ausente.* Eu estava lá, entregando — e mesmo assim a percepção era de alguém que não se sabia bem o que estava fazendo.

O erro não era só "não falar na daily". Era não traduzir trabalho técnico em informação que o time e a liderança conseguissem usar: riscos que eu tinha bloqueado, bugs que eu tinha encontrado antes da produção, tempo que eu tinha economizado ao pegar regressão cedo. Tudo isso existia — mas morria no meu caderno de testes, no ticket sem contexto, ou simplesmente na minha cabeça.

## O que aprendi

Demorei tempo demais para entender uma coisa simples: **visibilidade não é ego. É informação.**

Quando você não comunica o que está fazendo, você não deixa um espaço neutro. Você deixa um vazio — e as pessoas preenchem esse vazio com a interpretação que tiverem à mão, que raramente é a mais generosa. O silêncio sobre o próprio trabalho não é lido como humildade. É lido como ausência, como falta de progresso, às vezes até como falta de competência.

O impacto de um trabalho só existe, do ponto de vista da organização, se alguém o comunica. E essa pessoa precisa ser você. Ninguém vai narrar a sua contribuição por você — nem o seu líder, que tem dez outras pessoas para acompanhar, nem o colega, que está ocupado narrando a dele.

Para QA, isso tem uma camada extra: **o valor do nosso trabalho muitas vezes é preventivo**. Um bug que não chegou em produção não deixa rastro visível para quem não estava olhando. Se você não contar que ele existiu e que você o interceptou, a percepção externa é "nada aconteceu" — e "nada aconteceu" não constrói reputação.

## Como acertar

A virada começa quando você passa a tratar visibilidade como um **entregável**, e não como algo opcional que você faz quando sobra tempo (nunca sobra).

Na prática, isso significou para mim adotar um status semanal curto: o que fechei, o que encontrei, o que vem a seguir. A chave é que não seja um relatório burocrático e sim uma narrativa com impacto — três linhas que contam uma história mínima sobre o valor que aquele trabalho gerou.

Visibilidade vira rotina, não inspiração. Você não comunica quando se lembra ou quando está animado. Você comunica porque é parte do trabalho, do mesmo jeito que escrever um teste é parte do trabalho.

Quando o feedback evoluiu para "metrics-driven storytelling", entendi que números sozinhos também não bastam — mas **números dentro de uma história** mudam completamente o jogo. Não é inflar resultado. É dar escala ao que você já fez: "3 bugs críticos bloqueados antes do deploy" pesa mais do que "testei a sprint".

::: game-spread

::: game-spread-hero
### O framework GAME

**G**oal → **A**ction → **M**easure → **E**xpectation
:::

::: game-spread-intro
Visibilidade sem formato vira barulho. O **GAME** é o roteiro que traduz trabalho de QA em narrativa que o time consegue usar — quatro blocos que respondem às perguntas que ninguém te fez em voz alta: *o que estava em jogo? o que você fez? qual foi o efeito? o que vem agora?*

Para QA, isso importa porque o valor do nosso trabalho é muitas vezes **preventivo**. Bug bloqueado, regressão pega cedo, risco levantado no refinamento: se você não nomear o impacto, a percepção externa continua sendo "nada aconteceu". O GAME não inventa resultado — **torna visível** o que já aconteceu.
:::

::: {.game .game-grid}

::: game-item
**Goal**

O que estava em jogo

"Release do checkout com 12 histórias na fila de QA"
:::

::: game-item
**Action**

O que você fez

"Priorizei fluxo de pagamento e rodei regressão nos 3 gateways"
:::

::: game-item
**Measure**

O impacto mensurável ou concreto

"2 bugs P1 bloqueados; deploy liberado sem rollback"
:::

::: game-item
**Expectation**

O que vem agora

"Cobertura de API do carrinho na segunda"
:::

:::

::: game-spread-rule
**A regra de ouro:** nunca entregue só a Action. Action sem Measure parece atividade. Measure sem Goal parece exagero. Expectation sem os três anteriores parece pedido solto no vazio.
:::

::: game-spread-channels
- Status semanal no canal do time
- Comentário no ticket (Jira / Azure DevOps)
- Fala na daily ou planning
- Post-mortem e descrição de PR
:::

::: game-spread-footer
Quatro linhas. Menos de um minuto. O mesmo trabalho — a diferença é se alguém consegue *agir* com a informação.
:::

:::

### Antes e depois (um exemplo real)

**Antes.** Numa release de onboarding, encontrei e bloqueei dois bugs que teriam quebrado o cadastro de novos clientes. Fechei os tickets e segui para a próxima tarefa. Na review do mês, ninguém mencionou — porque ninguém soube. Para o time, foi mais uma sprint silenciosa de QA.

**Depois.** Sprint seguinte, entrega parecida. Dessa vez mandei três linhas no canal do time: *"Testei o fluxo de onboarding desta release. Encontrei e bloqueei 2 bugs críticos que teriam impedido o cadastro de novos clientes. Próximo: cobertura de API do login."* Mesma entrega. Reação completamente diferente: o PO respondeu na hora, e o líder citou o caso na review como exemplo de risco evitado.

A diferença entre as duas sprints não foi o trabalho — foi uma frase no formato GAME que custou trinta segundos para escrever.

## Passos práticos

1. **Status semanal de três linhas.** Toda sexta-feira, antes de encerrar, escreva um status fixo no canal do time: o que fechou, o que encontrou, o que vem a seguir. Use sempre o mesmo template do **Apêndice A** — isso reduz a fricção a quase zero nos dias de menor energia.
2. **Nunca entre numa cerimônia sem ter algo a dizer.** Antes de cada reunião, prepare uma observação ou uma pergunta. Uma só já basta para deixar de ser presença passiva e virar presença percebida.
3. **Documente bugs com contexto de impacto, não só descrição técnica.** Em vez de só descrever o defeito, registre o que ele poderia ter custado — para o usuário, para o fluxo, para a entrega. A mesma informação técnica, com impacto explícito, tem peso completamente diferente.
4. **Ao finalizar uma iniciativa, escreva um post-mortem curto e compartilhe.** Não precisa ser longo. Precisa existir e ser visível.
5. **Leve o aprendizado para fora.** Escrever publicamente — em posts sobre "o que aprendi fazendo X", baseados em situações reais — é a forma mais poderosa de transformar trabalho silencioso em reputação. Este livro é exatamente isso.

## Aplicando na prática de QA

Visibilidade para QA não é "marketing pessoal". É **reduzir incerteza** para quem depende do seu trabalho: PO, devs, líderes, SRE, suporte.

### O que vale tornar visível (e o que não vale)

**Vale tornar visível:**

- Bugs encontrados **antes** de produção, com severidade e área afetada
- Riscos levantados durante refinamento ou teste exploratório
- Bloqueios reais (ambiente instável, dado de teste ausente, dependência externa)
- Decisões de priorização de teste ("testei X antes de Y porque...")
- Métricas de sprint com contexto: tempo em QA, retornos de dev, cobertura de cenários críticos

**Não vale (ou atrapalha):**

- Listar cada caso de teste executado sem filtro
- Status vago ("testando", "em progresso") sem objeto
- Reclamar de processo sem propor alternativa
- Métricas soltas sem narrativa ("executei 847 casos")

### Métricas que contam história

Escolha **duas ou três métricas por sprint** e amarre cada uma a uma decisão ou resultado:

| Métrica | O que ela mostra | Como contar a história |
|---------|------------------|------------------------|
| Bugs críticos/altos bloqueados pré-prod | Qualidade interceptada | "Impedimos 2 P1 no fluxo de login — afetariam 100% dos usuários" |
| Cycle time em QA | Velocidade de feedback | "História X ficou 1 dia em QA; devolvemos com evidência em 4h" |
| Retorno de dev por sprint | Clareza dos reportes | "3 de 5 bugs voltaram fechados na primeira correção" |
| Cenários críticos cobertos vs. planejados | Foco vs. volume | "100% dos happy paths de pagamento; edge cases ficam para próxima sprint" |

O objetivo não é virar analista de dados. É dar **escala** ao trabalho que já aconteceu.

### Canais certos para cada mensagem

| Canal | Melhor para | Frequência |
|-------|-------------|------------|
| Canal do time (Slack/Teams) | Status semanal, risco urgente | Semanal + ad hoc |
| Comentário no ticket (Jira/Azure) | Progresso, evidência, impacto do bug | Contínuo |
| Daily/Planning | Decisão de prioridade, bloqueio | Por cerimônia |
| Página viva (Confluence/Notion) | Mapa de riscos, cobertura da release | Por release |
| Demo assíncrona (Loom/gravação) | Bug complexo, fluxo difícil de explicar por texto | Quando necessário |

Regra prática: **informação que muda decisão hoje → canal síncrono ou thread com @.** Informação que constrói histórico → ticket ou wiki.

## As objeções que você vai sentir

Você vai resistir a isso — eu resisti por quatro anos. As desculpas têm sempre a mesma cara, e vale derrubar cada uma antes que ela te paralise:

**"Isso não é se autopromover?"** Não. Autopromoção é falar de você; visibilidade é informar um fato útil para quem depende do seu trabalho. "Bloqueei 2 bugs no checkout" não é vaidade — é informação que muda o nível de confiança do time na entrega.

**"Não tenho tempo."** O status semanal custa menos de cinco minutos. O que custa caro é o contrário: refazer trabalho que ninguém viu, ser percebido como ausente e descobrir no review anual que o esforço não chegou a ninguém.

**"Meu time não lê status."** Comece pequeno e mire na pessoa certa: @ o PO ou o dev no que muda a decisão dele hoje. Consistência cria leitura — depois de algumas semanas, as pessoas passam a esperar o seu update.

**E o risco oposto:** comunicar demais também queima. Visibilidade não é narrar cada caso de teste nem despejar 847 números. É escolher o que muda uma decisão ou constrói histórico — e deixar o resto quieto.

## Para levar deste capítulo

- **Visibilidade não é ego, é informação.** O impacto do seu trabalho só existe para a organização se alguém o comunica — e essa pessoa precisa ser você.
- **Para QA, o valor é muitas vezes invisível** (o bug que não chegou em produção). Se você não conta que interceptou o risco, a percepção externa é "nada aconteceu".
- **Trate visibilidade como entregável, em sistema, não em inspiração.** Três linhas por semana no formato GAME movem mais a sua reputação do que qualquer entrega isolada.

## Materiais de apoio

Os **templates prontos** (status semanal, bugs com impacto, post-mortem, PR e cerimônia) e o guia de **ferramentas e configurações** (ferramenta de tickets, canal do time, página viva, etc.) estão nos **apêndices**, no final do livro — para consulta quando for executar o laboratório.

## Laboratório do capítulo

Execute estas atividades na **próxima sprint**. Cada uma tem entregável e critério de "feito". Tempo total estimado: **3–4 horas** espalhadas pela sprint — não faça tudo num dia.

### Atividade 1 — Auditoria de visibilidade (45 min)

**Objetivo:** descobrir o que você entregou vs. o que o time de fato soube.

1. Liste tudo que você entregou na sprint passada (bugs encontrados, histórias validadas, automações, documentação).
2. Para cada item, marque: *alguém fora de QA mencionou ou reagiu a isso?* (sim/não)
3. Classifique os "não" por motivo: esqueci de comunicar / comuniquei mal / ninguém estava olhando.
4. Escolha **os 3 itens de maior impacto** que ficaram invisíveis e reescreva cada um em formato GAME.

**Entregável:** tabela com pelo menos 8 itens auditados + 3 reescritos em GAME.

**Feito quando:** você consegue apontar qual item invisível teria mudado uma decisão se tivesse sido comunicado a tempo.

### Atividade 2 — Status semanal por 4 semanas (15 min/semana)

**Objetivo:** instalar o hábito antes de confiar na motivação.

1. Agende lembrete recorrente (sexta-feira, mesmo horário).
2. Poste o template de status semanal no canal do time durante **4 semanas seguidas** — sem falhar.
3. Na 4ª semana, pergunte a um colega ou ao EM: *"Está claro o que QA está fazendo?"* Anote a resposta.

**Entregável:** 4 posts + nota com feedback recebido.

**Feito quando:** alguém referencia seu status espontaneamente ("vi no seu update de sexta...").

### Atividade 3 — Upgrade de 3 bugs com impacto (30 min)

**Objetivo:** praticar documentação que gera prioridade, não só registro.

1. Abra 3 bugs que você reportou (recentes ou históricos).
2. Para cada um, adicione seção **Impacto** usando o template do **Apêndice A**.
3. Se o bug ainda estiver aberto, @ menção ao PO ou dev com uma linha GAME no comentário.

**Entregável:** 3 tickets atualizados.

**Feito quando:** pelo menos 1 ticket teve resposta ou mudança de prioridade atribuível ao contexto de impacto.

### Atividade 4 — Kit de cerimônia (20 min + uso contínuo)

**Objetivo:** nunca mais entrar mudo numa reunião.

1. Fixe o template "Preparação para cerimônia" (Apêndice A) no bloco de notas.
2. Use em **todas as dailies/plannings** da sprint.
3. Registre quantas vezes você falou vs. ficou calado.

**Entregável:** checklist preenchido por reunião (pode ser privado).

**Feito quando:** você contribuiu com pelo menos **1 fala substantiva por cerimônia** durante 5 dias úteis.

### Atividade 5 — Página de release ou post-mortem (1 h)

**Objetivo:** criar artefato persistente — visibilidade que não depende de você estar na sala.

1. Escolha a release ou iniciativa atual.
2. Crie página (página viva ou Markdown no repo) usando o template de post-mortem do **Apêndice A**.
3. Compartilhe link no canal do time ao fechar a sprint.

**Entregável:** 1 página publicada + link compartilhado.

**Feito quando:** alguém usa a página em reunião ou comenta no link.

### Checklist de conclusão do laboratório

Marque ao final da sprint:

- [ ] Auditoria de visibilidade concluída
- [ ] 4 status semanais publicados
- [ ] 3 bugs com seção de impacto
- [ ] Fala substantiva em cerimônias (5 dias)
- [ ] Post-mortem ou página de release compartilhada

Se completou 4 de 5, o capítulo cumpriu o objetivo. O quinto item vira meta da sprint seguinte.

## Para ir além

Estes são os livros que mais me ajudaram a fechar este gap. Não precisa ler todos — escolha o que conversa com o seu momento.

**Da estante:**

- **StoryBrand**, de Donald Miller — comunicar o próprio trabalho é, no fundo, contar uma história clara em que o valor fica óbvio.
- **Storytelling com Dados**, de Cole Nussbaumer Knaflic — para transformar números soltos em narrativas que as pessoas entendem e lembram.
- **Comece pelo Porquê**, de Simon Sinek — sobre começar a comunicação pelo motivo, não pela tarefa.
- **29 Minutos para Falar Bem em Público**, de Reinaldo Polito — para a parte que mais dói: falar nas cerimônias sem travar.

**Internacionais:**

- **Show Your Work**, de Austin Kleon — um manifesto curto e direto sobre por que mostrar o processo, e não só o resultado, é o que constrói visibilidade.
- **The Personal MBA**, de Josh Kaufman — para entender que ser visto e compreendido é uma competência de negócio, não um detalhe.

---

*Você já entregou algo bom que ninguém percebeu? Escolha uma atividade do laboratório, execute nesta sprint, e volte aqui na retro para marcar o checklist.*
