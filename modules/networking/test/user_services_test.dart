import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/dto/user/user_initialization_dto.dart';
import 'package:networking/config/dio_interceptor.dart';
import 'package:networking/services/user_services.dart';

class MockUserServices extends Mock implements UserService {
  @override
  final DioInterceptor client;

  MockUserServices({required this.client});
}

class MockDioInterceptor extends Mock implements DioInterceptor {}

void main() {
  late UserService mockUserServices;
  late DioInterceptor mockDioInterceptor;
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.instance;
    getIt.registerSingleton<DioInterceptor>(MockDioInterceptor());
    mockDioInterceptor = getIt.get<DioInterceptor>();

    getIt.registerFactory<UserService>(
      () => UserService(
        client: getIt.get<DioInterceptor>(),
      ),
    );
    mockUserServices = getIt.get<UserService>();
  });

  setUpAll(() {
    registerFallbackValue(
      const UserInitializationDTO(
        id: 'id',
        name: 'name',
        email: 'email',
        profilePicture: "example.com",
      ),
    );
  });

  tearDown(() {
    getIt.reset();
  });

  group(
    'UserService',
    () {
      const initializationDTO = UserInitializationDTO(
        id: 'id',
        name: 'name',
        email: 'email',
        profilePicture: "example.com",
      );

      test("Test Initialize User When User Already Been Initialized", () async {
        when(() =>
                mockDioInterceptor.apiPost('/users', data: any(named: 'data')))
            .thenAnswer(
          (_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/users'),
          ),
        );

        await mockUserServices.initializeUser(initializationDTO);

        verify(
          () => mockDioInterceptor.apiPost('/users',
              data: initializationDTO.toJson()),
        ).called(1);
      });

      test("Test Initialize User When User Not Been Initialized", () async {
        when(() =>
                mockDioInterceptor.apiPost('/users', data: any(named: 'data')))
            .thenAnswer(
          (_) async => Response(
            statusCode: 201,
            requestOptions: RequestOptions(path: '/users'),
          ),
        );

        await mockUserServices.initializeUser(initializationDTO);

        verify(
          () => mockDioInterceptor.apiPost('/users',
              data: initializationDTO.toJson()),
        ).called(1);
      });

      test("Test Initialize User When User Not Been Initialized", () async {
        when(() =>
                mockDioInterceptor.apiPost('/users', data: any(named: 'data')))
            .thenAnswer(
          (_) async => Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/users'),
            data: {
              "error": "Internal Server Error",
            },
          ),
        );

        callInitialize() async =>
            await mockUserServices.initializeUser(initializationDTO);

        expect(callInitialize(), throwsA("Internal Server Error"));

        verify(
          () => mockDioInterceptor.apiPost('/users',
              data: initializationDTO.toJson()),
        ).called(1);
      });

      test("Test Initialize User When User Not Been Initialized", () async {
        when(() =>
                mockDioInterceptor.apiPost('/users', data: any(named: 'data')))
            .thenThrow(
          "Connection Error",
        );

        callInitialize() async =>
            await mockUserServices.initializeUser(initializationDTO);

        expect(callInitialize(), throwsA("Connection Error"));

        verify(
          () => mockDioInterceptor.apiPost('/users',
              data: initializationDTO.toJson()),
        ).called(1);
      });
    },
  );
}
