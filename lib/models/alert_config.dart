/// Configuration for a real-time vehicle alert.
class AlertConfig {
  final String parameterKey;
  final double threshold;
  final AlertCondition condition;
  final bool enabled;

  const AlertConfig({
    required this.parameterKey,
    required this.threshold,
    required this.condition,
    this.enabled = true,
  });

  AlertConfig copyWith({double? threshold, bool? enabled}) {
    return AlertConfig(
      parameterKey: parameterKey,
      threshold: threshold ?? this.threshold,
      condition: condition,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'parameterKey': parameterKey,
    'threshold': threshold,
    'condition': condition.name,
    'enabled': enabled,
  };

  factory AlertConfig.fromJson(Map<String, dynamic> json) {
    return AlertConfig(
      parameterKey: json['parameterKey'] as String,
      threshold: (json['threshold'] as num).toDouble(),
      condition: AlertCondition.values.byName(json['condition'] as String),
      enabled: json['enabled'] as bool? ?? true,
    );
  }
}

enum AlertCondition { above, below }

/// A triggered alert instance.
class ActiveAlert {
  final AlertConfig config;
  final double currentValue;
  final DateTime triggeredAt;

  const ActiveAlert({
    required this.config,
    required this.currentValue,
    required this.triggeredAt,
  });
}
