# 🪐 Asteroid B-612: Homelab & Self-Healing System

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E94331?style=for-the-badge&logo=ubuntu&logoColor=white)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)


O **Asteroid B-612** é um ecossistema de infraestrutura resiliente focado em alta disponibilidade e automação. O projeto utiliza **Docker** para virtualização e **Shell Scripting** para garantir que os serviços críticos se recuperem automaticamente de falhas.

---

## Tecnologias e Ferramentas
* **Host OS:** Ubuntu Server
* **Orquestração:** Docker & Docker Compose v5.0.1 :whale:
* **Automação:** Bash Scripting + Crontab
* **Serviços Atuais:** TeamSpeak Server & Playit.gg (Network Tunneling) + Crafty Controller & Playit.gg

## Estrutura do Repositório
```text
b612-homelab/
├── services/
│   ├── teamspeak/
│   │   └── docker-compose.yml   # Servidor de Voz VOIP
│   └── minecraft/
│       └── docker-compose.yml   # Crafty Controller + Playit Agent
│       └── docker/              # Volumes persistentes (Servers, Logs, Backups)
└── scripts/
    ├── healthcheck.sh           # Lógica de auto-recuperação
    └── check.log                # Histórico de integridade e auditoria
```

## Como Executar
1. Clone o repositório: `git clone https://github.com/andradeVh/b612-homelab.git`
1. Acesse a pasta do serviço desejado: `cd services/teamspeak`
1. Inicie o container: `docker-compose up -d`
1. Configure corretamente o script de rotina `healthcheck.sh` e o arquivo `.env`

## Mecanismo de Self-Healing :lizard:

Para evitar downtime, o sistema utiliza um agente de monitorização assíncrono que verifica o estado dos containers a cada 60 minutos.

Como funciona:

1. Health Check: O script valida se o container alvo está no estado running.
1. Log Audit: Cada verificação é registada com um carimbo de data/hora (Timestamp).
1. Auto-Restart: Se uma falha é detectada, o script reinicia o docker compose, garantindo a continuidade do serviço.

Instalação no Cron:

```bash
* * * * /bin/bash /home/seu-usuario/b612-homelab/scripts/healthcheck.sh
```

## Limites de Recursos

Para garantir a estabilidade do servidor Ubuntu e evitar que um serviço consuma todos os recursos do Host, limitamos o uso de recursos:

| Serviço | Limite de CPU | Limite de RAM | Reserva (Garantida) |
| :--- | :--- | :--- | :--- |
| **TeamSpeak** | 0.50 (50%) | 512MB | 128MB |
| **Playit.gg** | 0.20 (20%) | 128MB | - |

Isso garante que, mesmo sob carga pesada ou ataques, o sistema operacional mantenha recursos livres para a gerência via SSH.

## Segurança: Acesso via Chave SSH (Sem Senha) :shipit:

Para aumentar a segurança do servidor, o acesso via senha foi desabilitado, permitindo apenas conexões via par de chaves criptografadas.

### 1. Gerar Par de Chaves (No seu Computador Local)
Abra o terminal na sua máquina pessoal e execute:
```bash
ssh-keygen
```
>Escolha onde salvar a key, por exemplo, /home/user/.ssh/id_pc_pessoal, e depois será necessário uma senha mestre


### 2. Enviar a Chave Pública para o Servidor

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub usuario@ip-do-servidor
```

### 3. Desabilitar Login por Senha no Servidor

```bash
sudo nano /etc/ssh/sshd_config
```
> [!IMPORTANT]
> Altere as seguintes linhas para ficarem assim:

* PasswordAuthentication no
* PermitRootLogin prohibit-password

### 4. Reiniciar o Serviço SSH

```bash
sudo systemctl restart ssh
```

## Conectividade: Por que Playit.gg em vez de WAN Direta?

Diferente de uma configuração convencional de abertura de portas no roteador (**Port Forwarding**), o projeto Asteroid B-612 utiliza o **Playit.gg** como um túnel reverso. Esta abordagem foi escolhida por três motivos fundamentais:

### 1. Superação de CGNAT (Carrier-Grade NAT)
Muitos provedores de internet modernos não atribuem um IP público real ao roteador do usuário (técnica conhecida como CGNAT). Nesses casos, a abertura de portas WAN é tecnicamente impossível. O Playit.gg estabelece uma conexão de saída (**outbound**) que contorna essa restrição, permitindo que o servidor seja acessado externamente sem depender de configurações do ISP.

### 2. Segurança e Ofuscação de IP
Ao utilizar um túnel, o endereço IP real da rede doméstica não é exposto publicamente. O Playit.gg atua como um **Proxy Reverso**, protegendo a infraestrutura contra ataques de varredura de portas (*port scanning*) e mitigando possíveis ataques DDoS diretos à rede local.

### 3. Persistência de Endereço (DNS Estático)
Conexões WAN domésticas costumam ter IPs dinâmicos que mudam frequentemente. O túnel fornece um endereço fixo (ex: `ts-server.playit.gg`), eliminando a necessidade de configurar serviços adicionais de DDNS e garantindo que os usuários sempre consigam se conectar através do mesmo host.