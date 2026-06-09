# 🐢 Sea Turtle Grants — Guide de Déploiement Complet

## Structure du Projet

```
seaturtleapp/
├── pubspec.yaml                    # Dépendances Flutter
├── assets/
│   └── data/
│       └── grants.json            # Données des subventions
└── lib/
    ├── main.dart                   # Point d'entrée
    ├── models/
    │   └── grant_model.dart        # Modèles de données (Clean Architecture)
    ├── providers/
    │   └── budget_provider.dart    # Logique métier + état (Provider)
    ├── screens/
    │   ├── lock_screen.dart        # Écran de verrouillage PIN (270697)
    │   ├── dashboard_screen.dart   # Dashboard principal
    │   ├── grants_list_screen.dart # Liste des subventions
    │   └── simulation_screen.dart  # Module de simulation budgétaire
    ├── widgets/
    │   ├── sea_turtle_logo.dart    # Logo tortue marine (CustomPainter)
    │   └── glass_card.dart         # Carte glassmorphism réutilisable
    └── utils/
        └── app_theme.dart          # Thème, couleurs, typographie
```

---

## ⚙️ Installation & Setup

### Prérequis
- Flutter SDK ≥ 3.10.0 installé : https://docs.flutter.dev/get-started/install
- Android Studio (avec SDK Android API 21+) ou VS Code
- Java JDK 11+

### 1. Créer le projet Flutter
```bash
flutter create seaturtleapp --org com.seaturtlegrants
cd seaturtleapp
```

### 2. Remplacer les fichiers
Copier tous les fichiers fournis dans le projet Flutter créé :
- `lib/` → remplace le dossier `lib/`
- `pubspec.yaml` → remplace le fichier existant
- `assets/` → ajouter à la racine du projet

### 3. Installer les dépendances
```bash
flutter pub get
```

### 4. Vérifier la configuration
```bash
flutter doctor
flutter analyze
```

---

## 📱 Lancer l'application

### Émulateur / Appareil connecté
```bash
# Lister les appareils disponibles
flutter devices

# Lancer en mode debug
flutter run

# Lancer sur un appareil spécifique
flutter run -d <device_id>
```

### Mode Release (test performances)
```bash
flutter run --release
```

---

## 🔨 Compiler l'APK

### APK Debug (développement)
```bash
flutter build apk --debug
# → build/app/outputs/flutter-apk/app-debug.apk
```

### APK Release (déploiement)
```bash
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

### APK Split (plus léger, par architecture)
```bash
flutter build apk --split-per-abi --release
# Génère 3 APK optimisés :
# → app-armeabi-v7a-release.apk  (~15 MB)
# → app-arm64-v8a-release.apk    (~16 MB)  ← Recommandé pour Android modernes
# → app-x86_64-release.apk       (~16 MB)
```

### App Bundle (Google Play Store)
```bash
flutter build appbundle --release
# → build/app/outputs/bundle/release/app-release.aab
```

---

## 🐢 Configurer l'icône Tortue Marine (Launcher Icon)

### Option A : Icône PNG personnalisée
1. Créer une image PNG 1024×1024 de la tortue bleue
2. Ajouter le package dans `pubspec.yaml` :
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/icons/turtle_icon.png"
  adaptive_icon_background: "#0A1628"
  adaptive_icon_foreground: "assets/icons/turtle_icon_fg.png"
```
3. Générer les icônes :
```bash
dart run flutter_launcher_icons
```

### Option B : Icône programmatique (via le CustomPainter)
Le `SeaTurtleLogo` widget peut être exporté en PNG via `RepaintBoundary` :
```dart
// Dans un utilitaire de génération d'icône
final boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
final image = await boundary.toImage(pixelRatio: 3.0);
final byteData = await image.toByteData(format: ImageByteFormat.png);
```

---

## 🔐 Code PIN d'Accès

| Code | Accès |
|------|-------|
| **270697** | ✅ Dashboard principal |
| Tout autre code | ❌ Animation d'erreur (vibration rouge) |

Pour modifier le PIN → `lib/screens/lock_screen.dart` ligne :
```dart
static const String _correctPin = '270697';
```

---

## 🎨 Personnalisation du Thème

Toutes les couleurs sont centralisées dans `lib/utils/app_theme.dart` :

```dart
class AppColors {
  static const Color deepOcean  = Color(0xFF0A1628); // Fond principal
  static const Color brightBlue = Color(0xFF1A7FD4); // Accent primaire
  static const Color accentCyan = Color(0xFF00D4FF); // Accent secondaire
  static const Color accentTeal = Color(0xFF00B8A0); // Succès/positif
  static const Color errorRed   = Color(0xFFFF4757); // Erreur/dépassement
  // ...
}
```

---

## 📊 Personnaliser les Données JSON

Éditer `assets/data/grants.json` en respectant ce format :
```json
[
  {
    "id": "1",
    "cost_category": "Nom de la catégorie",
    "amendment": 450000.0,
    "total_spend": 312500.0,
    "rest_against_amendment": 137500.0,
    "description": "Description courte"
  }
]
```

**Calcul automatique :** `rest_against_amendment = amendment - total_spend`

---

## 🚀 Fonctionnalités Clés

| Fonctionnalité | Écran | Description |
|---|---|---|
| PIN Lock | LockScreen | Code 270697, vibration sur erreur |
| Dashboard | DashboardScreen | KPIs globaux, taux d'exécution |
| Liste Subventions | GrantsListScreen | Détails par catégorie, expandable |
| Simulation | SimulationScreen | Multiplicateur global + ajustements individuels |
| Graphique Comparatif | SimulationScreen | Barres côte-à-côte Réel vs Prévisionnel |
| Logo Tortue | SeaTurtleLogo | CustomPainter Flutter natif |
| Glassmorphism | GlassCard | BackdropFilter, blur, transparence |

---

## 🐛 Dépannage

```bash
# Nettoyer le build
flutter clean && flutter pub get

# Regénérer les fichiers générés
flutter pub run build_runner build --delete-conflicting-outputs

# Vérifier les erreurs de compilation
flutter analyze

# Logs en temps réel
flutter logs
```

---

## 📦 Dépendances Utilisées

| Package | Version | Usage |
|---|---|---|
| `provider` | ^6.1.1 | Gestion d'état |
| `fl_chart` | ^0.66.2 | Graphiques (BarChart) |
| `google_fonts` | ^6.1.0 | Orbitron + Inter |
| `animate_do` | ^3.3.1 | Animations FadeIn/SlideUp |
| `shared_preferences` | ^2.2.2 | Persistance locale |
| `intl` | ^0.19.0 | Formatage devises |

---

*Application Sea Turtle Grants Management — Deep Ocean & Clean Tech Theme*
*Architecture : Clean Architecture + Provider Pattern*
