import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('should not be initialized', () {
      expect(provider.isInitialized, false);
    });

    test('cannot logOut of not Initialized', () {
      provider.logOut();
      throwsA(const TypeMatcher<NotInitializedException>());
    });

    test('should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('the user should be null', () {
      expect(provider.currentUser, null);
    });

    test('should initialize in less than 2 seconds', () async {
      await provider.initialized;
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
          email: 'malikusama882@gmail.com', password: 'anypassword');

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotfoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@google.com',
        password: 'usama1234',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user = await provider.createUser(email: 'usama', password: 'pass');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('logged in user shoould be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('user should be able to log in and log out again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class Initialized {}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  get initialized => null;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'malikusama882@gmail.com') throw UserNotfoundAuthException();
    if (password == 'usama1234') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'anyemail@');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotfoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotfoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'anyemail@');
    _user = newUser;
  }
}
