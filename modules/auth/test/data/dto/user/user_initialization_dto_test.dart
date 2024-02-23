import 'package:auth/data/dto/user/user_initialization_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserInitializationDTO', () {
    test('toJson() should return a valid Map', () {
      // Arrange
      const userDTO = UserInitializationDTO(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        profilePicture: 'profile.jpg',
      );

      // Act
      final jsonMap = userDTO.toJson();

      // Assert
      expect(jsonMap, isA<Map<String, dynamic>>());
      expect(jsonMap['id'], equals('1'));
      expect(jsonMap['name'], equals('John Doe'));
      expect(jsonMap['email'], equals('john@example.com'));
      expect(jsonMap['profilePicture'], equals('profile.jpg'));
    });

    test('fromJson() should return a valid UserInitializationDTO object', () {
      // Arrange
      final jsonMap = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'profilePicture': 'profile.jpg',
      };

      // Act
      final userDTO = UserInitializationDTO.fromJson(jsonMap);

      // Assert
      expect(userDTO, isA<UserInitializationDTO>());
      expect(userDTO.id, equals('1'));
      expect(userDTO.name, equals('John Doe'));
      expect(userDTO.email, equals('john@example.com'));
      expect(userDTO.profilePicture, equals('profile.jpg'));
    });

    test('Equatable should properly compare instances', () {
      // Arrange
      const userDTO1 = UserInitializationDTO(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        profilePicture: 'profile.jpg',
      );

      const userDTO2 = UserInitializationDTO(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        profilePicture: 'profile.jpg',
      );

      // Act
      final areEqual = userDTO1 == userDTO2;

      // Assert
      expect(areEqual, isTrue);
    });

    test('Props should contain all properties', () {
      const userDTO = UserInitializationDTO(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        profilePicture: 'profile.jpg',
      );

      final props = userDTO.props;

      print(props);

      expect(props.contains('1'), isTrue);
      expect(props.contains('John Doe'), isTrue);
      expect(props.contains('john@example.com'), isTrue);
      expect(props.contains('profile.jpg'), isTrue);
    });
  });
}
