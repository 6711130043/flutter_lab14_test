import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/test_result.dart';
import '../services/calculator.dart';

/// Provider for calculator instance
final calculatorProvider = Provider((ref) => Calculator());

/// Test runner state notifier
class TestRunnerNotifier extends StateNotifier<List<TestResult>> {
  final Calculator calculator;

  TestRunnerNotifier(this.calculator) : super([
    TestResult(
      name: 'บวก 2 + 3',
      passed: false,
      duration: 0,
      description: 'ทดสอบการบวกเลขสองจำนวน',
    ),
    TestResult(
      name: 'ลบ 5 - 3',
      passed: false,
      duration: 0,
      description: 'ทดสอบการลบเลขสองจำนวน',
    ),
    TestResult(
      name: 'คูณ 3 × 4',
      passed: false,
      duration: 0,
      description: 'ทดสอบการคูณเลขสองจำนวน',
    ),
    TestResult(
      name: 'หาร 12 ÷ 3',
      passed: false,
      duration: 0,
      description: 'ทดสอบการหารเลขสองจำนวน',
    ),
    TestResult(
      name: 'หาร ÷ 0 (Error)',
      passed: false,
      duration: 0,
      description: 'ทดสอบการหารด้วยศูนย์ที่ควรทำให้เกิด Error',
    ),
    TestResult(
      name: 'แฟกทอเรียล 5!',
      passed: false,
      duration: 0,
      description: 'ทดสอบการคำนวณแฟกทอเรียล',
    ),
    TestResult(
      name: 'เลขเฉพาะ (7)',
      passed: false,
      duration: 0,
      description: 'ทดสอบการตรวจสอบเลขเฉพาะ',
    ),
  ]);

  /// Run a specific test by index
  Future<void> runTest(int index) async {
    if (index < 0 || index >= state.length) return;

    final stopwatch = Stopwatch()..start();

    try {
      final test = state[index];

      // Simulate test execution with a small delay
      await Future.delayed(const Duration(milliseconds: 500));

      bool passed = false;
      String? error;

      switch (index) {
        case 0:
          passed = calculator.add(2, 3) == 5;
          break;
        case 1:
          passed = calculator.subtract(5, 3) == 2;
          break;
        case 2:
          passed = calculator.multiply(3, 4) == 12;
          break;
        case 3:
          passed = calculator.divide(12, 3) == 4;
          break;
        case 4:
          try {
            calculator.divide(5, 0);
            passed = false;
            error = 'ไม่ได้ทำให้เกิด ArgumentError';
          } catch (e) {
            passed = true;
          }
          break;
        case 5:
          passed = calculator.factorial(5) == 120;
          break;
        case 6:
          passed = calculator.isPrime(7) == true;
          break;
      }

      stopwatch.stop();

      state = [
        ...state.sublist(0, index),
        test.copyWith(
          passed: passed,
          duration: stopwatch.elapsedMilliseconds,
          error: error,
        ),
        ...state.sublist(index + 1),
      ];
    } catch (e) {
      stopwatch.stop();
      final test = state[index];
      state = [
        ...state.sublist(0, index),
        test.copyWith(
          passed: false,
          duration: stopwatch.elapsedMilliseconds,
          error: e.toString(),
        ),
        ...state.sublist(index + 1),
      ];
    }
  }

  /// Run all tests sequentially
  Future<void> runAllTests() async {
    for (int i = 0; i < state.length; i++) {
      await runTest(i);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  /// Reset all test results
  void resetTests() {
    state = state
        .map((test) => test.copyWith(passed: false, duration: 0, error: null))
        .toList();
  }
}

/// Test runner provider
final testRunnerProvider =
    StateNotifierProvider<TestRunnerNotifier, List<TestResult>>((ref) {
  final calculator = ref.watch(calculatorProvider);
  return TestRunnerNotifier(calculator);
});
