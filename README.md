# README do Projeto de Avaliação 

## Introdução

Este repositório contém o projeto de avaliação, cujo objetivo é desenvolver uma solução para ajudar estagiários da Compass UOL. O sistema inclui uma API criada com o Serverless Framework, integrada a serviços da AWS, e um chatbot. As funcionalidades principais incluem conversão de texto em áudio e outras operações voltadas para a automação de tarefas comuns.

## Desenvolvimento da Avaliação

A avaliação foi desenvolvida em várias etapas, que incluem:

1. **Planejamento**: 
   - Definição dos requisitos do projeto.
   - Organização das tarefas utilizando o Trello para a gestão do trabalho em equipe.

2. **Implementação**:
   - **Frontend**: Desenvolvido com Flutter para fornecer uma interface amigável e responsiva.
   - **Backend**: Implementado com o Serverless Framework, utilizando serviços da AWS como Amazon Polly, S3 e DynamoDB.
   - **Chatbot**: Um bot Lex foi criado para auxiliar na interação com o sistema.

3. **Testes**:
   - Realização de testes unitários e funcionais para garantir a qualidade e a confiabilidade do sistema.

## Dificuldades Conhecidas

- Integração entre a primeira parte (API e Backend) e a segunda parte (Frontend e chatbot).
- Integração com o Slack para notificações e interações automatizadas.
- Ajustes no bot para lidar com cenários mais complexos e melhorar a usabilidade.

## Como Utilizar o Sistema

Siga os passos abaixo para configurar e utilizar o sistema:

1. **Clonar o Repositório**:

 ```
   git clone https://github.com/Compass-pb-aws-2024-JULHO-A/sprints-6-7-pb-aws-julho-a
   ```

2. **Criar uma Branch**:
   ```
   git checkout -b grupo-4
   ```
3. **Instalar Dependências**:
   ```
   npm install
   ```

4. **Configurar e Fazer o Deploy**:
   - Configure suas credenciais AWS de acordo com a documentação do projeto.
   - Navegue até a pasta da API e execute:
     ```
     serverless deploy
     ```
5. **Testar a API**:
   - **GET /**: Verifica se a API está funcionando corretamente.
   - **GET /v1**: Retorna a versão da API.
   - **POST /v1/tts**: Envia uma frase para ser convertida em áudio. Exemplo de payload:
     ```json
     {
       "phrase": "Sua frase aqui."
     }
     ```
## Export do Bot Lex

O bot Lex pode ser exportado em formato .zip e está disponível na pasta [/lex](./lex). Ao subir o repositório, certifique-se de incluir o arquivo .zip para garantir a compatibilidade.

## Observações Finais

Este projeto visa proporcionar uma solução prática e escalável para auxiliar estagiários em tarefas cotidianas.

# Colaboradores
<table>
  <tr>
    <td align="center">
      <a href="https://github.com/irdevp">
        <img src="https://avatars.githubusercontent.com/u/47428695?v=4" width="100px;" alt="Colaborador Igor"/><br>
        <sub>
          <b>⁠Igor M. Gonçalo</b>
        </sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/gabrielleg0mes">
        <img src="https://avatars.githubusercontent.com/u/92538624?v=4" width="100px;" alt="Colaboradora Gabrielle"/><br>
        <sub>
          <b>⁠Maria Gabrielle de S. Gomes</b>
        </sub>
      </a>
    </td>
     <td align="center">
      <a href="https://github.com/gabrielsantos578">
        <img src="https://avatars.githubusercontent.com/u/127057846?v=4" width="100px;" alt="Colaborador Gabriel"/><br>
        <sub>
          <b>Gabriel M. Santos</b>
        </sub>
      </a>
    </td>
  </tr>
</table>

