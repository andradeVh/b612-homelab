# 🪐 Asteroid B-612 | Home Server Infrastructure

Repositório dedicado à documentação e automação do meu ambiente de servidor local (**Homelab**), utilizando Ubuntu Server e Docker para orquestração de serviços.

## Especificações Técnicas
* **Host OS:** Ubuntu Server 22.04 LTS
* **Virtualização/Containers:** Docker & Docker Compose
* **Protocolos de Acesso:** SSH

## Serviços Implementados
Atualmente, o "Asteroide" sustenta os seguintes módulos:
* **Crafty Controller:** Painel de gerenciamento para instâncias de jogos.
* **TeamSpeak 3 Server:** Infraestrutura de comunicação VoIP.

## Segurança e Redes
* Acesso remoto seguro via SSH com desativação de login por senha.

## Como replicar
1. Clone o repositório.
2. Navegue até a pasta do serviço: `cd services/teamspeak`.
3. Suba o container: `docker-compose up -d`.
