import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/test_runner_provider.dart';
import '../models/test_result.dart';

class Ch1UnitTestScreen extends ConsumerWidget {
  const Ch1UnitTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(testRunnerProvider);
    final notifier = ref.read(testRunnerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('บทที่ 1: Unit Test พื้นฐาน'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.green.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unit Testing คืออะไร?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unit Test เป็นการทดสอบแต่ละส่วนของโค้ด (function, method) แยกออกจากกัน เพื่อให้แน่ใจว่าแต่ละส่วนทำงานได้ถูกต้อง',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => notifier.runAllTests(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('รันทั้งหมด'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => notifier.resetTests(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('รีเซต'),
                  ),
                ],
              ),
            ),

            // Test Results List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(
                  tests.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TestCard(
                      test: tests[index],
                      index: index,
                      onRun: () => notifier.runTest(index),
                    ),
                  ),
                ),
              ),
            ),

            // Code Example Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: _CodeExampleSection(),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class TestCard extends StatelessWidget {
  final TestResult test;
  final int index;
  final VoidCallback onRun;

  const TestCard({
    super.key,
    required this.test,
    required this.index,
    required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    final hasRun = test.duration > 0 || test.passed;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasRun
            ? (test.passed ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1))
            : Colors.grey.withOpacity(0.05),
        border: Border.all(
          color: hasRun
              ? (test.passed ? Colors.green : Colors.red)
              : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      test.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (hasRun)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    children: [
                      Icon(
                        test.passed ? Icons.check_circle : Icons.cancel,
                        color: test.passed ? Colors.green : Colors.red,
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${test.duration}ms',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: onRun,
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('รัน'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
            ],
          ),
          if (test.error != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ข้อผิดพลาด: ${test.error}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CodeExampleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 800,
          child: Text(
            '''test('should add two numbers', () {
  final calc = Calculator();
  expect(calc.add(2, 3), equals(5));
});

test('should throw on divide by zero', () {
  final calc = Calculator();
  expect(
    () => calc.divide(5, 0),
    throwsArgumentError,
  );
});''',
            style: TextStyle(
              fontFamily: 'Courier',
              color: Colors.green,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
