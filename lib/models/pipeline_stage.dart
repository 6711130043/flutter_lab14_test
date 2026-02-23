enum PipelineStatus { idle, running, passed, failed }

class PipelineStage {
  final String name;
  final String thaiName;
  final PipelineStatus status;
  final int duration;
  final String? error;
  final int index;

  PipelineStage({
    required this.name,
    required this.thaiName,
    required this.status,
    required this.duration,
    this.error,
    required this.index,
  });

  PipelineStage copyWith({
    String? name,
    String? thaiName,
    PipelineStatus? status,
    int? duration,
    String? error,
    int? index,
  }) {
    return PipelineStage(
      name: name ?? this.name,
      thaiName: thaiName ?? this.thaiName,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      error: error ?? this.error,
      index: index ?? this.index,
    );
  }
}
