import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_demo/screens/auth/auth_screen.dart';
import 'package:flutter_testing_demo/providers/auth_provider.dart';
import 'package:flutter_testing_demo/services/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthService])
import 'auth_flow_test.mocks.dart';

void main() {
  // Ignore Hero warnings during tests
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exception.toString().contains('There are multiple heroes')) {
      return;
    }
    originalOnError?.call(details);
  };

  group('Auth Screen Integration Tests', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
      when(mockAuthService.getCurrentUser()).thenAnswer((_) async => null);
    });

    Widget createTestWidget({Widget? child}) {
      return ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: MaterialApp(
          home: child ?? const AuthScreen(),
        ),
      );
    }

    testWidgets('should display login form initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify login mode is displayed
      expect(find.text('เข้าสู่ระบบ'), findsWidgets);
      expect(find.text('อีเมล'), findsOneWidget);
      expect(find.text('รหัสผ่าน'), findsOneWidget);
      expect(find.text('ยินดีต้อนรับกลับ'), findsOneWidget);
    });

    testWidgets('should display register form when initialMode is register',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AuthScreen(initialMode: AuthMode.register),
        ),
      );
      await tester.pumpAndSettle();

      // Verify register mode is displayed
      expect(find.text('ชื่อแสดง'), findsOneWidget);
      expect(find.text('อีเมล'), findsOneWidget);
      expect(find.text('รหัสผ่าน'), findsOneWidget);
      expect(find.text('ยืนยันรหัสผ่าน'), findsOneWidget);
      expect(find.text('สร้างบัญชีใหม่'), findsOneWidget);
    });

    testWidgets('should validate email format', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find all TextFields
      final textFields = find.byType(TextField);

      // Enter invalid email (first field)
      await tester.enterText(textFields.first, 'invalid-email');
      await tester.pumpAndSettle();

      // Should show error
      expect(find.text('รูปแบบอีเมลไม่ถูกต้อง'), findsOneWidget);
    });

    testWidgets('should validate password length', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find all TextFields
      final textFields = find.byType(TextField);

      // Enter short password (second field)
      await tester.enterText(textFields.at(1), '12345');
      await tester.pumpAndSettle();

      // Should show error
      expect(find.text('รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร'),
          findsOneWidget);
    });

    testWidgets('should validate password mismatch in register mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AuthScreen(initialMode: AuthMode.register),
        ),
      );
      await tester.pumpAndSettle();

      // Find all TextFields
      final textFields = find.byType(TextField);
      expect(textFields, findsAtLeastNWidgets(4));

      // Fill in form
      await tester.enterText(textFields.at(0), 'Test User'); // Display name
      await tester.enterText(textFields.at(1), 'test@example.com'); // Email
      await tester.enterText(textFields.at(2), 'password123'); // Password
      await tester.enterText(textFields.at(3), 'password456'); // Confirm password
      await tester.pumpAndSettle();

      // Should show password mismatch error
      expect(find.text('รหัสผ่านไม่ตรงกัน'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find password field (second TextField)
      final passwordField = find.byType(TextField).at(1);

      // Initially obscured
      var textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isTrue);

      // Tap visibility icon
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Now visible
      textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isFalse);
    });

    testWidgets('should display back button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('กลับหน้าหลัก'), findsOneWidget);
    });

    testWidgets('should display toggle link between login and register',
        (WidgetTester tester) async {
      // Test login mode toggle link
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('ยังไม่มีบัญชี?'), findsOneWidget);
      expect(find.text('สมัครสมาชิก'), findsOneWidget);
    });

    testWidgets('should display register mode toggle link',
        (WidgetTester tester) async {
      // Test register mode toggle link (separate test to avoid state issues)
      await tester.pumpWidget(
        createTestWidget(
          child: const AuthScreen(initialMode: AuthMode.register),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('มีบัญชีอยู่แล้ว?'), findsOneWidget);
      expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
    });
  });
}
