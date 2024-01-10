import 'package:models/dto/user/user_initialization_dto.dart';
import 'package:networking/config/dio_interceptor.dart';

class UserService {
  final DioInterceptor client;

  UserService({required this.client});

  Future<void> initializeUser(UserInitializationDTO dto) async {
    try {
      final response = await client.apiPost('/users', data: dto.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      }

      throw response.data['error'];
    } catch (e) {
      rethrow;
    }
  }
}
