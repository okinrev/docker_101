# Applications Flask Dockerisées avec Nginx en Reverse Proxy

Ce projet vise à démontrer la configuration d'applications Flask (`webapp` et `workerapp`) dans des conteneurs Docker avec un reverse proxy Nginx pour router les requêtes entrantes.

## Explications des Dockerfiles

### Application Web (webapp)

Le Dockerfile pour `webapp` :

- Utilise une image Python 3.9 slim.
- Installe les dépendances requises spécifiées dans `requirements.txt`.
- Configure les variables d'environnement.
- Lance l'application Flask en utilisant un utilisateur non privilégié (`webuser`).

### Application Worker (workerapp)

Le Dockerfile pour `workerapp` :

- Similaire à la structure du Dockerfile de `webapp`.
- Définit les variables d'environnement et lance l'application Flask en tant qu'utilisateur non privilégié (`workeruser`).

## Configuration Nginx (nginx/nginx.conf)

La configuration Nginx :

- Écoute sur les ports 80 (HTTP) et 443 (HTTPS).
- Implémente les certificats SSL (`adlin.tiger.org.crt` et `adlin.tiger.org.key`) pour le HTTPS.
- Route les requêtes entrantes vers `webapp` et `workerapp` en fonction du chemin d'URL.
- Applique des mesures de sécurité telles que l'application de TLS 1.3 et l'activation de HSTS.

## Configuration Docker Compose (docker-compose.yml)

La configuration Docker Compose :

- Gère les conteneurs pour `webapp`, `workerapp`, `nginx` et `redis`.
- Définit des réseaux (`web_network` et `redis_network`) pour isoler les communications.
- Définit des limites de ressources pour l'utilisation du CPU et de la mémoire.
- Spécifie des volumes pour les données persistantes (`redis_data`).
- Mappe les ports 80 et 443 pour Nginx.

## À propos de `crt.sh`

Le script `crt.sh` est conçu pour automatiser la création de certificats SSL/TLS à l'aide d'OpenSSL afin de sécuriser l'applications web avec HTTPS.

### Étapes couvertes par `crt.sh` :

1. **Génération de la clé Root CA :** Génère une clé RSA 4096 pour le Root CA.
2. **Création du certificat Root :** Crée le certificat root en utilisant la clé Root CA.
3. **Génération de la clé du serveur web :** Génère une clé RSA 2048 pour le serveur web.
4. **Création de la CSR (Certificate Signing Request) :** Génère une CSR pour le serveur web.
5. **Signature de la CSR avec Root CA :** Signe la CSR en utilisant le certificat Root CA pour produire le certificat SSL/TLS final pour le serveur web.

## Exécution des Applications

1. Cloner ce dépôt.
2. Accéder au répertoire `given_files`. Puis `nginx`.
3. Exécuter `./crt.sh` pour créer un root CA et signer un certificat dans le but de securiser l'application avec https.
4. Remonter dans le répertoire racine `given_files`.
5. Exécuter `docker-compose up --build` pour construire et démarrer les conteneurs.
6. Accéder à l'application web via `http://localhost:8000`.
7. Accéder à l'application worker via `http://localhost:9000/worker`.
8. Accéder à la version HTTPS via `https://localhost`.

## Arrêt des Applications

1. Exécuter `docker-compose down` pour détruire et arrêter les conteneurs.

## Dépannage

- En cas de problèmes avec les certificats SSL ou les chemins, vérifier que les certificats sont générés correctement et montés dans le conteneur Nginx comme spécifié dans le `docker-compose.yml`.
