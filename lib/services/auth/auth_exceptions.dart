// loginView exceptions
class UserNotfoundAuthException implements Exception{}
class WrongPasswordAuthException implements Exception{}

// registerView exceptions
class WeakPasswordAuthException implements Exception{}
class EmailAlreadyInUseAuthException implements Exception{}
class InvalidEmailAuthException implements Exception{}

// generic exceptions
class GenericAuthException implements Exception{}
class UserNotLoggedInAuthException implements Exception{}