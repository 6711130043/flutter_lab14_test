class TestResult {
  final String name;
  final bool passed;
  final int duration;
  final String? error;
  final String description;

  TestResult({
    required this.name,
    required this.passed,
    required this.duration,
    this.error,
    required this.description,
  });

  TestResult copyWith({
    String? name,
    bool? passed,
    int? duration,
    String? error,
    String? description,
  }) {
    return TestResult(
      name: name ?? this.name,
      passed: passed ?? this.passed,
      duration: duration ?? this.duration,
      error: error ?? this.error,
      description: description ?? this.description,
    );
  }
}
