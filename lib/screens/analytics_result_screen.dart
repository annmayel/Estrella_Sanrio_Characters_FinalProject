import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanrio_characters_app/main.dart';

class AnalyticsResultScreen extends StatefulWidget {
  final Map<String, dynamic> allPredictions;
  final String detectedCharacter;
  final double confidence;

  const AnalyticsResultScreen({
    super.key,
    required this.allPredictions,
    required this.detectedCharacter,
    required this.confidence,
  });

  @override
  State<AnalyticsResultScreen> createState() => _AnalyticsResultScreenState();
}

class _AnalyticsResultScreenState extends State<AnalyticsResultScreen> {
  late List<_PredictionItem> sortedPredictions;

  @override
  void initState() {
    super.initState();
    _processPredictions();
  }

  void _processPredictions() {
    final items = <_PredictionItem>[];
    
    widget.allPredictions.forEach((name, confidenceStr) {
      double confidence = 0.0;
      try {
        final parsed = double.tryParse(confidenceStr.toString());
        confidence = (parsed ?? 0.0) / 100;
      } catch (e) {
        confidence = 0.0;
      }
      items.add(_PredictionItem(
        name: name,
        confidence: confidence,
      ));
    });

    sortedPredictions = items..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accentMint,
        title: const Text('Scan Analytics'),
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
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetectionSummary(isMobile),
              const SizedBox(height: 32),
              _buildAccuracyChart(),
              const SizedBox(height: 32),
              _buildDetailedBreakdown(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentMint,
                  ),
                  child: Text(
                    'Back to Home',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
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

  Widget _buildDetectionSummary(bool isMobile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Detection Summary',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: isMobile ? 100 : 140,
              height: isMobile ? 100 : 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentMint.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  '${(widget.confidence * 100).toStringAsFixed(2)}%',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentMint,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.detectedCharacter,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Detected with high confidence',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccuracyChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accuracy by Character',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 20),
            ...sortedPredictions.take(5).map((item) {
              final isTopMatch = item.name == widget.detectedCharacter;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: isTopMatch ? FontWeight.w700 : FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getAccuracyColor(item.confidence).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${(item.confidence * 100).clamp(0, 100).toStringAsFixed(1)}%',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _getAccuracyColor(item.confidence),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: item.confidence / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getAccuracyColor(item.confidence),
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
    );
  }

  Widget _buildDetailedBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete Breakdown',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 20),
            ...sortedPredictions.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${(item.confidence * 100).toStringAsFixed(2)}%',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getAccuracyColor(item.confidence),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.90) {
      return const Color(0xFF4CAF50);
    } else if (accuracy >= 0.80) {
      return const Color(0xFF8BC34A);
    } else if (accuracy >= 0.70) {
      return const Color(0xFFFFC107);
    } else {
      return const Color(0xFFFF9800);
    }
  }
}

class _PredictionItem {
  final String name;
  final double confidence;

  _PredictionItem({
    required this.name,
    required this.confidence,
  });
}
