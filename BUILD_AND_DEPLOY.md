# Sea Turtle Grants Management - APK Build Guide

## 📱 Build APK avec GitHub Actions

Ce projet est configuré pour générer automatiquement une APK via GitHub Actions sans avoir besoin d'installer Flutter localement.

## 🚀 Étapes pour générer l'APK

### 1. Créer un dépôt GitHub
```bash
# Initialisez le repo git
git init
git add .
git commit -m "Initial commit"
```

### 2. Créer un dépôt sur GitHub
- Allez sur [github.com/new](https://github.com/new)
- Créez un nouveau repo (ex: `seaturtleapp`)
- Suivez les instructions pour pousser votre code local

### 3. Pousser le code
```bash
git remote add origin https://github.com/VOTRE_USERNAME/seaturtleapp.git
git branch -M main
git push -u origin main
```

### 4. GitHub Actions construit automatiquement
- Allez dans l'onglet **Actions** de votre repo
- Vous verrez le workflow "Build APK" en cours d'exécution
- Une fois terminé, cliquez sur la run pour voir les détails

## 📥 Télécharger l'APK

1. Dans la page de la run GitHub Actions
2. Scrollez vers le bas jusqu'à **Artifacts**
3. Cliquez sur `release-apk` pour télécharger
4. Vous obtiendrez un ZIP avec les fichiers APK :
   - `app-armeabi-v7a-release.apk` (pour la plupart des appareils)
   - `app-arm64-v8a-release.apk` (pour appareils 64-bit)
   - `app-x86_64-release.apk` (optionnel)

## 📲 Installer l'APK sur votre téléphone

### Option 1: Par USB (Connexion directe)
```bash
adb install app-arm64-v8a-release.apk
```

### Option 2: Transférer le fichier
1. Mettez l'APK sur Google Drive / OneDrive
2. Téléchargez-le sur votre téléphone
3. Ouvrez le fichier avec votre gestionnaire de fichiers
4. Touchez pour installer

### Option 3: QR Code
Créez un QR code pointant vers votre lien de téléchargement et scannez-le avec votre téléphone

## 🔐 Code PIN pour accéder à l'app
```
270697
```

## ⚙️ Structure des fichiers

```
PROJECT-1/
├── lib/
│   ├── main.dart                 # Point d'entrée
│   ├── providers/
│   │   └── budget_provider.dart  # State management
│   ├── screens/
│   │   ├── lock_screen.dart     # Écran de verrouillage
│   │   ├── dashboard_screen.dart # Tableau de bord
│   │   ├── grants_list_screen.dart # Liste des subventions
│   │   └── simulation_screen.dart  # Simulation budgétaire
│   ├── widgets/
│   │   ├── glass_card.dart      # Composant carte en verre
│   │   └── sea_turtle_logo.dart # Logo tortue marine
│   ├── models/
│   │   └── grant_model.dart     # Modèle de données
│   └── utils/
│       └── app_theme.dart       # Thème et couleurs
├── assets/
│   └── data/
│       └── grants.json          # Données budgétaires
├── pubspec.yaml                 # Dépendances Flutter
└── .github/
    └── workflows/
        └── build.yml            # Configuration GitHub Actions
```

## 🔄 Redéployer automatiquement

Chaque fois que vous poussez du code sur `main` ou `master`, l'APK est automatiquement construite:
```bash
git add .
git commit -m "Update app"
git push
```

## ❓ Dépannage

### L'APK est trop grande?
- C'est normal pour une première build (~50-100 MB)
- Les builds suivantes seront plus petites grâce au caching

### La build échoue?
- Vérifiez les logs dans l'onglet **Actions**
- Assurez-vous que tous les fichiers Dart sont valides
- Vérifiez que `pubspec.yaml` est correct

### L'app ne démarre pas?
- Vérifiez le code PIN: `270697`
- Vérifiez qu'Android 5.0+ est installé
- Lisez les logs avec: `adb logcat`

## 📚 Documentation supplémentaire

- [Flutter Docs](https://flutter.dev/docs)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Android APK signing](https://developer.android.com/studio/publish/app-signing)

## 🎨 Personnalisations possibles

- **Nom de l'app**: Modifiez `name` dans `pubspec.yaml`
- **Organisation**: Changez `com.seaturtlegrants` dans `build.yml`
- **Couleurs**: Modifiez `AppColors` dans `lib/utils/app_theme.dart`
- **Données**: Mettez à jour `assets/data/grants.json`

---

**Bonne chance avec votre application Sea Turtle Grants! 🐢** 

