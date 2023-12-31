import 'package:auth/auth.dart';
import 'package:auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:networking/services/auth_services.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockAuthServiceImpl extends AuthServiceImpl {
  MockAuthServiceImpl({
    required super.firebaseAuth,
    required super.googleSignIn,
  });
}

class MockSignInBloc extends Mock implements SignInBloc {
  MockSignInBloc({required service}) {
    // Mock the close method to return a non-null Future.
    when(() => close()).thenAnswer((_) async {});
    // Mock any other methods you need here.
  }
}

class MockAuth extends Mock implements MockFirebaseAuth {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('GoogleSignInButton tests', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Scaffold(
            body: GoogleSignInButton(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(16.0),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Widget has correct width', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Scaffold(
            body: GoogleSignInButton(),
          ),
        ),
      );

      final imageFinder = find.byType(Image);
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.width, equals(274.w));
    });

    testWidgets('Widget has correct padding and margin',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Scaffold(
            body: GoogleSignInButton(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
              margin: EdgeInsets.all(20.0),
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      final containerWidget = tester.widget<Container>(containerFinder);
      expect(containerWidget.padding,
          equals(const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0)));
      expect(containerWidget.margin, equals(const EdgeInsets.all(20.0)));
    });

    testWidgets('Widget onTap callback is call Bloc Event Correctly',
        (WidgetTester tester) async {
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: MockGoogleSignIn());
      var newMockSignInBloc = MockSignInBloc(service: newAuthService);

      whenListen(
        newMockSignInBloc,
        Stream.fromIterable([
          SignInInitial(),
          SignInLoading(),
          SignInSuccess(),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        TestApp(
          home: BlocProvider<SignInBloc>(
            create: (context) => newMockSignInBloc,
            child: const Scaffold(
              body: GoogleSignInButton(
                bloc: SignInBloc,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final inkWellFinder = find.byType(InkWell);
      await tester.tap(inkWellFinder, warnIfMissed: false);

      await tester.pumpAndSettle();

      verify(
        () => newMockSignInBloc.add(SignInByGoogleRequest()),
      ).called(1);

      await tester.pumpAndSettle();
    });
  });
}

class TestApp extends StatelessWidget {
  final Widget home;
  const TestApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(393, 847),
    );
    return MaterialApp(
      home: home,
    );
  }
}
