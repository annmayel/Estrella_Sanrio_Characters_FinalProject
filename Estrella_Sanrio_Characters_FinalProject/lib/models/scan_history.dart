import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ScanQuality {
  perfect,
  good,
  poor,
}

class ScanRecord {
  final String characterName;
  final double confidenceScore;
  final String scanType;
  final DateTime scanTime;
  final int characterId;
  final ScanQuality quality;

  const ScanRecord({
    required this.characterName,
    required this.confidenceScore,
    required this.scanType,
    required this.scanTime,
    required this.characterId,
    ScanQuality? quality,
  }) : quality = quality ?? ScanQuality.poor;

  static ScanQuality _calculateQuality(double confidence) {
    if (confidence >= 0.90) return ScanQuality.perfect;
    if (confidence >= 0.70) return ScanQuality.good;
    return ScanQuality.poor;
  }

  Map<String, dynamic> toJson() => {
    'characterName': characterName,
    'confidenceScore': confidenceScore,
    'scanType': scanType,
    'scanTime': scanTime.toIso8601String(),
    'characterId': characterId,
    'quality': quality.toString(),
  };

  factory ScanRecord.fromJson(Map<String, dynamic> json) {
    final confidence = json['confidenceScore'] as double;
    return ScanRecord(
      characterName: json['characterName'] as String,
      confidenceScore: confidence,
      scanType: json['scanType'] as String,
      scanTime: DateTime.parse(json['scanTime'] as String),
      characterId: json['characterId'] as int,
      quality: _calculateQuality(confidence),
    );
  }
}

class ScanHistoryService {
  static final ScanHistoryService _instance = ScanHistoryService._internal();
  final List<ScanRecord> _history = [];
  late SharedPreferences _prefs;
  late FirebaseFirestore _firestore;
  late DatabaseReference _realtimeDb;
  bool _isInitialized = false;

  factory ScanHistoryService() {
    return _instance;
  }

  ScanHistoryService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _firestore = FirebaseFirestore.instance;
    _realtimeDb = FirebaseDatabase.instance.ref();
    await _loadHistory();
    _isInitialized = true;
  }

  Future<void> _loadHistory() async {
    final historyJson = _prefs.getStringList('scan_history') ?? [];
    _history.clear();
    for (final json in historyJson) {
      try {
        _history.add(ScanRecord.fromJson(jsonDecode(json)));
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> _saveHistory() async {
    final historyJson = _history.map((record) => jsonEncode(record.toJson())).toList();
    await _prefs.setStringList('scan_history', historyJson);
  }

  Future<void> addScan({
    required String characterName,
    required double confidenceScore,
    required String scanType,
    required int characterId,
  }) async {
    if (!_isInitialized) await initialize();
    
    final scanRecord = ScanRecord(
      characterName: characterName,
      confidenceScore: confidenceScore,
      scanType: scanType,
      scanTime: DateTime.now(),
      characterId: characterId,
    );

    _history.insert(0, scanRecord);
    await _saveHistory();
    
    try {
      await _uploadToFirebase(scanRecord);
    } catch (e) {
    }
  }

  Future<void> _uploadToFirebase(ScanRecord record) async {
    final accuracy = (record.confidenceScore * 100).toInt();
    final timestamp = record.scanTime;

    await _firestore
        .collection('Estrella-SanrioCharacters')
        .doc('Estrella_SanrioCharacters_Logs')
        .collection('scans')
        .add({
      'CharacterName': record.characterName,
      'Accuracy_Rate': accuracy,
      'ClassType': 'Sanrio_Characters',
      'Time': timestamp,
      'ScanType': record.scanType,
      'ConfidenceScore': record.confidenceScore,
    });

    await _realtimeDb.child('Sanrio-Scans').push().set({
      'character': record.characterName,
      'accuracy': accuracy,
      'type': record.scanType,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'confidence': record.confidenceScore,
    });
  }

  List<ScanRecord> getHistory() => List.unmodifiable(_history);

  List<ScanRecord> getRecentScans({int limit = 10}) {
    return _history.take(limit).toList();
  }

  List<String> getUniqueCharactersScanned() {
    final Set<String> unique = {};
    for (var record in _history) {
      unique.add(record.characterName);
    }
    return unique.toList();
  }

  int getTotalScansCount() => _history.length;

  int getCharacterScanCount(String characterName) {
    return _history.where((r) => r.characterName == characterName).length;
  }

  Map<String, double> getAverageConfidenceByCharacter() {
    final Map<String, List<double>> grouped = {};
    
    for (var record in _history) {
      if (!grouped.containsKey(record.characterName)) {
        grouped[record.characterName] = [];
      }
      grouped[record.characterName]!.add(record.confidenceScore);
    }

    final Map<String, double> averages = {};
    grouped.forEach((name, scores) {
      final avg = scores.reduce((a, b) => a + b) / scores.length;
      averages[name] = avg;
    });

    return averages;
  }

  List<MapEntry<String, int>> getScanCountByCharacter() {
    final Map<String, int> counts = {};
    for (var record in _history) {
      counts[record.characterName] = (counts[record.characterName] ?? 0) + 1;
    }
    final entries = counts.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  List<ScanRecord> getHistoryInChronologicalOrder() {
    final sorted = List<ScanRecord>.from(_history);
    sorted.sort((a, b) => a.scanTime.compareTo(b.scanTime));
    return sorted;
  }

  String getMostScannedCharacter() {
    if (_history.isEmpty) return 'N/A';
    final counts = getScanCountByCharacter();
    return counts.isNotEmpty ? counts.first.key : 'N/A';
  }

  String getMostAccurateCharacter() {
    final averages = getAverageConfidenceByCharacter();
    if (averages.isEmpty) return 'N/A';
    
    var maxEntry = averages.entries.first;
    for (var entry in averages.entries) {
      if (entry.value > maxEntry.value) {
        maxEntry = entry;
      }
    }
    return maxEntry.key;
  }

  double getMostAccurateScore() {
    final averages = getAverageConfidenceByCharacter();
    if (averages.isEmpty) return 0.0;
    
    var maxScore = averages.values.first;
    for (var score in averages.values) {
      if (score > maxScore) {
        maxScore = score;
      }
    }
    return maxScore;
  }

  Map<String, int> getScanTypeCount() {
    final counts = {'camera': 0, 'gallery': 0};
    for (var record in _history) {
      if (record.scanType.toLowerCase() == 'camera') {
        counts['camera'] = (counts['camera'] ?? 0) + 1;
      } else if (record.scanType.toLowerCase() == 'gallery') {
        counts['gallery'] = (counts['gallery'] ?? 0) + 1;
      }
    }
    return counts;
  }

  Map<String, List<ScanRecord>> getCharacterTimeSeries() {
    final series = <String, List<ScanRecord>>{};
    final chronological = getHistoryInChronologicalOrder();
    
    for (var record in chronological) {
      if (!series.containsKey(record.characterName)) {
        series[record.characterName] = [];
      }
      series[record.characterName]!.add(record);
    }
    
    return series;
  }

  double getOverallConfidence() {
    if (_history.isEmpty) return 0.0;
    final total = _history.map((s) => s.confidenceScore).reduce((a, b) => a + b);
    return total / _history.length;
  }

  Map<ScanQuality, int> getQualityDistribution() {
    final distribution = {
      ScanQuality.perfect: 0,
      ScanQuality.good: 0,
      ScanQuality.poor: 0,
    };
    
    for (var record in _history) {
      distribution[record.quality] = (distribution[record.quality] ?? 0) + 1;
    }
    
    return distribution;
  }

  String getConfidenceLevel(double confidence) {
    if (confidence >= 0.90) return 'High';
    if (confidence >= 0.70) return 'Medium';
    return 'Low';
  }

  Future<void> clearHistory() async {
    _history.clear();
    await _prefs.remove('scan_history');
  }
}
