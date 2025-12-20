class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedDate;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedDate,
  });

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedDate,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
    );
  }
}

class CollectionService {
  static final CollectionService _instance = CollectionService._internal();
  final Map<int, bool> _collectedCharacters = {};
  final List<Achievement> _achievements = [];

  factory CollectionService() {
    return _instance;
  }

  CollectionService._internal() {
    _initializeAchievements();
  }

  void _initializeAchievements() {
    _achievements.addAll([
      Achievement(
        id: 'first_scan',
        name: 'First Scan',
        description: 'Scan your first Sanrio character',
        icon: '📸',
      ),
      Achievement(
        id: 'collector_5',
        name: 'Collector',
        description: 'Collect 5 different characters',
        icon: '🎨',
      ),
      Achievement(
        id: 'collector_10',
        name: 'Super Collector',
        description: 'Collect all 10 characters',
        icon: '🌟',
      ),
      Achievement(
        id: 'perfect_accuracy',
        name: 'Perfect Eye',
        description: 'Get 10 consecutive perfect scans (90%+ accuracy)',
        icon: '👁️',
      ),
      Achievement(
        id: 'speed_scanner',
        name: 'Speed Scanner',
        description: 'Complete 20 scans',
        icon: '⚡',
      ),
      Achievement(
        id: 'accuracy_master',
        name: 'Accuracy Master',
        description: 'Achieve 95% average accuracy',
        icon: '🎯',
      ),
    ]);
  }

  void markCharacterCollected(int characterId) {
    _collectedCharacters[characterId] = true;

    if (_collectedCharacters.length == 1) {
      _unlockAchievement('first_scan');
    }

    if (_collectedCharacters.length >= 5) {
      _unlockAchievement('collector_5');
    }

    if (_collectedCharacters.length >= 10) {
      _unlockAchievement('collector_10');
    }
  }

  void _unlockAchievement(String achievementId) {
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index != -1 && !_achievements[index].isUnlocked) {
      _achievements[index] = _achievements[index].copyWith(
        isUnlocked: true,
        unlockedDate: DateTime.now(),
      );
    }
  }

  List<int> getCollectedCharacterIds() {
    return _collectedCharacters.keys.toList();
  }

  int getCollectionProgress() => _collectedCharacters.length;

  bool isCharacterCollected(int characterId) {
    return _collectedCharacters[characterId] ?? false;
  }

  List<Achievement> getAllAchievements() {
    return List.unmodifiable(_achievements);
  }

  List<Achievement> getUnlockedAchievements() {
    return _achievements.where((a) => a.isUnlocked).toList();
  }

  int getUnlockedAchievementCount() {
    return _achievements.where((a) => a.isUnlocked).length;
  }

  void clearCollection() {
    _collectedCharacters.clear();
  }
}
