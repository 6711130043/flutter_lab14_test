import 'package:flutter/material.dart';

class Ch3IntegrationTestScreen extends StatefulWidget {
  const Ch3IntegrationTestScreen({super.key});

  @override
  State<Ch3IntegrationTestScreen> createState() => _Ch3IntegrationTestScreenState();
}

class _Ch3IntegrationTestScreenState extends State<Ch3IntegrationTestScreen> {
  List<_TestStep> steps = [];
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    steps = [
      _TestStep(name: 'เข้าสู่ระบบ', status: _StepStatus.idle),
      _TestStep(name: 'แสดง Dashboard', status: _StepStatus.idle),
      _TestStep(name: 'เปิด Settings', status: _StepStatus.idle),
      _TestStep(name: 'บันทึกการตั้งค่า', status: _StepStatus.idle),
      _TestStep(name: 'ออกจากระบบ', status: _StepStatus.idle),
    ];
  }

  Future<void> _runIntegrationTest() async {
    setState(() => isRunning = true);

    for (int i = 0; i < steps.length; i++) {
      // Running
      setState(() {
        steps[i] = steps[i].copyWith(status: _StepStatus.running);
      });

      await Future.delayed(const Duration(milliseconds: 600));

      // Passed
      setState(() {
        steps[i] = steps[i].copyWith(status: _StepStatus.passed);
      });

      if (i < steps.length - 1) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    setState(() => isRunning = false);
  }

  void _resetTest() {
    setState(() {
      steps = steps
          .map((step) => step.copyWith(status: _StepStatus.idle))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = steps.where((s) => s.status != _StepStatus.idle).length;
    final progressPercent = progress / steps.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('บทที่ 3: Integration Test'),
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
                    'Integration Testing คืออะไร?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Integration Test ทดสอบการทำงานร่วมกันของหลายส่วนของแอป โดยจำลองการทำงานจากต้นจนจบของ User Flow',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ความคืบหน้า',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(progressPercent * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progressPercent,
                      minHeight: 8,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ],
              ),
            ),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isRunning ? null : _runIntegrationTest,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('เริ่ม Test'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _resetTest,
                    icon: const Icon(Icons.refresh),
                    label: const Text('รีเซต'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Flow Diagram
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _FlowDiagram(steps: steps),
            ),

            const SizedBox(height: 24),

            // Steps Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'รายละเอียด Integration Test:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    steps.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _StepCard(step: steps[index], index: index),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

enum _StepStatus { idle, running, passed, failed }

class _TestStep {
  final String name;
  final _StepStatus status;
  final String? error;

  _TestStep({
    required this.name,
    required this.status,
    this.error,
  });

  _TestStep copyWith({
    String? name,
    _StepStatus? status,
    String? error,
  }) {
    return _TestStep(
      name: name ?? this.name,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class _FlowDiagram extends StatelessWidget {
  final List<_TestStep> steps;

  const _FlowDiagram({required this.steps});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 120,
        child: Row(
          children: List.generate(
            steps.length * 2 - 1,
            (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                final step = steps[stepIndex];
                return _FlowBox(
                  label: step.name,
                  status: step.status,
                );
              } else {
                return Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey[400],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _FlowBox extends StatelessWidget {
  final String label;
  final _StepStatus status;

  const _FlowBox({
    required this.label,
    required this.status,
  });

  Color get _getColor {
    switch (status) {
      case _StepStatus.idle:
        return Colors.grey.withOpacity(0.3);
      case _StepStatus.running:
        return Colors.amber;
      case _StepStatus.passed:
        return Colors.green;
      case _StepStatus.failed:
        return Colors.red;
    }
  }

  IconData get _getIcon {
    switch (status) {
      case _StepStatus.idle:
        return Icons.radio_button_unchecked;
      case _StepStatus.running:
        return Icons.hourglass_bottom;
      case _StepStatus.passed:
        return Icons.check_circle;
      case _StepStatus.failed:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getColor.withOpacity(0.2),
        border: Border.all(color: _getColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIcon, color: _getColor, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _getColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final _TestStep step;
  final int index;

  const _StepCard({
    required this.step,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final icon = {
      _StepStatus.idle: Icons.radio_button_unchecked,
      _StepStatus.running: Icons.hourglass_bottom,
      _StepStatus.passed: Icons.check_circle,
      _StepStatus.failed: Icons.cancel,
    }[step.status];

    final color = {
      _StepStatus.idle: Colors.grey,
      _StepStatus.running: Colors.amber,
      _StepStatus.passed: Colors.green,
      _StepStatus.failed: Colors.red,
    }[step.status];

    const descriptions = [
      'เข้าสู่ระบบด้วยข้อมูลประจำตัว',
      'แสดง Dashboard หลังจากเข้าสู่ระบบ',
      'เปิด Settings page',
      'บันทึกการตั้งค่าใหม่',
      'ออกจากระบบสำเร็จ',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        border: Border.all(
          color: color?.withOpacity(0.3) ?? Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ขั้นตอนที่ ${index + 1}: ${step.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  descriptions[index],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
