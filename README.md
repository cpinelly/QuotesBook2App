# quotesbook

A new Flutter project.

## Utilities commands


Create base arb files for localization.
```
flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/helpers/app_localizations.dart
```
Generate source code for localization messages from arb files.
```
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/helpers/app_localizations.dart lib/l10n/intl_*.arb
```
