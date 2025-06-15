# Déploiement d'une infrastructure cloud privée avec OpenStack pour héberger un site web dynamique
**Auteurs:** Bacem Hlabba et Amal Ben abedelghaffar GINF-2-2

## Vue d'ensemble
Ce projet met en place une infrastructure cloud privée à l'aide d'OpenStack pour déployer une application web (WordPress). L'infrastructure comprend une machine virtuelle, une configuration réseau, du stockage persistant et l'automatisation du déploiement.

## Architecture

L'architecture du projet comprend les composants OpenStack suivants:
- **Nova**: Gestion des machines virtuelles
- **Neutron**: Gestion du réseau
- **Glance**: Gestion des images
- **Keystone**: Service d'identité
- **Cinder**: Gestion du stockage bloc
- **Horizon**: Interface web d'administration
- **Heat**: Orchestration et automatisation

## Instructions d'installation

### 1. Installation d'OpenStack

Pour installer OpenStack sur votre serveur:
```bash
./setup_devstack.sh
```
Ce script va:
- Créer un utilisateur "stack" avec les permissions nécessaires
- Copier les fichiers de configuration DevStack
- Lancer l'installation de DevStack

> **Remarque**: L'installation peut prendre 30-45 minutes selon votre connexion Internet et les ressources du serveur.

### 2. Création du projet et des utilisateurs

Après l'installation d'OpenStack:
```bash
./create_project.sh
```
Ce script va:
- Créer un projet "webapp-project"
- Créer un utilisateur "webapp-user"
- Configurer un groupe de sécurité pour le trafic web

### 3. Déploiement d'une machine virtuelle

Pour créer et configurer une VM:
```bash
./deploy_vm.sh
```
Ce script va:
- Créer un réseau privé
- Configurer un routeur
- Déployer une VM Ubuntu
- Assigner une IP flottante pour l'accès externe

### 4. Installation de WordPress

Connectez-vous à la VM créée:
```bash
ssh -i ~/webapp-key.pem ubuntu@<FLOATING_IP>
```

Puis exécutez le script d'installation WordPress:
```bash
# Copiez d'abord le script sur la VM
scp -i ~/webapp-key.pem /home/bacemhlabba/Downloads/openstack/install_wordpress.sh ubuntu@<FLOATING_IP>:~/
# Puis exécutez-le sur la VM
ssh -i ~/webapp-key.pem ubuntu@<FLOATING_IP> "chmod +x ~/install_wordpress.sh && ~/install_wordpress.sh"
```

### 5. Ajout d'un volume de stockage

Pour créer et attacher un volume de stockage:
```bash
./create_volume.sh
```
Ce script va:
- Créer un volume de 10GB
- Attacher le volume à la VM WordPress
- Fournir les instructions pour formater et monter le volume

### 6. Déploiement automatisé (Heat)

Pour un déploiement automatisé de toute l'infrastructure:
```bash
./deploy_heat_stack.sh
```

Ce script utilise Heat pour orchestrer la création de tous les composants nécessaires en une seule opération.

## Accès au dashboard OpenStack (Horizon)

Une fois l'installation terminée, vous pouvez accéder à l'interface Horizon:
- URL: http://server_ip/dashboard
- Utilisateur: admin
- Mot de passe: admin123

## Dépannage

Si vous rencontrez des problèmes:
1. Consultez les logs dans `/opt/stack/logs/`
2. Vérifiez que tous les services OpenStack fonctionnent correctement avec: `sudo systemctl list-units | grep devstack`
3. Si nécessaire, redémarrez DevStack: `cd /opt/stack/devstack && ./unstack.sh && ./stack.sh`

