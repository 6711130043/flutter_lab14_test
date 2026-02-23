import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/pipeline_provider.dart';
import '../models/pipeline_stage.dart';

class Ch5CiCdScreen extends ConsumerWidget {
  const Ch5CiCdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stages = ref.watch(pipelineProvider);
    final coverage = ref.watch(coverageProvider);
    final notifier = ref.read(pipelineProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('บทที่ 5: CI/CD และ Coverage'),
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
                    'CI/CD Pipeline คืออะไร?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'CI/CD (Continuous Integration/Continuous Deployment) ทำให้การทดสอบและปล่อย build เป็นไปโดยอัตโนมัติ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Control Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => notifier.runPipeline(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('รัน Pipeline'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => notifier.resetPipeline(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('รีเซต'),
                  ),
                ],
              ),
            ),

            // Pipeline Stages
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pipeline Stages:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PipelineVisualization(stages: stages),
                  const SizedBox(height: 24),
                  const Text(
                    'รายละเอียดแต่ละ Stage:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    stages.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _StageCard(stage: stages[index]),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Coverage Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Code Coverage Report:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CoverageChart(coverage: coverage),
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

class _PipelineVisualization extends StatelessWidget {
  final List<PipelineStage> stages;

  const _PipelineVisualization({required this.stages});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 140,
        child: Row(
          children: List.generate(
            stages.length * 2 - 1,
            (index) {
              if (index.isEven) {
                final stageIndex = index ~/ 2;
                final stage = stages[stageIndex];
                return _PipelineBox(stage: stage);
              } else {
                return Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey[400],
                    size: 20,
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

class _PipelineBox extends StatelessWidget {
  final PipelineStage stage;

  const _PipelineBox({required this.stage});

  Color get _getColor {
    switch (stage.status) {
      case PipelineStatus.idle:
        return Colors.grey;
      case PipelineStatus.running:
        return Colors.amber;
      case PipelineStatus.passed:
        return Colors.green;
      case PipelineStatus.failed:
        return Colors.red;
    }
  }

  IconData get _getIcon {
    switch (stage.status) {
      case PipelineStatus.idle:
        return Icons.radio_button_unchecked;
      case PipelineStatus.running:
        return Icons.hourglass_bottom;
      case PipelineStatus.passed:
        return Icons.check_circle;
      case PipelineStatus.failed:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getColor.withOpacity(0.1),
        border: Border.all(
          color: _getColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIcon, color: _getColor, size: 28),
          const SizedBox(height: 4),
          Text(
            stage.thaiName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: _getColor,
            ),
          ),
          if (stage.duration > 0) ...[
            const SizedBox(height: 4),
            Text(
              '${stage.duration}ms',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  final PipelineStage stage;

  const _StageCard({required this.stage});

  @override
  Widget build(BuildContext context) {
    final statusColor = {
      PipelineStatus.idle: Colors.grey,
      PipelineStatus.running: Colors.amber,
      PipelineStatus.passed: Colors.green,
      PipelineStatus.failed: Colors.red,
    }[stage.status]!;

    const descriptions = [
      'ส่งโค้ดไปยัง Repository',
      'ตรวจสอบ code style และ lint errors',
      'รัน Unit Tests ทั้งหมด',
      'รัน Widget Tests ทั้งหมด',
      'รัน Integration Tests',
      'สร้าง APK/IPA Build',
      'ปล่อยแอปไปยัง App Store/Play Store',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        border: Border.all(
          color: statusColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                '${stage.index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage.thaiName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  descriptions[stage.index],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _StatusBadge(status: stage.status),
              if (stage.duration > 0)
                Text(
                  '${stage.duration}ms',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PipelineStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (status) {
      PipelineStatus.idle => (Icons.radio_button_unchecked, 'รอดำเนิน', Colors.grey),
      PipelineStatus.running => (Icons.hourglass_bottom, 'ดำเนินการ', Colors.amber),
      PipelineStatus.passed => (Icons.check_circle, 'สำเร็จ', Colors.green),
      PipelineStatus.failed => (Icons.cancel, 'ล้มเหลว', Colors.red),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverageChart extends StatelessWidget {
  final Map<String, double> coverage;

  const _CoverageChart({required this.coverage});

  @override
  Widget build(BuildContext context) {
    final sortedCoverage = coverage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxY = 100.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coverage %',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barGroups: List.generate(
                  sortedCoverage.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: sortedCoverage[index].value,
                        color: _getCoverageColor(sortedCoverage[index].value),
                        width: 16,
                      ),
                    ],
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < sortedCoverage.length) {
                          final fileName = sortedCoverage[index].key;
                          return Text(
                            fileName.split('.').first,
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'โครงการ Coverage เฉลี่ย: ${(coverage.values.reduce((a, b) => a + b) / coverage.length).toStringAsFixed(1)}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCoverageColor(double coverage) {
    if (coverage >= 90) return Colors.green;
    if (coverage >= 75) return Colors.amber;
    return Colors.red;
  }
}
