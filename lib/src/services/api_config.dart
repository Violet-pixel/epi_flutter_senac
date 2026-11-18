class ApiConfig {
// Pode ser trocada na hora do build com --dart-define=API_URL=...
static const String baseUrl = String.fromEnvironment(
'API_URL',
defaultValue: 'https://api-flutter-senac.onrender.com',
);
}