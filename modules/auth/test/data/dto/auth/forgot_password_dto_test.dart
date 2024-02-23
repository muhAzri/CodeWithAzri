import 'package:auth/data/dto/auth/forgot_password_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgotPassword', () {
    test('toJson() should return a valid Map', () {
      // Arrange
      const forgotPassword = ForgotPassword(email: 'test@example.com');

      // Act
      final jsonMap = forgotPassword.toJson();

      // Assert
      expect(jsonMap, isA<Map<String, dynamic>>());
      expect(jsonMap['email'], equals('test@example.com'));
    });

    test('fromJson() should return a valid ForgotPassword object', () {
      // Arrange
      final jsonMap = {
        'email': 'test@example.com',
      };

      // Act
      final forgotPassword = ForgotPassword.fromJson(jsonMap);

      // Assert
      expect(forgotPassword, isA<ForgotPassword>());
      expect(forgotPassword.email, equals('test@example.com'));
    });

    test('Equatable should properly compare instances', () {
      // Arrange
      const forgotPassword1 = ForgotPassword(email: 'test@example.com');
      const forgotPassword2 = ForgotPassword(email: 'test@example.com');

      // Act
      final areEqual = forgotPassword1 == forgotPassword2;

      // Assert
      expect(areEqual, isTrue);
    });
  });
}
