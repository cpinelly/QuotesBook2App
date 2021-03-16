# quotesbook

Flutter project for QuotesBook mobile app.

# Setup

1. Add lib/environment.dart file with

```
class Environment {
  static const AUTH_TOKEN = "...";
  static const SERVER_HOST = "...";
}
```

2. Add android/key.properties to sign apk/bundle.

Remember to add the google-services.json to the android/app folder. Get this from the firebase
project.

## To generate internationalizations

1. Update the ```lib/helpers/app_localizations.dart``` with the new texts.

2. Create base arb base file for localization.
```
flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/helpers/app_localizations.dart
```

3. Update the files ```I10n/*_en.arb``` languages specific files with translations.

4. Generate source code for localization messages from arb files.
```
flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/helpers/app_localizations.dart lib/l10n/intl_*.arb
```
