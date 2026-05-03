# 🏥 HealthSys Distribuído

> Plataforma de gestão hospitalar baseada em arquitetura de microservices distribuídos  
> Projeto Final — Computação Distribuída | Universidade de Fortaleza (Unifor) — 2026.1

---

## 📋 Visão Geral

O HealthSys Distribuído é uma plataforma para apoiar hospitais e unidades de saúde no gerenciamento de pacientes, prontuários eletrônicos e triagens médicas. O sistema utiliza uma arquitetura de microservices escalável e tolerante a falhas, implantada com Docker e orquestrada via Docker Compose.

---

## 🏗️ Arquitetura

```
                        ┌──────────────────────┐
         React Front    │      API Gateway      │
         :5173  ───────►│      :8080            │
                        └──────────┬───────────┘
                                   │
          ┌────────────────────────┼────────────────────────┐
          │                        │                        │
┌─────────▼────────┐   ┌───────────▼──────┐   ┌────────────▼─────┐
│  Serv. Usuários  │   │ Serv. Pacientes  │   │  Serv. Triagem   │
│  :8084           │   │ :8081            │   │  :8083           │
│  Spring Boot     │   │ Spring Boot      │   │  Spring Boot     │
│  PostgreSQL+JWT  │   │ PostgreSQL       │   │  PostgreSQL      │
└──────────────────┘   └──────────────────┘   └──────────────────┘
                                   │
          ┌────────────────────────▼────────────────────────┐
          │             Serv. Notificações :8085             │
          │             Spring Boot + RabbitMQ + PostgreSQL  │
          └─────────────────────────────────────────────────┘

  Infraestrutura:
  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────────┐  ┌──────────────┐
  │ RabbitMQ        │  │ Redis           │  │ Prometheus       │  │ Grafana      │
  │ :5672 / :15672  │  │ :6379           │  │ :9090            │  │ :3000        │
  └─────────────────┘  └─────────────────┘  └──────────────────┘  └──────────────┘
```

---

## 🚀 Tecnologias Utilizadas

| Categoria       | Tecnologias                            |
|-----------------|----------------------------------------|
| Frontend        | React, Vite                            |
| Backend         | Java 17, Spring Boot 3.2, Spring Cloud |
| Banco de Dados  | PostgreSQL 16                          |
| Mensageria      | RabbitMQ 3                             |
| Cache           | Redis 7                                |
| DevOps          | Docker, Docker Compose                 |
| Monitoramento   | Prometheus, Grafana                    |
| CI/CD           | GitHub Actions                         |
| Testes de Carga | k6                                     |

---

## 🔌 Serviços e Portas

| Serviço                | Porta       | Descrição                           |
|------------------------|-------------|-------------------------------------|
| Frontend (React)       | 5173        | Interface web da aplicação          |
| API Gateway            | 8080        | Roteamento e balanceamento de carga |
| Serviço de Usuários    | 8084        | Autenticação e controle de acesso   |
| Serviço de Pacientes   | 8081        | Cadastro e histórico de pacientes   |
| Serviço de Triagem     | 8083        | Triagem médica e classificação      |
| Serviço de Notificações| 8085        | Alertas e notificações assíncronas  |
| RabbitMQ UI            | 15672       | Painel de mensageria                |
| Grafana                | 3000        | Dashboard de monitoramento          |
| Prometheus             | 9090        | Coleta de métricas                  |

---

## ✅ Pré-requisitos

- Docker Desktop instalado e rodando
- Node.js 18+ (para o frontend)
- Git

---

## ⚙️ Como Executar

### 1. Clonar os repositórios

```bash
git clone https://github.com/joaoguicastro/Distribuida-API-Gateway
git clone https://github.com/joaoguicastro/Distribuida-Servico-Usuarios
git clone https://github.com/joaoguicastro/Distribuida-Servico-Pacientes
git clone https://github.com/joaoguicastro/Distribuida-Servico-Triagem
git clone https://github.com/joaoguicastro/Distribuida-Servico-Notificacoes
git clone https://github.com/joaoguicastro/Distribuida-Frontend  # repositório do front
```

### 2. Subir todos os serviços de backend

Na raiz do projeto, execute:

```powershell
.\start.bat
```

O script irá:
1. Criar a rede Docker compartilhada `healthsys-network`
2. Subir o API Gateway, RabbitMQ, Redis, Prometheus e Grafana
3. Aguardar o RabbitMQ ficar pronto
4. Subir os demais microservices em ordem

### 3. Subir o frontend

```bash
cd Distribuida-Frontend
npm install
npm run dev
```

Acesse: **http://localhost:5173**

### 4. Verificar se está tudo rodando

```powershell
docker ps
```

Todos os containers devem aparecer com status `Up`.

### 5. Acessar o sistema

| Interface     | URL                           | Credenciais        |
|---------------|-------------------------------|--------------------|
| Frontend      | http://localhost:5173         | —                  |
| API Gateway   | http://localhost:8080         | —                  |
| RabbitMQ UI   | http://localhost:15672        | guest / guest      |
| Grafana       | http://localhost:3000         | admin / healthsys  |
| Prometheus    | http://localhost:9090/targets | —                  |

### 6. Parar todos os serviços

```powershell
.\stop.bat
```

---

## 🔄 CI/CD — GitHub Actions

Cada microservice possui um pipeline de integração contínua configurado em `.github/workflows/ci.yml`.

A cada push na branch `main`, o pipeline executa automaticamente:

1. ✅ Checkout do código
2. ✅ Configuração do Java 17 (Eclipse Temurin)
3. ✅ Build com Maven (`mvn clean package -DskipTests`)
4. ✅ Build da imagem Docker

---

## 📊 Monitoramento

O sistema utiliza **Prometheus** para coleta de métricas e **Grafana** para visualização em tempo real.

Todos os serviços expõem métricas via Spring Boot Actuator no endpoint `/actuator/prometheus`.

**Para acessar o dashboard:**
1. Acesse http://localhost:3000
2. Faça login com `admin / healthsys`
3. Navegue até **Dashboards → HealthSys Monitoramento**

---

## 🧪 Resultados do Teste de Carga (k6)

Teste executado com **30 usuários simultâneos** durante **2 minutos**.

```
scenarios: 1 scenario, 30 max VUs, 2m30s max duration

checks_total.......: 2712     22.26/s
checks_succeeded...: 100.00%  2712 out of 2712

✓ gateway health OK
✓ pacientes respondeu
✓ triagem respondeu

http_req_duration:
  avg=5.07ms   min=508.6µs  med=4.63ms
  max=404.91ms p(90)=7.21ms p(95)=8.51ms

http_reqs..............: 2712   22.26/s
iterations.............: 904    7.42/s
vus_max................: 30
```

> **Conclusão:** O sistema respondeu 100% dos checks com latência média de **5ms** e p95 de **8.5ms**, demonstrando alta performance sob carga de 30 usuários simultâneos, atendendo ao requisito de resposta em até 2 segundos.

---

## 👥 Equipe

| Nome | Matrícula |
|------|-----------|
| Davi Pereira Menezes | 2315099 |
| Iury Rodrigues Barbosa | 2315700 |
| João Guilherme de Castro Ribeiro Rolim | 2310296 |
| Guilherme Amaral | 2310299 |
| Arthur Sales | — |

> Projeto desenvolvido para a disciplina de **Computação Distribuída**  
> Universidade de Fortaleza — Unifor | Semestre 2026.1