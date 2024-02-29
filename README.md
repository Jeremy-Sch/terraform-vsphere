# Terraform VMware vSphere Deployment

Ce projet Terraform permet de déployer des machines virtuelles sur VMware vSphere avec une configuration flexible.

## Configuration

Le fichier `main.tf` contient la configuration principale. 
Le fichier `variables.tf` est utilisé pour déclarer les variables utilisées.
Le fichier `output.tf` est utilisé pour définir les sorties (outputs) que vous souhaitez récupérer après le déploiement de l'infrastructure.
Le fichier `vsphere.tfvars` est utilisé pour spécifier les informations de connexion à vSphere.
Le fichier `terraform.tfvars` est utilisé pour spécifier des valeurs par défaut aux variables définies dans le fichier `variables.tf`.

### Variables

### Identifiants et Connexion

- `vsphere_user`: Nom d'utilisateur VMware vSphere 
- `vsphere_password`: Mot de passe VMware vSphere 
- `vsphere_vcenter`: FQDN / IP du serveur VMWare vCenter 
- `vsphere_unverified_ssl`: Vérifie si le certificat SSL de l'interface utilisateur du serveur VMware vCenter est fourni par une autorité de certification de confiance 

### Détails de l'Infrastructure

- `vsphere_datacenter`: Datacenter VMware vSphere
- `vsphere_cluster`: Cluster VMware vSphere
- `vsphere_template_folder`: Dossier du modèle VMware vSphere

## Configuration de la Machine Virtuelle

### Paramètres Généraux

- `vm_name`: Nom des machines virtuelles vSphere et nom d'hôte de la machine
- `vm_datastore`: Datastore à utiliser pour la VM
- `vm_network`: Réseau à utiliser pour la VM
- `vm_linked_clone`: Utiliser le clonage lié pour créer la machine virtuelle vSphere à partir du modèle (par défaut : false, bool)

### Allocation des Ressources

- `cpu`: Nombre de vCPU allouées à la VM (par défaut : 2)
- `cores_per_socket`: Nombre de cœurs par CPU alloués à la VM (par défaut : 1)
- `ram`: Quantité de RAM allouée à la VM (par défaut : 2048 Mo)
- `disksize`: Taille du disque alloué à la VM (en Go, par défaut : 30 Go)

### Système d'Exploitation et Configuration

- `vm_guest_id`: L'ID de l'invité vCenter, qui détermine le type de système d'exploitation
- `vm_template_name`: Le modèle utilisé pour créer la VM
- `vm_domain`: Le nom de domaine pour l'hôte. Cela, ainsi que host_name, constituent le FQDN de la VM (nullable)
- `dns_server_list`: Liste des serveurs DNS (par défaut : ["8.8.8.8", "8.8.4.4"])
- `dns_search_domain`: Définir le domaine de recherche DNS pour la VM (nullable)
- `ipv4_address`: Définir l'adresse IPv4 pour la VM
- `ipv4_gateway`: Définir la passerelle IPv4 pour la VM
- `ipv4_netmask`: Définir le masque de sous-réseau IPv4 pour la VM. Utilisez la notation CIDR (par défaut : 24)

### Configuration SSH

- `ssh_username`: Nom d'utilisateur SSH pour accéder à la VM 
- `public_key`: Spécifiez le chemin vers le fichier de clé publique. Le contenu sera ajouté au fichier authorized_keys de l'utilisateur SSH dans la VM

### Configuration du Fuseau Horaire

- `vm_tz`: Définit le fuseau horaire (par défaut : "Europe/Paris")

N'hésitez pas à personnaliser ces variables en fonction de vos besoins spécifiques. Consultez les variables correspondantes dans le fichier `variables.tf` pour plus de détails.

## Utilisation

1. Clonez ce dépôt Git localement :
```bash
git clone https://github.com/Jeremy-Sch/terraform-vsphere.git
```
```bash
cd terraform-vsphere
```
2. Initialisez Terraform :
```bash
terraform init
```
3. Exécutez Terraform pour créer les ressources :
```bash
terraform apply -var-file="vsphere.tfvars"
```
