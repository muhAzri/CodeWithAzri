import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignUpDTO', () {
    test('toJson() should return a valid Map', () {
      // Arrange
      const signUpDTO = SignUpDTO(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
      );

      // Act
      final jsonMap = signUpDTO.toJson();

      // Assert
      expect(jsonMap, isA<Map<String, dynamic>>());
      expect(jsonMap['name'], equals('John Doe'));
      expect(jsonMap['email'], equals('test@example.com'));
      expect(jsonMap['password'], equals('password123'));
    });

    test('fromJson() should return a valid SignUpDTO object', () {
      // Arrange
      final jsonMap = {
        'name': 'John Doe',
        'email': 'test@example.com',
        'password': 'password123',
      };

      // Act
      final signUpDTO = SignUpDTO.fromJson(jsonMap);

      // Assert
      expect(signUpDTO, isA<SignUpDTO>());
      expect(signUpDTO.name, equals('John Doe'));
      expect(signUpDTO.email, equals('test@example.com'));
      expect(signUpDTO.password, equals('password123'));
    });

    test('Equatable should properly compare instances', () {
      // Arrange
      const signUpDTO1 = SignUpDTO(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
      );

      const signUpDTO2 = SignUpDTO(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
      );

      // Act
      final areEqual = signUpDTO1 == signUpDTO2;

      // Assert
      expect(areEqual, isTrue);
    });
  });
}
