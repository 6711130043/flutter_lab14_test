import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pipeline_stage.dart';

/// Pipeline provider for CI/CD demonstration
class PipelineNotifier extends StateNotifier<List<PipelineStage>> {
  PipelineNotifier()
      : super([
          PipelineStage(
            name: 'Code Push',
            thaiName: 'ส่งโค้ด',
            status: PipelineStatus.idle,
            duration: 0,
            index: 0,
          ),
          PipelineStage(
            name: 'Lint Check',
            thaiName: 'ตรวจสอบ Lint',
            status: PipelineStatus.idle,
            duration: 0,
            index: 1,
          ),
          PipelineStage(
            name: 'Unit Tests',
            thaiName: 'Unit Tests',
            status: PipelineStatus.idle,
            duration: 0,
            index: 2,
          ),
          PipelineStage(
            name: 'Widget Tests',
            thaiName: 'Widget Tests',
            status: PipelineStatus.idle,
            duration: 0,
            index: 3,
          ),
          PipelineStage(
            name: 'Integration Tests',
            thaiName: 'Integration Tests',
            status: PipelineStatus.idle,
            duration: 0,
            index: 4,
          ),
          PipelineStage(
            name: 'Build',
            thaiName: 'สร้าง Build',
            status: PipelineStatus.idle,
            duration: 0,
            index: 5,
          ),
          PipelineStage(
            name: 'Deploy',
            thaiName: 'ปล่อยสู่ Live',
            status: PipelineStatus.idle,
            duration: 0,
            index: 6,
          ),
        ]);

  /// Run the pipeline with all stages
  Future<void> runPipeline() async {
    // Reset all stages
    state = state.map((s) => s.copyWith(status: PipelineStatus.idle, duration: 0)).toList();

    // Run each stage sequentially
    for (int i = 0; i < state.length; i++) {
      await _runStage(i);
      if (i < state.length - 1) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  /// Run a specific stage
  Future<void> _runStage(int index) async {
    if (index < 0 || index >= state.length) return;

    // Mark as running
    _updateStage(index, PipelineStatus.running, 0);
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate stage execution
    final stopwatch = Stopwatch()..start();

    // Random chance of failure for demo purposes (10% failure rate)
    final shouldFail = index > 0 && index % 7 == 0;

    await Future.delayed(Duration(milliseconds: 800 + (index * 200)));

    stopwatch.stop();

    // Mark as passed or failed
    final status = shouldFail ? PipelineStatus.failed : PipelineStatus.passed;
    final error = shouldFail ? 'ทดสอบล้มเหลว' : null;

    _updateStage(index, status, stopwatch.elapsedMilliseconds, error: error);

    // Stop pipeline on failure
    if (shouldFail) {
      return;
    }
  }

  /// Update a single stage
  void _updateStage(
    int index,
    PipelineStatus status,
    int duration, {
    String? error,
  }) {
    if (index < 0 || index >= state.length) return;

    final stage = state[index];
    state = [
      ...state.sublist(0, index),
      stage.copyWith(
        status: status,
        duration: duration,
        error: error,
      ),
      ...state.sublist(index + 1),
    ];
  }

  /// Reset pipeline
  void resetPipeline() {
    state = state.map((s) => s.copyWith(status: PipelineStatus.idle, duration: 0)).toList();
  }
}

/// Pipeline provider
final pipelineProvider =
    StateNotifierProvider<PipelineNotifier, List<PipelineStage>>((ref) {
  return PipelineNotifier();
});

/// Coverage data provider (static for demo)
final coverageProvider = Provider((ref) {
  return {
    'calculator.dart': 95.0,
    'api_service.dart': 80.0,
    'counter_widget.dart': 90.0,
    'home_screen.dart': 75.0,
    'test_runner_provider.dart': 88.0,
    'pipeline_provider.dart': 92.0,
  };
});
