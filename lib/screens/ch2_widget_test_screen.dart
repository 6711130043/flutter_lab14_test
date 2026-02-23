import 'package:flutter/material.dart';
import '../widgets/counter_widget.dart';

class Ch2WidgetTestScreen extends StatefulWidget {
  const Ch2WidgetTestScreen({super.key});

  @override
  State<Ch2WidgetTestScreen> createState() => _Ch2WidgetTestScreenState();
}

class _Ch2WidgetTestScreenState extends State<Ch2WidgetTestScreen> {
  List<String> testSteps = [];
  bool isRunning = false;

  void _runWidgetTests() async {
    setState(() {
      testSteps = [];
      isRunning = true;
    });

    final tests = [
      ('find.byType(CounterWidget)', 'ค้นหา CounterWidget'),
      ('find.byKey(Key("counter_text"))', 'ค้นหา Text widget ด้วย Key'),
      ('expect(find.text("0"), findsOneWidget)', 'ตรวจสอบว่า Text "0" มีอยู่'),
      ('await tester.tap(find.byIcon(Icons.add))', 'แตะปุ่ม Add'),
      ('await tester.pumpWidget()', 'รีเฟรช UI'),
      ('expect(find.text("1"), findsOneWidget)', 'ตรวจสอบว่า Text เปลี่ยนเป็น "1"'),
      ('await tester.tap(find.byIcon(Icons.remove))', 'แตะปุ่ม Remove'),
      ('expect(find.text("0"), findsOneWidget)', 'ตรวจสอบว่า Text กลับเป็น "0"'),
    ];

    for (final (testName, description) in tests) {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        testSteps.add(description);
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => isRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('บทที่ 2: Widget Test'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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
                    'Widget Testing คืออะไร?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Widget Test ใช้ทดสอบ UI components โดยจำลองการกระทำของผู้ใช้ เช่น การแตะปุ่ม การพิมพ์ข้อความ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Widget Demo Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Widget ตัวอย่าง:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const CounterWidget(initialCount: 0),
                  ),
                ],
              ),
            ),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: isRunning ? null : _runWidgetTests,
                icon: const Icon(Icons.play_arrow),
                label: const Text('เริ่ม Widget Test'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Test Results Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ผลการทดสอบ:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (testSteps.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: Text('กด "เริ่ม Widget Test" เพื่อดูการทดสอบ'),
                      ),
                    )
                  else
                    Column(
                      children: List.generate(
                        testSteps.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _TestStepCard(
                            step: testSteps[index],
                            index: index,
                            total: testSteps.length,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Status Section
            if (testSteps.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('ทั้งหมดผ่านการทดสอบ!'),
                          ),
                          if (isRunning)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _TestStepCard extends StatelessWidget {
  final String step;
  final int index;
  final int total;

  const _TestStepCard({
    required this.step,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(step),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
