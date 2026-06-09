# 🐢 Sea Turtle Grants Management

Application Flutter pour gérer et simuler des budgets de subventions pour la conservation des tortues marines.

## 🎯 Fonctionnalités

- **Dashboard** : Vue d'ensemble des budgets et taux d'exécution
- **Liste des Subventions** : Détail de chaque catégorie de coûts
- **Simulation Budgétaire** : Modéliser différents scénarios
- **Interface Glassmorphism** : Design moderne avec thème Ocean Deep
- **Système de Verrouillage** : PIN 6 chiffres (`270697`)

## 📱 Générer l'APK via GitHub

### Étape 1️⃣ : Créer un dépôt GitHub

1. Allez sur [github.com](https://github.com)
2. Cliquez sur **"New repository"**
3. Nommez-le `seaturtleapp`
4. Choisissez **Private** ou **Public**
5. Cliquez **"Create repository"**

### Étape 2️⃣ : Pousser le code

```bash
cd c:\Users\DanielRakotoarisoa\Desktop\PROJECT-1

# Initialiser git
git init
git add .
git commit -m "Initial commit: Sea Turtle Grants App"

# Ajouter le remote et pousser
git remote add origin https://github.com/YOUR_USERNAME/seaturtleapp.git
git branch -M main
git push -u origin main
```

### Étape 3️⃣ : Attendre la construction automatique

1. Allez dans votre repo GitHub
2. Cliquez sur l'onglet **"Actions"**
3. Vous verrez un workflow "Build APK" en cours d'exécution
4. Attendez ~5-10 minutes que la build se termine

### Étape 4️⃣ : Télécharger l'APK

1. Cliquez sur la run terminée "Build APK"
2. Scrollez jusqu'à **Artifacts** en bas
3. Cliquez sur **"release-apk"** pour télécharger le ZIP
4. Extrayez le ZIP et choisissez :
   - **`app-arm64-v8a-release.apk`** (recommandé pour la plupart des appareils)
   - **`app-armeabi-v7a-release.apk`** (appareils plus anciens)

## 📥 Installer sur votre téléphone

### Option A : Via l'explorateur Windows
1. Téléchargez l'APK sur Windows
2. Mettez l'APK sur Google Drive / OneDrive
3. Téléchargez l'APK sur votre téléphone
4. Ouvrez avec votre gestionnaire de fichiers
5. Touchez pour installer

### Option B : Via USB (Advanced)
```bash
# Avec ADB installé
adb install app-arm64-v8a-release.apk
```

### Option C : QR Code
Générez un QR code pointant vers votre lien de téléchargement (ex: via bit.ly)

## 🔐 Accéder à l'application

**Code PIN** : `270697`

## 📁 Structure du projet

```
PROJECT-1/
├── .github/workflows/build.yml    ← Configuration automatique build
├── lib/
│   ├── main.dart                  ← Point d'entrée
│   ├── screens/                   ← Écrans de l'app
│   ├── providers/                 ← Gestion d'état (Provider)
│   ├── widgets/                   ← Composants réutilisables
│   ├── models/                    ← Modèles de données
│   └── utils/                     ← Thème et utilitaires
├── assets/data/grants.json        ← Données budgétaires
├── pubspec.yaml                   ← Dépendances Flutter
└── BUILD_AND_DEPLOY.md            ← Guide détaillé

```

## 🔄 Redéployer après modifications

```bash
# Faire des changements
# Puis:

git add .
git commit -m "Ma nouvelle modification"
git push
```

✅ Une nouvelle APK sera générée automatiquement dans l'onglet Actions

## 🎨 Personnaliser l'app

### Changer le nom de l'app
- Modifiez `name: seaturtleapp` dans `pubspec.yaml`

### Changer l'organisation
- Modifiez `com.seaturtlegrants` dans `.github/workflows/build.yml`

### Changer les couleurs
- Modifiez `AppColors` dans `lib/utils/app_theme.dart`

### Mettre à jour les données budgétaires
- Modifiez `assets/data/grants.json`

## ⚙️ Dépendances installées

```yaml
flutter:
  sdk: flutter
provider: ^6.1.1              # State management
fl_chart: ^0.66.2             # Graphiques
google_fonts: ^6.1.0          # Polices personnalisées
animate_do: ^3.3.1            # Animations
shared_preferences: ^2.2.2    # Stockage local
intl: ^0.19.0                 # Internationalisation
```

## 🚀 Actions GitHub disponibles

- **Build APK** : Construit automatiquement chaque push
- Artefacts retenus pendant 30 jours
- Logs complets pour le dépannage

## ❓ FAQ

### Q: Combien de temps prend le build?
**A:** 5-10 minutes généralement

### Q: L'APK est conservée où?
**A:** Dans les Artifacts GitHub pendant 30 jours

### Q: Je peux pousser sans GitHub?
**A:** Oui, installez Flutter localement. Voir `BUILD_AND_DEPLOY.md`

### Q: Comment signer l'APK pour Google Play?
**A:** Voir [Google Play Publishing Guide](https://developer.android.com/studio/publish)

## 📞 Support

Pour les erreurs de build, vérifiez:
1. Les logs dans Actions → Build APK
2. Que `pubspec.yaml` est valide
3. Que les fichiers Dart compilent sans erreurs

## 📄 Licence

Projet privé - Tous droits réservés

---

**Créé pour la gestion des subventions de conservation des tortues marines 🐢💚**

Dernière mise à jour: Juin 2026

