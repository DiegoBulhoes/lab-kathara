# lab-kathara

Para instanciar o laboratório será necessario instalar o [Terraform](https://terraform.io/) e o [Ansible](https://www.ansible.com/), após configuração das duas ferramentas será necessário instalar duas bibliotecas do Python **request** e **google-auth** para utilizar o [GCE **dynamic inventory**](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html)

## Inicializar o laboratório

Clonar o projeto

```shell
git clone --recurse-submodules https://github.com/DiegoBulhoes/lab-kathara
```

Exportar as variáveis de ambiente

```shell
export GCP_SERVICE_ACCOUNT_FILE=/path/keyfile.json  && \
export GOOGLE_APPLICATION_CREDENTIALS=/path/keyfile.json
```

## Terraform

Um dos passos necessários para utilizar esse _setup_ é possuir uma par de _keys_ SSH, podendo ser gerado através do seguinte comando, para mais detalhes consulte a documentação atrves desse [link](https://wiki.debian.org/SSH)

```shell
ssh-keygen -q -t rsa -f id_rsa_kathara -C kathara
```

Após a geração da chave renomeie o arquivo [terraform/terraform.tfvars.sample](terraform/terraform.tfvars.sample) para terraform.tfvars (nesse arquivo irá conter todas as variáveis para criar as instâncias no GCP). Crie um [**service-accounts**](https://cloud.google.com/compute/docs/access/service-accounts) com uma chave do tipo **JSON** e exponha no ambiente através do variável _GCP_SERVICE_ACCOUNT_FILE_

```shell
export GCP_SERVICE_ACCOUNT_FILE=/path/keyfile.json
```

Para verificar se os arquivos possui algum erro de sintaxe ou de configuração das instâncias execute o seguinte comando:

```shell
terraform plan
```

Após a verificação do _plan_ execulte o seuinte comando para realizar o processo de instanciação

```shell
terraform aplly
```

Se tudo estiver ok a saída será similar a esta:

```text
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

kathara_public = [
"<<ip_public>>",
]
```

## Ansible

Para Configurar o [Kathrá](https://github.com/KatharaFramework/Kathara/) será utilizado o Ansible, exponha a path da chave:

```shell
export GOOGLE_APPLICATION_CREDENTIALS=/home/$USER/gcp-projects/kathara.json
```

Altere o valor da lista _projects_ com o respectivo nome do projeto do GCP no [inventory.gcp.yml](https://github.com/DiegoBulhoes/lab-kathara/blob/master/ansible/inventory.gcp.yml.example).

```text
projects:
  - "nome_do_projeto"
```

Entre o diretório ansible e executar o seguinte comando.

```shell
ansible-playbook playbook.yml
```

## Exemplo - [_BGP, OSPF and RIP interplay_](https://github.com/KatharaFramework/Kathara/#example)

- Para executar o exemplo, acesse a instância usando o SSH.

```shell
ssh -X kathara@ip_public
```

- Faça o download do exemplo **BGP, OSPF and RIP interplay**

```shell
wget https://github.com/KatharaFramework/Kathara-Labs/raw/master/Labs%20Integrating%20Several%20Technologies/BGP%2C%20OSPF%20and%20RIP%20interplay/kathara-lab_bgp-ospf-rip.zip
```

- Descompacte o _zip_:

```
unzip kathara-lab_bgp-ospf-rip.zip
```

- a estrutura dos diretórios deverá ser similar a essa:

```text
├── kathara-bgp-ospf-rip
│   ├── lab.conf
│   ├── ra1b1
│   ├── ra1b1.startup
│   ├── ra2b2
│   ├── ra2b2.startup
│   ├── ra3b3
│   ├── ra3b3.startup
│   ├── rb1c1
│   ├── rb1c1.startup
│   ├── rb2c2
│   ├── rb2c2.startup
│   ├── rb3c3
│   ├── rb3c3.startup
│   ├── rc1d1
│   ├── rc1d1.startup
│   ├── rc2d2
│   ├── rc2d2.startup
│   ├── rc3d3
│   └── rc3d3.startup
└── kathara-lab_bgp-ospf-rip.zip

```

- No contexto do diretório kathara-lab bgp-ospf-rip execute o seguinte comando

```shell
sudo kathara lstart
```

- Para listar os containers que o Kathara está administrando execute

```shell
sudo kathara list
```

Saída será:

```text
╔════════════════════════╦═════════╦══════════════╦═════════╦═══════╦═══════════════════╦═══════╦═══════════════════╗
║ LAB HASH               ║ USER    ║ MACHINE NAME ║ STATUS  ║ CPU % ║ MEM USAGE / LIMIT ║ MEM % ║ NET I/O           ║
╠════════════════════════╬═════════╬══════════════╬═════════╬═══════╬═══════════════════╬═══════╬═══════════════════╣
║ Bko4YLmYg84dLydrpVXRXQ ║ kathara ║ ra1b1        ║ running ║ 0.00% ║ 6.39 MB / 3.6 GB  ║ 0.17% ║ 5.16 KB / 3.14 KB ║
╠════════════════════════╬═════════╬══════════════╬═════════╬═══════╬═══════════════════╬═══════╬═══════════════════╣
║ Bko4YLmYg84dLydrpVXRXQ ║ kathara ║ ra2b2        ║ running ║ 0.00% ║ 6.48 MB / 3.6 GB  ║ 0.18% ║ 8.76 KB / 5.8 KB  ║
╠════════════════════════╬═════════╬══════════════╬═════════╬═══════╬═══════════════════╬═══════╬═══════════════════╣
║ Bko4YLmYg84dLydrpVXRXQ ║ kathara ║ ra3b3        ║ running ║ 0.00% ║ 6.19 MB / 3.6 GB  ║ 0.17% ║ 4.9 KB / 2.81 KB  ║
╠════════════════════════╬═════════╬══════════════╬═════════╬═══════╬═══════════════════╬═══════╬═══════════════════╣
║ Bko4YLmYg84dLydrpVXRXQ ║ kathara ║ rb1c1        ║ running ║ 0.00% ║ 4.02 MB / 3.6 GB  ║ 0.11% ║ 3.61 KB / 1.49 KB ║
╠════════════════════════╬═════════╬══════════════╬═════════╬═══════╬═══════════════════╬═══════╬═══════════════════╣
║ Bko4YLmYg84dLydrpVXRXQ ║ kathara ║ rb2c2        ║ running ║ 0.00% ║ 4.2 MB / 3.6 GB   ║ 0.11% ║ 6.45 KB / 4.69 KB ║
╠════════════════════════╬═════════╬══════════════╬═════════╬═══════╬═══════════════════╬═══════╬═══════════════════╣
║ Bko4YLmYg84dLydrpVXRXQ ║ kathara ║ rb3c3        ║ running ║ 0.00% ║ 4.01 MB / 3.6 GB  ║ 0.11% ║ 3.3 KB / 1.46 KB  ║
╠════════════════════════╬═════════╬══════════════╬═════════╬═══════╬═══════════════════╬═══════╬═══════════════════╣
║ Bko4YLmYg84dLydrpVXRXQ ║ kathara ║ rc1d1        ║ running ║ 0.00% ║ 4.02 MB / 3.6 GB  ║ 0.11% ║ 3.07 KB / 1.48 KB ║
╠════════════════════════╬═════════╬══════════════╬═════════╬═══════╬═══════════════════╬═══════╬═══════════════════╣
║ Bko4YLmYg84dLydrpVXRXQ ║ kathara ║ rc2d2        ║ running ║ 0.00% ║ 4.19 MB / 3.6 GB  ║ 0.11% ║ 4.43 KB / 3.01 KB ║
╠════════════════════════╬═════════╬══════════════╬═════════╬═══════╬═══════════════════╬═══════╬═══════════════════╣
║ Bko4YLmYg84dLydrpVXRXQ ║ kathara ║ rc3d3        ║ running ║ 0.00% ║ 4.02 MB / 3.6 GB  ║ 0.11% ║ 2.95 KB / 1.27 KB ║
╚════════════════════════╩═════════╩══════════════╩═════════╩═══════╩═══════════════════╩═══════╩═══════════════════╝
```
