# Langues Oubliées

Application Flutter éducative pour découvrir les langues anciennes.
La V1 est centrée sur les runes (alphabet, détail, translittération, quiz, favoris, historique), avec une architecture prête pour ajouter d'autres langues.

## Stack technique

- Flutter + Dart (null safety)
- Material 3
- Navigation: `go_router`
- State management: `provider`
- Stockage local: `shared_preferences`
- Police: `google_fonts`
- Animation légère: `flutter_animate`
- Données locales: `assets/data/runes.json`

## Lancer le projet

1. `cd langues_oubliees`
2. `flutter pub get`
3. `flutter run`

## Fonctionnalités incluses

- Accueil moderne avec accès aux sections
- Découverte historique des runes
- Alphabet runique + recherche
- Détail d'une rune + ajout aux favoris
- Translittération français -> runes
- Quiz interactif (types de questions mélangés)
- Favoris (runes + traductions)
- Historique des translittérations
- Bascule thème clair/sombre
- Page À propos

## Architecture

```text
lib/
  app.dart
  main.dart
  core/
    constants/
      app_routes.dart
      storage_keys.dart
    router/
      app_router.dart
    services/
      local_storage_service.dart
      transliteration_service.dart
    utils/
      date_formatter.dart
      id_generator.dart
  data/
    local/
      runes_repository.dart
  models/
    favorite_item.dart
    quiz_question.dart
    rune_model.dart
    translation_history_item.dart
  providers/
    favorites_provider.dart
    history_provider.dart
    quiz_provider.dart
    runes_provider.dart
    theme_provider.dart
  screens/
    about_screen.dart
    alphabet_screen.dart
    discover_screen.dart
    favorites_screen.dart
    history_screen.dart
    home_screen.dart
    main_shell_screen.dart
    quiz_screen.dart
    rune_detail_screen.dart
    translate_screen.dart
  theme/
    app_theme.dart
  widgets/
    empty_state_view.dart
    mystic_background.dart
    rune_list_card.dart
    section_card.dart
assets/
  data/
    runes.json
```

## Comment ajouter une nouvelle langue ancienne

1. Ajouter un nouveau fichier de données local (ex: `assets/data/latin.json`).
2. Créer un modèle dédié si les champs diffèrent de `RuneModel`.
3. Ajouter un repository local pour charger ces données.
4. Créer un provider dédié (ex: `LatinProvider`).
5. Créer les écrans (liste, détail, éventuellement quiz spécifique).
6. Ajouter les routes dans `app_router.dart`.
7. Ajouter une carte d'accès sur l'accueil.

## Notes pédagogiques

- La translittération n'est pas une traduction linguistique complète.
- Les caractères non supportés sont remplacés par `·`.
- Le stockage est local uniquement (sans backend, sans API externe).

