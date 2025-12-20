import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanrio_characters_app/main.dart';
import 'package:sanrio_characters_app/models/achievement.dart';
import 'package:sanrio_characters_app/models/character.dart';
import 'package:sanrio_characters_app/models/scan_history.dart';
import 'package:sanrio_characters_app/screens/character_detail_screen.dart';
import 'package:sanrio_characters_app/screens/scan_screen.dart';
import 'package:sanrio_characters_app/services/analytics_service.dart';

class ScanResultScreen extends StatefulWidget {
  final SanrioCharacter? character;
  final double? confidence;
  final Map<String, dynamic>? rawPredictions;
  final File? scannedImage;

  const ScanResultScreen({
    super.key,
    this.character,
    this.confidence,
    this.rawPredictions,
    this.scannedImage,
  });

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  SanrioCharacter? _selectedCharacter;
  double _confidence = 0;

  SanrioCharacter _getCharacterFromPredictions(
    Map<String, dynamic> predictions,
  ) {
    String topLabel = '';
    double topConfidence = -1;
    
    predictions.forEach((label, confidence) {
      final conf = double.tryParse(confidence.toString()) ?? 0.0;
      if (conf > topConfidence) {
        topConfidence = conf;
        topLabel = label.trim();
      }
    });
    
    final matched = getCharacterByLabel(topLabel);
    return matched ?? characters[0];
  }

  @override
  void initState() {
    super.initState();

    if (widget.character != null) {
      _selectedCharacter = widget.character;
      _confidence = widget.confidence ?? 0.0;
    } else {
      _selectedCharacter = null;
      if (widget.rawPredictions != null && widget.rawPredictions!.isNotEmpty) {
        double maxConfidence = 0.0;
        widget.rawPredictions!.forEach((_, confidenceStr) {
          final conf = double.tryParse(confidenceStr.toString()) ?? 0.0;
          if (conf > maxConfidence) {
            maxConfidence = conf;
          }
        });
        _confidence = (maxConfidence / 100).clamp(0.0, 1.0);
      } else {
        _confidence = widget.confidence ?? 0.0;
      }
    }

    if (_selectedCharacter != null) {
      _saveScanToHistory();

      AnalyticsService().logScanCompleted(
        characterDetected: _selectedCharacter!.name,
        confidenceScore: _confidence,
        scanType: 'camera',
      );
    }

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _saveScanToHistory() async {
    try {
      final historyService = ScanHistoryService();
      await historyService.addScan(
        characterName: _selectedCharacter!.name,
        confidenceScore: _confidence,
        scanType: 'camera',
        characterId: _selectedCharacter!.id,
      );
      final collectionService = CollectionService();
      collectionService.markCharacterCollected(_selectedCharacter!.id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCharacter == null) {
      return _buildUnknownScreen(context);
    }

    final isMobile = MediaQuery.of(context).size.width < 600;
    final isHighConfidence = _confidence >= 0.90;
    final isMediumConfidence = _confidence >= 0.70 && _confidence < 0.90;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accentMint,
        title: const Text('Scan Result'),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.getAppBarTextColor(AppColors.accentMint),
        ),
        iconTheme: IconThemeData(
          color: AppColors.getAppBarIconColor(AppColors.accentMint),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    if (widget.scannedImage != null)
                      Container(
                        width: double.infinity,
                        height: 260,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.file(
                            widget.scannedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: isMobile ? 130 : 170,
                        height: isMobile ? 130 : 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: _selectedCharacter!.color.withValues(alpha: 0.1),
                          border: Border.all(
                            color: _selectedCharacter!.color.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(
                            _selectedCharacter!.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    Text(
                      _selectedCharacter!.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _getConfidenceColor(_confidence)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _getConfidenceColor(_confidence)
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getConfidenceIcon(
                              _confidence,
                            ),
                            size: 18,
                            color: _getConfidenceColor(_confidence),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(_confidence * 100).clamp(0, 100).toStringAsFixed(2)}% Match',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _getConfidenceColor(_confidence),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildConfidenceStatus(
                      isHighConfidence,
                      isMediumConfidence,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedCharacter!.description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              if (widget.rawPredictions != null && widget.rawPredictions!.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Classification Results',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...widget.rawPredictions!.entries
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final characterName = entry.value.key;
                          final confidence = entry.value.value;
                          final isTopMatch = index == 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    characterName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: isTopMatch ? FontWeight.w600 : FontWeight.w500,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isTopMatch
                                        ? AppColors.accentMint.withValues(alpha: 0.2)
                                        : Colors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$confidence%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isTopMatch
                                          ? const Color(0xFF00695C)
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              if (widget.rawPredictions != null) const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ScanScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: AppColors.accentMint,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Scan Again',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CharacterDetailScreen(
                              character: _selectedCharacter!,
                              confidenceScore: _confidence,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Learn More',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnknownScreen(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accentMint,
        title: const Text('Scan Result'),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.getAppBarTextColor(AppColors.accentMint),
        ),
        iconTheme: IconThemeData(
          color: AppColors.getAppBarIconColor(AppColors.accentMint),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 260,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.question_mark_rounded,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Unknown Character',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cannot be detected because it is not a Sanrio character class in this app.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ScanScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                      color: AppColors.accentMint,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Scan Again',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentMint,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfidenceStatus(bool isHigh, bool isMedium) {
    String status;
    Color statusColor;

    if (isHigh) {
      status = '✔️ Perfect Match!';
      statusColor = const Color(0xFF4CAF50);
    } else if (isMedium) {
      status = '⚠️ Possible Match';
      statusColor = const Color(0xFFFFC107);
    } else {
      status = '❌ Low Confidence';
      statusColor = const Color(0xFFF44336);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.90) {
      return const Color(0xFF4CAF50);
    } else if (confidence >= 0.70) {
      return const Color(0xFFFFC107);
    } else {
      return const Color(0xFFF44336);
    }
  }

  IconData _getConfidenceIcon(double confidence) {
    if (confidence >= 0.90) {
      return Icons.check_circle;
    } else if (confidence >= 0.70) {
      return Icons.info;
    } else {
      return Icons.error;
    }
  }
}
