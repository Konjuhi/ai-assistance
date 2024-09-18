import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// Import OAuth providers if used
// import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
// import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';

final emailLinkProviderConfig = EmailLinkAuthProvider(
  actionCodeSettings: auth.ActionCodeSettings(
    url: 'https://<your-app-url>',
    handleCodeInApp: true,
    androidPackageName: 'com.example.ai_assistant_app',
    androidInstallApp: true,
    androidMinimumVersion: '12',
  ),
);

final authProviders = <AuthProvider>[
  EmailAuthProvider(),
  // Add other providers if needed
  // GoogleProvider(clientId: 'YOUR_GOOGLE_CLIENT_ID'),
  // FacebookProvider(clientId: 'YOUR_FACEBOOK_CLIENT_ID'),
];
