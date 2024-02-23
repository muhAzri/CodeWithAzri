import 'package:auth/data/dto/auth/sign_in_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignInDTO', () {
    test('toJson() should return a valid Map', () {
      // Arrange
      const signInDTO = SignInDTO(email: 'test@example.com', password: 'password123');

      // Act
      final jsonMap = signInDTO.toJson();

      // Assert
      expect(jsonMap, isA<Map<String, dynamic>>());
      expect(jsonMap['email'], equals('test@example.com'));
      expect(jsonMap['password'], equals('password123'));
    });

    test('fromJson() should return a valid SignInDTO object', () {
      // Arrange
      final jsonMap = {
        'email': 'test@example.com',
        'password': 'password123',
      };

      // Act
      final signInDTO = SignInDTO.fromJson(jsonMap);

      // Assert
      expect(signInDTO, isA<SignInDTO>());
      expect(signInDTO.email, equals('test@example.com'));
      expect(signInDTO.password, equals('password123'));
    });

    test('Equatable should properly compare instances', () {
      // Arrange
      const signInDTO1 = SignInDTO(email: 'test@example.com', password: 'password123');
      const signInDTO2 = SignInDTO(email: 'test@example.com', password: 'password123');

      // Act
      final areEqual = signInDTO1 == signInDTO2;

      // Assert
      expect(areEqual, isTrue);
    });
  });
}
