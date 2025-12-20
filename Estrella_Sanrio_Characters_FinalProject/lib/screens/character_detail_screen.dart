import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanrio_characters_app/main.dart';
import 'package:sanrio_characters_app/models/achievement.dart';
import 'package:sanrio_characters_app/models/character.dart';
import 'package:sanrio_characters_app/screens/scan_screen.dart';
import 'package:sanrio_characters_app/services/analytics_service.dart';
import 'package:sanrio_characters_app/widgets/scan_button.dart';

class CharacterDetailScreen extends StatefulWidget {
  final SanrioCharacter character;
  final double? confidenceScore;

  const CharacterDetailScreen({
    super.key,
    required this.character,
    this.confidenceScore,
  });

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  late CollectionService _collectionService;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logCharacterViewed(characterName: widget.character.name);
    _collectionService = CollectionService();
  }

  void _markAsCollected() {
    _collectionService.markCharacterCollected(widget.character.id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.character.name} added to collection!'),
        backgroundColor: widget.character.color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final confidenceScore = widget.confidenceScore;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isCollected = _collectionService.isCharacterCollected(character.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: character.color,
        title: Text(character.name),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.getAppBarTextColor(character.color),
        ),
        iconTheme: IconThemeData(color: AppColors.getAppBarIconColor(character.color)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: isMobile ? 280 : 350,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    character.color.withValues(alpha: 0.15),
                    character.color.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: character.color.withValues(alpha: 0.1),
                    border: Border.all(
                      color: character.color.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(21),
                    child: Image.asset(
                      character.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 28 : 34,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (confidenceScore != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: character.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Color(0xFFFFB800),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${(confidenceScore * 100).toStringAsFixed(2)}% Match',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: character.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: character.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: character.color.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: character.color.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.info_outline,
                                size: 20,
                                color: character.color,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'About',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          character.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (character.exampleImagePaths.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Character Gallery',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.textDark,
                          ),
                        ),
                        ScanButton(
                          compact: true,
                          onTap: () {
                            AnalyticsService().logScanStarted(scanType: 'gallery_classify');
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ScanScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: isMobile ? 280 : 350,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: character.exampleImagePaths.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: isMobile ? 280 : 350,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  character.color.withValues(alpha: 0.15),
                                  character.color.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: character.color.withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: character.color.withValues(alpha: 0.3),
                                    width: 3,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(21),
                                  child: Image.asset(
                                    character.exampleImagePaths[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isCollected ? null : _markAsCollected,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCollected
                            ? AppColors.textMuted
                            : const Color(0xFF2E5090),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        disabledBackgroundColor: AppColors.textMuted,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCollected ? Icons.check_circle : Icons.add_circle,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isCollected
                                ? 'Already Collected'
                                : 'Add to Collection',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
