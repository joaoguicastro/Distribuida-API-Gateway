# HealthSys Distribuído

Sistema de gestão hospitalar baseado em arquitetura de microservices distribuídos, desenvolvido como projeto final da disciplina de Computação Distribuída — Universidade de Fortaleza (Unifor).

---

## Visão Geral

O HealthSys Distribuído é uma plataforma para apoiar hospitais e unidades de saúde no gerenciamento de pacientes, prontuários eletrônicos e triagens médicas. O sistema utiliza uma arquitetura de microservices escalável e tolerante a falhas, implantada com Docker e orquestrada via Docker Compose.

---

## Arquitetura

```
                        ┌─────────────────┐
                        │   API Gateway   │
                        │   :8080         │
                        └────────┬────────┘
                                 │
          ┌──────────────────────┼──────────────────────┐
          │                      │                      │
┌─────────▼────────┐  ┌──────────▼───────┐  ┌──────────▼───────┐
│ Serv. Usuários   │  │ Serv. Pacientes  │  │ Serv. Triagem    │
│ :8084            │  │ :8081            │  │ :8083            │
│ Spring Boot +    │  │ Spring Boot +    │  │ Spring Boot +    │
│ PostgreSQL + JWT │  │ PostgreSQL       │  │ PostgreSQL+Kafka │
└──────────────────┘  └──────────────────┘  └──────────────────┘
          │                                              │
┌─────────▼────────────────────────────────────────────▼──────┐
│                    Serv. Notificações :8085                  │
│                    Spring Boot + RabbitMQ + PostgreSQL       │
└─────────────────────────────────────────────────────────────┘

Infraestrutura:
  RabbitMQ :5672/:15672   Redis :6379
  Prometheus :9090        Grafana :3000
```

---

## Tecnologias Utilizadas

| Categoria      | Tecnologias                              |
|----------------|------------------------------------------|
| Backend        | Java 17, Spring Boot 3.2, Spring Cloud   |
| Banco de Dados | PostgreSQL 16                            |
| Mensageria     | RabbitMQ 3                               |
| Cache          | Redis 7                                  |
| DevOps         | Docker, Docker Compose                   |
| Monitoramento  | Prometheus, Grafana                      |
| CI/CD          | GitHub Actions                           |
| Testes         | k6 (teste de carga)                      |

---

## Serviços e Portas

| Serviço               | Porta | Descrição                            |
|-----------------------|-------|--------------------------------------|
| API Gateway           | 8080  | Roteamento e balanceamento de carga  |
| Serviço de Usuários   | 8084  | Autenticação e controle de acesso    |
| Serviço de Pacientes  | 8081  | Cadastro e histórico de pacientes    |
| Serviço de Triagem    | 8083  | Triagem médica e classificação       |
| Serviço de Notificações | 8085 | Alertas e notificações assíncronas  |
| RabbitMQ UI           | 15672 | Painel de mensageria                 |
| Grafana               | 3000  | Dashboard de monitoramento           |
| Prometheus            | 9090  | Coleta de métricas                   |

---

## Pré-requisitos

- Docker Desktop instalado e rodando
- Git

---

## Como Executar

### 1. Clonar os repositórios

```bash
git clone https://github.com/joaoguicastro/Distribuida-API-Gateway
git clone https://github.com/joaoguicastro/Distribuida-Servico-Usuarios
git clone https://github.com/joaoguicastro/Distribuida-Servico-Pacientes
git clone https://github.com/joaoguicastro/Distribuida-Servico-Triagem
git clone https://github.com/joaoguicastro/Distribuida-Servico-Notificacoes
```

### 2. Subir todos os serviços

Na raiz do projeto, execute:

```powershell
.\start.bat
```

O script irá:
1. Criar a rede Docker compartilhada `healthsys-network`
2. Subir o API Gateway, RabbitMQ, Redis, Prometheus e Grafana
3. Aguardar o RabbitMQ ficar pronto
4. Subir os demais microservices em ordem

### 3. Verificar se está tudo rodando

```powershell
docker ps
```

Todos os containers devem aparecer com status `Up`.

### 4. Acessar o sistema

| Interface    | URL                              | Credenciais       |
|--------------|----------------------------------|-------------------|
| API Gateway  | http://localhost:8080            | —                 |
| RabbitMQ UI  | http://localhost:15672           | guest / guest     |
| Grafana      | http://localhost:3000            | admin / healthsys |
| Prometheus   | http://localhost:9090/targets    | —                 |

### 5. Parar todos os serviços

```powershell
.\stop.bat
```

---

## CI/CD — GitHub Actions

Cada microservice possui um pipeline de integração contínua configurado em `.github/workflows/ci.yml`.

A cada push na branch `main`, o pipeline executa automaticamente:
1. Checkout do código
2. Configuração do Java 17
3. Build com Maven (`mvn clean package`)
4. Build da imagem Docker

---

## Monitoramento

O sistema utiliza Prometheus para coleta de métricas e Grafana para visualização.

Todos os serviços expõem métricas via Spring Boot Actuator no endpoint `/actuator/prometheus`.

Para acessar o dashboard:
1. Acesse http://localhost:3000
2. Faça login com `admin / healthsys`
3. Navegue até Dashboards → HealthSys Monitoramento

---

## Resultados do Teste de Carga (k6)

Teste executado com 30 usuários simultâneos durante 2 minutos.

```
checks_total.......: 2712     22.26/s
checks_succeeded...: 100.00%  2712 out of 2712

gateway health OK  ✓
pacientes respondeu ✓
triagem respondeu  ✓

http_req_duration:
  avg=5.07ms  min=508.6µs  med=4.63ms
  max=404.91ms  p(90)=7.21ms  p(95)=8.51ms

http_reqs..............: 2712   22.26/s
iterations.............: 904    7.42/s
vus_max................: 30
```

**Conclusão:** O sistema respondeu 100% dos checks com latência média de 5ms e p95 de 8.5ms, demonstrando alta performance sob carga de 30 usuários simultâneos.

---

## Equipe

Projeto desenvolvido para a disciplina de Computação Distribuída  
Universidade de Fortaleza — Unifor  
Semestre 2025.1
