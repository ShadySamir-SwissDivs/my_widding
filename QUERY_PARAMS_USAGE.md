# Using Query Parameters in Flutter Web

## How to Use

Your app now supports URL query parameters! You can pass data through the URL.

### Example URLs:

**Basic URL:**
```
https://your-app.web.app/
```

**With guest name:**
```
https://your-app.web.app/?name=Ahmed
```

**With guest name and invitation code:**
```
https://your-app.web.app/?name=Ahmed&code=INV123
```

**Multiple parameters:**
```
https://your-app.web.app/?name=Sarah%20Ahmed&code=WEDDING2024
```

## Supported Parameters:

- `name` - Guest name (displays "Welcome, [name]!" on splash screen and "Dear [name]" in card)
- `code` - Invitation code (displays in the card)

## Testing Locally:

When running locally with `flutter run -d chrome`, use:
```
http://localhost:PORT/?name=Ahmed&code=INV123
```

## How It Works:

1. The app reads query parameters from the URL using `Uri.base`
2. Parameters are passed from SplashScreen to WeddingCardScreen
3. Guest name displays on both splash screen and inside the card
4. Invitation code displays inside the card when opened

## Adding More Parameters:

To add more parameters, update these sections in `lib/main.dart`:

1. Add variable in `_SplashScreenState`:
```dart
String newParam = '';
```

2. Read it in `_readQueryParameters()`:
```dart
newParam = uri.queryParameters['param_name'] ?? 'default';
```

3. Pass it to WeddingCardScreen:
```dart
WeddingCardScreen(
  guestName: guestName,
  invitationCode: invitationCode,
  newParam: newParam,
)
```

4. Add to WeddingCardScreen constructor:
```dart
final String newParam;
const WeddingCardScreen({
  super.key,
  this.guestName = 'Guest',
  this.invitationCode = '',
  this.newParam = '',
});
```
