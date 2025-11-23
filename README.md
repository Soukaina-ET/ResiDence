# 🏢 ResiDence

> Application web moderne de gestion de résidences étudiantes

Une solution complète pour centraliser la gestion des chambres, résidents, paiements et maintenance dans les résidences universitaires.

---

## 👩‍💻 Auteur

**ETTAOUSSI SOUKAINA**

---

## 📋 Table des matières

- [À propos](#-à-propos)
- [Fonctionnalités](#-fonctionnalités)
- [Technologies](#-technologies)
- [Installation](#-installation)
- [Galerie](#-galerie)
- [Structure](#-structure)
- [Licence](#-licence)

---

## 🎯 À propos

ResiDence est une application web Java EE conçue pour moderniser la gestion administrative des résidences étudiantes. Elle offre une interface intuitive pour l'administration et les résidents, permettant de gérer efficacement tous les aspects de la vie en résidence.

### ✨ Points forts

- 🎨 Interface utilisateur moderne et responsive
- 🔒 Système d'authentification sécurisé
- 📊 Tableaux de bord interactifs avec statistiques en temps réel
- 📧 Notifications automatiques par email
- 📱 Accessible depuis n'importe quel appareil

---

## 🚀 Fonctionnalités

### 🏠 Gestion des Chambres

- CRUD complet avec validation des données
- Suivi en temps réel : disponibles, occupées, en maintenance
- Gestion des équipements et caractéristiques
- Vue d'ensemble du taux d'occupation

### 👥 Gestion des Résidents

- Inscription en ligne avec validation email
- Attribution intelligente des chambres (automatique/manuelle)
- Profils détaillés : informations personnelles, historique
- Mise à jour des coordonnées

### 💰 Suivi des Paiements

- Tableau de bord des loyers : dus, payés, retards
- Génération automatique de reçus PDF
- Historique complet des transactions
- Rappels automatiques par email

### 🔧 Maintenance & Incidents

- Déclaration simplifiée d'incidents par les résidents
- Workflow de traitement : validation → assignation → résolution
- Suivi en temps réel de l'avancement
- Historique complet par chambre

### 📊 Analytics & Reporting

- Dashboard administrateur avec métriques clés
- Taux d'occupation en temps réel
- Alertes sur les paiements en retard
- Suivi des incidents en cours
- Graphiques et visualisations

### 🔍 Recherche Avancée

- Recherche multi-critères (chambres, résidents, incidents)
- Filtres intelligents par statut, disponibilité, priorité
- Résultats instantanés

---

## 🛠️ Technologies

### Backend
- ![Java](https://img.shields.io/badge/Java-ED8B00?style=flat&logo=openjdk&logoColor=white) **Java EE** - Architecture Servlet/JSP
- ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white) **MySQL** - Base de données
- ![JDBC](https://img.shields.io/badge/JDBC-007396?style=flat&logo=java&logoColor=white) **JDBC** - Connectivité base de données

### Frontend
- ![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white) **HTML5**
- ![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white) **CSS3**
- ![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black) **JavaScript**

### Outils & Serveur
- ![Tomcat](https://img.shields.io/badge/Tomcat-F8DC75?style=flat&logo=apache-tomcat&logoColor=black) **Apache Tomcat**
- ![Maven](https://img.shields.io/badge/Maven-C71A36?style=flat&logo=apache-maven&logoColor=white) **Maven** - Gestion de projet

---

## 📦 Installation

### Prérequis

- JDK 8 ou supérieur
- Apache Tomcat 9+
- MySQL 5.7+
- Maven 3.6+

### Étapes

1. **Cloner le repository**
   ```bash
   git clone https://github.com/votre-username/ResiDence.git
   cd ResiDence
   ```

2. **Configurer la base de données**
   ```bash
   mysql -u root -p < database/schema.sql
   ```

3. **Compiler le projet**
   ```bash
   mvn clean install
   ```

4. **Déployer sur Tomcat**
   - Copier le fichier `target/ResiDence.war` dans le dossier `webapps/` de Tomcat
   - Démarrer Tomcat

5. **Accéder à l'application**
   ```
   http://localhost:8080/ResiDence
   ```

---

## 🖼️ Galerie

<details>
<summary>👁️ Voir les captures d'écran</summary>

### Interface Publique
| Accueil | Connexion | Inscription |
|---------|-----------|-------------|
| ![Accueil](src/main/resources/screenshots/Acceuil.png) | ![Connexion](src/main/resources/screenshots/Connexion.png) | ![Inscription](src/main/resources/screenshots/inscription.png) |

### Dashboards
| Admin | Résident |
|-------|----------|
| ![Dashboard Admin](src/main/resources/screenshots/Dashboard.png) | ![Dashboard Résident](src/main/resources/screenshots/DashR.png) |

### Gestion
| Chambres | Admins | Résidents |
|----------|--------|-----------|
| ![Chambre](src/main/resources/screenshots/Chambre.png) | ![Admins](src/main/resources/screenshots/Admins.png) | ![Ajout](src/main/resources/screenshots/AjoutResident.png) |

### Fonctionnalités
| Maintenance | Paiements | Profil |
|-------------|-----------|--------|
| ![Maintenance](src/main/resources/screenshots/Maintenance.png) | ![Paiement](src/main/resources/screenshots/Paiement.png) | ![Profil](src/main/resources/screenshots/ProfilResident.png) |

</details>

---

## 📁 Structure

```
ResiDence/
├── 📂 src/
│   └── 📂 main/
│       ├── 📂 java/
│       │   ├── 📦 admin/           # Modules administrateur
│       │   │   ├── admins/         # Gestion des admins
│       │   │   ├── chambres/       # Gestion des chambres
│       │   │   ├── residents/      # Gestion des résidents
│       │   │   ├── paiement/       # Gestion des paiements
│       │   │   ├── maintenance/    # Gestion de la maintenance
│       │   │   ├── statistiques/   # Analytics
│       │   │   └── notification/   # Système de notifications
│       │   │
│       │   └── 📦 resident/        # Modules résident
│       │       ├── dashboard/      # Tableau de bord
│       │       ├── profil/         # Gestion du profil
│       │       ├── paiement/       # Consultation paiements
│       │       └── maintenance/    # Déclaration incidents
│       │
│       ├── 📂 resources/
│       │   ├── images/             # Ressources statiques
│       │   └── screenshots/        # Captures d'écran
│       │
│       └── 📂 webapp/
│           ├── 🎨 residentJsp/    # Vues résident
│           ├── 🎨 AdminsJsp/      # Vues admin
│           ├── 📂 images/         # Assets frontend
│           └── 📂 WEB-INF/        # Configuration
│
└── 📄 pom.xml                      # Configuration Maven
```

---

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/amelioration`)
3. Commit vos changements (`git commit -m 'Ajout nouvelle fonctionnalité'`)
4. Push (`git push origin feature/amelioration`)
5. Ouvrir une Pull Request

---

## 📝 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

---

## 📧 Contact

**ETTAOUSSI SOUKAINA**

Pour toute question ou suggestion, n'hésitez pas à ouvrir une issue sur GitHub.

---

<div align="center">

**⭐ Si ce projet vous plaît, n'oubliez pas de lui donner une étoile !**

Made with ❤️ by ETTAOUSSI SOUKAINA

</div>

---


