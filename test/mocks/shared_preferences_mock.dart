import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SharedPreferences])
import 'shared_preferences_mock.mocks.dart';

/// Helper function สำหรับสร้าง mock SharedPreferences
MockSharedPreferences createMockPrefs() {
  return MockSharedPreferences();
}
