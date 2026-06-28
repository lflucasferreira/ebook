# Capítulo 2 — Automatizei antes de testar. E atrasei a entrega.

> **Tema:** sequenciamento no sprint
> **Origem do feedback:** mid-review de 2024 e ciclo anual de 2025

## A origem

Este feedback foi sinalizado primeiro por um colega, no mid-review de 2024: que às vezes eu parecia gastar tempo demais no processo de automação, fazendo com que tarefas ficassem mais tempo do que o necessário sem serem testadas. No ano seguinte, o mesmo ponto voltou — agora formalizado pelo líder, no review anual, sob os nomes de *agile efficiency* e *sense of urgency*.

Duas pessoas diferentes, dois ciclos diferentes, apontando para a mesma coisa: a ordem em que eu fazia as coisas estava custando caro.

## Onde errei

Eu construía a suíte de automação antes de ter testado manualmente.

A lógica parecia impecável: automatizar cedo, garantir cobertura desde o começo, sair na frente. No papel é uma decisão de engenheiro maduro. Na prática do sprint, ela criava um problema silencioso: a tarefa ficava parada em "Waiting QA" enquanto eu construía infraestrutura de teste. Por fora, ninguém via a suíte sendo montada com capricho. O que se via era uma tarefa estacionada.

A percepção externa era de lentidão — mesmo quando a entrega final tinha qualidade superior à média. E percepção, num time, é o que vira reputação.

## O que aprendi

No contexto de uma sprint, **velocidade de feedback é tão importante quanto profundidade de cobertura.**

Um bug encontrado num teste manual no dia 1 vale mais do que uma suíte de automação completíssima entregue no dia 5. O bug do dia 1 ainda dá tempo de consertar sem reabrir tudo, sem pressão, sem virar bloqueio de release. O do dia 5 chega quando o time já contava com a entrega.

A conclusão foi desconfortável de aceitar, porque eu gostava da parte da automação: **automação deve seguir a validação, não precedê-la.** Primeiro você descobre se funciona. Depois você protege o que funciona.

## Como acertar

A regra pessoal que adotei é simples de enunciar e difícil de manter quando bate a vontade de já abrir o editor: **teste manual primeiro, sempre.**

A automação só começa depois que o happy path foi validado manualmente. E cada fase ganha um timebox rígido — um tempo máximo para os testes manuais, outro para a automação — para que nenhuma das duas se expanda e engula a entrega. O objetivo não é automatizar menos. É automatizar na hora certa, depois que o valor já foi entregue e o risco já foi reduzido.

## Passos práticos

1. **Timebox fixo para os testes manuais antes de tocar em qualquer código de automação.** Defina o tempo, valide o caminho principal, e só então decida o que vale a pena automatizar.
2. **Comece pelo happy path manual.** Garanta que o fluxo essencial funciona e está validado antes de investir em infraestrutura de teste automatizado.
3. **Tarefas de alto impacto entram em teste no mesmo dia.** Não deixe acumular: o que destrava mais valor para o sprint é testado primeiro, mesmo que seja menos interessante tecnicamente.
4. **Automatize as tarefas de impacto médio depois da validação manual da tarefa de alto impacto — nunca antes.** A ordem importa mais do que a quantidade de cobertura.
5. **Na retrospectiva, revise se houve tarefas de alto impacto paradas enquanto tarefas menores avançavam.** Esse é o sintoma clássico de sequenciamento invertido — e o melhor lugar para corrigi-lo antes que vire feedback de review.

## 📚 Para ir além

- **Essencialismo**, de Greg McKeown — sobre fazer menos, porém o que realmente importa, na ordem certa.
- **A Única Coisa**, de Gary Keller — a pergunta que organiza qualquer dia: qual é a única coisa que, se feita agora, torna o resto mais fácil ou desnecessário?
- **O Princípio 80/20**, de Richard Koch — para identificar a fração do esforço que gera a maior parte do valor.
- **A Tríade do Tempo**, de Christian Barbosa — sobre priorizar pelo que é importante, não pelo que é urgente ou conveniente.
- **The Deadline**, de Tom DeMarco — um romance sobre gestão de projetos que ensina, sem moralismo, por que entregar no ritmo certo vale mais do que entregar perfeito tarde demais.
- **Accelerate**, de Nicole Forsgren, Jez Humble e Gene Kim — a base de dados por trás da ideia de que ciclos curtos de feedback são o que separa times de alta performance dos demais.

---

*Na sua última sprint, a ordem em que você pegou as tarefas seguiu o que era mais valioso para o time — ou o que era mais confortável para você?*
