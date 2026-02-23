import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_demo/screens/auth/auth_screen.dart';
import 'package:flutter_testing_demo/providers/auth_provider.dart';
import 'package:flutter_testing_demo/services/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([SharedPreferences, AuthService])
import 'auth_screen_test.mocks.dart';

void main() {
  late MockSharedPreferences mockPrefs;
  late MockAuthService mockAuthService;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockAuthService = MockAuthService();

    // Setup default mock behaviors
    when(mockPrefs.getString(any)).thenReturn(null);
    when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
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

  group('AuthScreen Widget Tests', () {
    testWidgets('should display login form elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for email field
      expect(find.text('อีเมล'), findsOneWidget);

      // Check for password field
      expect(find.text('รหัสผ่าน'), findsOneWidget);

      // Check for welcome message
      expect(find.text('ยินดีต้อนรับกลับ'), findsOneWidget);

      // Should NOT display register-specific fields
      expect(find.text('ชื่อแสดง'), findsNothing);
      expect(find.text('ยืนยันรหัสผ่าน'), findsNothing);
    });

    testWidgets('should start in register mode when specified',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AuthScreen(initialMode: AuthMode.register),
        ),
      );
      await tester.pumpAndSettle();

      // Should show register mode
      expect(find.text('ชื่อแสดง'), findsOneWidget);
      expect(find.text('ยืนยันรหัสผ่าน'), findsOneWidget);
      expect(find.text('สร้างบัญชีใหม่'), findsOneWidget);
    });

    testWidgets('should show validation error for short password',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find all TextFields
      final textFields = find.byType(TextField);
      expect(textFields, findsAtLeastNWidgets(2));

      // The second TextField should be password (after email)
      await tester.enterText(textFields.at(1), '12345');
      await tester.pumpAndSettle();

      // Check for error message
      expect(find.text('รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร'),
          findsOneWidget);
    });

    testWidgets('should show validation error for invalid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find all TextFields
      final textFields = find.byType(TextField);
      expect(textFields, findsAtLeastNWidgets(2));

      // The first TextField should be email
      await tester.enterText(textFields.first, 'invalid-email');
      await tester.pumpAndSettle();

      // Check for error message
      expect(find.text('รูปแบบอีเมลไม่ถูกต้อง'), findsOneWidget);
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
      final visibilityIcon = find.byIcon(Icons.visibility_outlined);
      expect(visibilityIcon, findsOneWidget);
      await tester.tap(visibilityIcon);
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

    testWidgets('should display submit button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('เข้าสู่ระบบ'), findsWidgets);
    });

    testWidgets('should display toggle link', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('ยังไม่มีบัญชี?'), findsOneWidget);
      expect(find.text('สมัครสมาชิก'), findsOneWidget);
    });
  });
}
