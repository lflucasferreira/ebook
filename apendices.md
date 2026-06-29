# Templates prontos {.apendice}

Modelos para copiar e usar nos capítulos do livro.

## Capítulo 1 — Visibilidade proativa

### Status semanal

```
📋 QA — semana [DD/MM]

✅ Fechado: [1–3 entregas com resultado, não só tarefa]
🔍 Encontrado: [bugs/riscos relevantes + impacto em uma linha]
➡️ Próximo: [foco da semana que vem]

Release [X.Y]: [no prazo / risco / bloqueio — opcional]
```

### Preparação para cerimônia (5 min antes)

```
1. Uma entrega concreta desde a última cerimônia: ___
2. Um risco ou bloqueio que o time precisa saber: ___
3. Uma pergunta ou decisão que preciso do time: ___
```

Se sobrar só um item, use o 2. Risco bem comunicado posiciona QA como parceiro, não como gargalo.

### Bug com impacto (Jira / Azure DevOps)

```
## Impacto
- Usuários afetados: [todos / segmento / % estimado]
- Fluxo: [checkout / login / integração X]
- Risco se ir para prod: [perda financeira / bloqueio / workaround]

## Evidência
- Ambiente: [staging / prod-like]
- Passos: [...]
- Anexo: [screenshot / vídeo / log]
```

### Post-mortem curto (máximo 1 página)

```
# Post-mortem QA — [Release / Iniciativa]

## O que testamos
- Escopo: [...]
- Fora do escopo (e por quê): [...]

## Principais achados
| ID | Severidade | Impacto se em prod | Status |
|----|------------|-------------------|--------|

## O que funcionou
- [...]

## O que melhorar na próxima
- [ ] Ação 1 — dono — prazo

## Métricas (opcional)
- Bugs pré-prod P1/P2: X
- Tempo médio em QA: Y dias
```

### Comentário de progresso no ticket

```
[QA Update — DD/MM]
Goal: [contexto / o que estava em jogo]
Action: [cenários / ambientes / o que você fez]
Measure: [pass / fail / bloqueado — impacto concreto]
Expectation: [próximo passo ou dependência]
```

### Descrição de PR (QA / automação)

```
## Contexto
História PROJ-123 — fluxo de reembolso

## O que foi validado
- Happy path manual + regressão API
- Cenário de timeout (bug PROJ-456 encontrado)

## Risco remanescente
Edge case de moeda estrangeira — sem massa de dados em staging
```

# Ferramentas e configurações {.apendice}

Você não precisa de um stack novo. Use o que o time já tem — com campos e hábitos melhores.

## Capítulo 1 — Visibilidade proativa

### Jira / Azure DevOps — tickets com impacto

Configure (ou peça para configurar) um campo **Impacto de negócio** ou use a descrição com seção fixa. Veja o template de bug com impacto em **Templates prontos** (apêndice anterior).

**Automação útil:** se o time usa Jira Automation, crie regra para postar no Slack quando bug P1/P2 for aberto por QA — visibilidade instantânea sem reunião extra.

### Slack / Microsoft Teams — status semanal

Crie um **post fixo** ou use lembrete recorrente (sexta, 16h). Fixe o template de status semanal na descrição do canal ou num canvas do Teams.

Integrações que ajudam:

- **Workflow do Slack:** formulário curto que formata a mensagem no padrão GAME
- **Lembretes nativos:** `/remind` no Slack ou equivalente no Teams
- **Thread por release:** uma thread por versão; você atualiza ao longo da sprint

### Confluence / Notion — página de release QA

Uma página por release com seções fixas:

1. Escopo testado (links para tickets)
2. Riscos conhecidos aceitos
3. O que **não** foi testado e por quê
4. Métricas da sprint (2–3 números com contexto)
5. Post-mortem linkado ao fechar

Isso vira artefato que líderes consultam em review — sem você precisar "vender" na hora.

### GitHub / GitLab — PRs e descrições

Em times que QA comenta ou abre PR de testes/automação, use a descrição para visibilidade: contexto da história, o que foi validado, risco remanescente. Veja o template de PR em **Templates prontos**.

### Loom (ou similar) — demo assíncrona

Para bugs visuais, race conditions ou fluxos longos: **gravação de 2–3 minutos** vale mais que dez comentários no ticket. Cole o link no Jira e na thread da release. Funciona especialmente bem com times remotos ou líderes em fusos diferentes.

### Planilha pessoal de visibilidade

Se o time ainda não tem cultura de wiki, mantenha uma planilha simples (Google Sheets / Excel) só sua:

| Data | Entregável | Quem precisava saber | Comuniquei? | Canal | Resultado percebido |
|------|------------|----------------------|-------------|-------|---------------------|
| 2026-03-07 | 2 P1 bloqueados | Product Owner (PO), Engineering Manager (EM) | Sim — Slack | #team-qa | Product Owner (PO) priorizou hotfix |

Revise na retro. Em um mês, você enxerga padrões: o que você faz bem e esquece de contar.

# Citações originais {.apendice}

As epígrafes dos capítulos aparecem em português na abertura de cada capítulo. Abaixo, o texto original em inglês.

## Capítulo 1 — Entreguei. Não contei. E ninguém soube.

*"The single biggest problem in communication is the illusion that it has taken place."*

— George Bernard Shaw

## Capítulo 2 — Automatizei antes de testar. E atrasei a entrega.

*"Premature optimization is the root of all evil."*

— Donald Knuth
