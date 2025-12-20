import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsEvent {
  final String eventName;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.eventName,
    required this.parameters,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  final List<AnalyticsEvent> _events = [];
  late FirebaseAnalytics _firebaseAnalytics;

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal() {
    _firebaseAnalytics = FirebaseAnalytics.instance;
  }

  void logScreenView({required String screenName}) {
    _firebaseAnalytics.logScreenView(screenName: screenName);
  }

  void logScanStarted({required String scanType}) {
    final event = AnalyticsEvent(
      eventName: 'scan_started',
      parameters: {
        'scan_type': scanType,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    _events.add(event);
    _firebaseAnalytics.logEvent(
      name: 'scan_started',
      parameters: {
        'scan_type': scanType,
      },
    );
  }

  void logScanCompleted({
    required String characterDetected,
    required double confidenceScore,
    required String scanType,
  }) {
    final event = AnalyticsEvent(
      eventName: 'scan_completed',
      parameters: {
        'character_detected': characterDetected,
        'confidence_score': confidenceScore,
        'scan_type': scanType,
        'is_successful': true,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    _events.add(event);
    _firebaseAnalytics.logEvent(
      name: 'scan_completed',
      parameters: {
        'character_detected': characterDetected,
        'confidence_score': confidenceScore,
        'scan_type': scanType,
      },
    );
  }

  void logScanFailed({required String reason}) {
    final event = AnalyticsEvent(
      eventName: 'scan_failed',
      parameters: {
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    _events.add(event);
    _firebaseAnalytics.logEvent(
      name: 'scan_failed',
      parameters: {
        'reason': reason,
      },
    );
  }

  void logCharacterViewed({required String characterName}) {
    final event = AnalyticsEvent(
      eventName: 'character_viewed',
      parameters: {
        'character_name': characterName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    _events.add(event);
    _firebaseAnalytics.logEvent(
      name: 'character_viewed',
      parameters: {
        'character_name': characterName,
      },
    );
  }

  void logAchievementUnlocked({required String achievementName}) {
    final event = AnalyticsEvent(
      eventName: 'achievement_unlocked',
      parameters: {
        'achievement_name': achievementName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    _events.add(event);
    _firebaseAnalytics.logEvent(
      name: 'achievement_unlocked',
      parameters: {
        'achievement_name': achievementName,
      },
    );
  }

  void logCollectionAccessed() {
    _firebaseAnalytics.logEvent(
      name: 'collection_accessed',
    );
  }

  void logHistoryAccessed() {
    _firebaseAnalytics.logEvent(
      name: 'history_accessed',
    );
  }

  List<AnalyticsEvent> getAllEvents() => List.unmodifiable(_events);

  Map<String, dynamic> getAnalyticsSummary() {
    int totalScans = _events
        .where((e) => e.eventName == 'scan_completed' || e.eventName == 'scan_failed')
        .length;

    int successfulScans =
        _events.where((e) => e.eventName == 'scan_completed').length;

    int failedScans = _events.where((e) => e.eventName == 'scan_failed').length;

    final scansByType = <String, int>{};
    for (var event in _events) {
      if (event.eventName == 'scan_completed') {
        final scanType = event.parameters['scan_type'] as String?;
        if (scanType != null) {
          scansByType[scanType] = (scansByType[scanType] ?? 0) + 1;
        }
      }
    }

    final characterScans = <String, int>{};
    for (var event in _events) {
      if (event.eventName == 'scan_completed') {
        final character = event.parameters['character_detected'] as String?;
        if (character != null) {
          characterScans[character] = (characterScans[character] ?? 0) + 1;
        }
      }
    }

    double avgConfidence = 0;
    final confidenceScores = _events
        .where((e) => e.eventName == 'scan_completed')
        .map((e) => e.parameters['confidence_score'] as double)
        .toList();

    if (confidenceScores.isNotEmpty) {
      avgConfidence = confidenceScores.reduce((a, b) => a + b) / confidenceScores.length;
    }

    return {
      'total_scans': totalScans,
      'successful_scans': successfulScans,
      'failed_scans': failedScans,
      'success_rate': totalScans > 0 ? (successfulScans / totalScans * 100).toStringAsFixed(1) : '0',
      'scans_by_type': scansByType,
      'character_scan_frequency': characterScans,
      'average_confidence': avgConfidence.toStringAsFixed(2),
    };
  }

  void clearEvents() {
    _events.clear();
  }
}
