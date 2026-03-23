import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stayverse/core/service/socialAuth/data/social_auth_credentials.dart';

class ThirdPartySignInService {
  // Private constructor
  ThirdPartySignInService._();
  
  // Single instance
  static final ThirdPartySignInService _instance = ThirdPartySignInService._();
  
  // Factory constructor to return the same instance
  factory ThirdPartySignInService() => _instance;
  
  // Alternatively, you can access the instance directly
  static ThirdPartySignInService get instance => _instance;
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  /// Sign in with Google and return credentials for backend
  Future<SocialAuthCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      // Return credential object
      return SocialAuthCredential(
        provider: 'google',
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
        email: googleUser.email,
        firstName: googleUser.displayName?.split(' ').first,
        lastName: googleUser.displayName?.split(' ').skip(1).join(' '),
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// Sign in with Apple and return credentials for backend
  Future<SocialAuthCredential?> signInWithApple() async {
    try {
      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      // Return credential object
      return SocialAuthCredential(
        provider: 'apple',
        idToken: appleCredential.identityToken ?? '',
        authorizationCode: appleCredential.authorizationCode,
        email: appleCredential.email,
        firstName: appleCredential.givenName,
        lastName: appleCredential.familyName,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// Sign out from Google
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
  
  /// Check if user is currently signed in with Google
  Future<bool> isSignedInWithGoogle() async {
    return await _googleSignIn.isSignedIn();
  }
  
  /// Get current Google user (if signed in)
  GoogleSignInAccount? get currentGoogleUser => _googleSignIn.currentUser;
}
