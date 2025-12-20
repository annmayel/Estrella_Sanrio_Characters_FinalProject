import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanrio_characters_app/main.dart';
import 'package:sanrio_characters_app/models/character.dart';
import 'package:sanrio_characters_app/models/scan_history.dart';
import 'package:sanrio_characters_app/services/analytics_service.dart';
import 'package:fl_chart/fl_chart.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  late ScanHistoryService _historyService;
  late Future<void> _loadFuture;
  List<ScanRecord>? _deletedHistory;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logHistoryAccessed();
    _historyService = ScanHistoryService();
    _loadFuture = _historyService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.accentMint,
              title: const Text('Scan History'),
              titleTextStyle: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.getAppBarTextColor(AppColors.accentMint),
              ),
              iconTheme: IconThemeData(
                color: AppColors.getAppBarIconColor(AppColors.accentMint),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final history = _historyService.getHistory();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.accentMint,
            title: const Text('Scan History & Analytics'),
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.getAppBarTextColor(AppColors.accentMint),
            ),
            iconTheme: IconThemeData(
              color: AppColors.getAppBarIconColor(AppColors.accentMint),
            ),
            actions: history.isNotEmpty
                ? [
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'delete') {
                          _showDeleteConfirmationDialog(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete, color: Colors.red),
                              const SizedBox(width: 10),
                              Text(
                                'Clear History',
                                style: GoogleFonts.poppins(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]
                : null,
          ),
          body: history.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.history,
                          size: 64,
                          color: AppColors.accentMint,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No scan history yet',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start scanning to build your history',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scan Overview',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Summary of all scan activities and recognition history.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: _buildBarChart(history),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: _buildLineChart(history),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(
                              'Scan History',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final groupedByCharacter = _groupScansByCharacter(history);
                          final characterNames = groupedByCharacter.keys.toList();
                          
                          if (index < characterNames.length) {
                            final characterName = characterNames[index];
                            final scans = groupedByCharacter[characterName] ?? [];
                            final character = _getCharacterByName(characterName);
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 8),
                                    child: Row(
                                      children: [
                                        if (character != null)
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: character.color
                                                  .withValues(alpha: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '🔍',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                characterName,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(
                                                      0xFF111827),
                                                ),
                                              ),
                                              Text(
                                                '${scans.length} scan${scans.length != 1 ? 's' : ''}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: const Color(
                                                      0xFF6B7280),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...scans.map((record) => Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: character?.color
                                                      .withValues(alpha: 0.2) ??
                                                  AppColors.accentMint
                                                      .withValues(alpha: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              record.scanType == 'camera'
                                                  ? Icons.photo_camera
                                                  : Icons.image,
                                              size: 20,
                                              color: character?.color ??
                                                  AppColors.accentMint,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: _getConfidenceColor(
                                                                record
                                                                    .confidenceScore)
                                                            .withValues(
                                                                alpha: 0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Text(
                                                        '${(record.confidenceScore * 100).toStringAsFixed(2)}%',
                                                        style: GoogleFonts
                                                            .poppins(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              _getConfidenceColor(
                                                                record
                                                                    .confidenceScore,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Chip(
                                                      label: Text(
                                                        record.scanType == 'camera'
                                                            ? 'CAMERA'
                                                            : 'GALLERY',
                                                        style: GoogleFonts
                                                            .poppins(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      visualDensity:
                                                          VisualDensity
                                                              .compact,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _formatTime(
                                                      record.scanTime),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    color: const Color(
                                                        0xFF9CA3AF),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        childCount: _groupScansByCharacter(history).length,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
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

  SanrioCharacter? _getCharacterByName(String name) {
    try {
      return characters.firstWhere(
        (char) => char.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, List<ScanRecord>> _groupScansByCharacter(
      List<ScanRecord> history) {
    final Map<String, List<ScanRecord>> grouped = {};
    
    for (var record in history) {
      if (!grouped.containsKey(record.characterName)) {
        grouped[record.characterName] = [];
      }
      grouped[record.characterName]!.add(record);
    }
    
    final Map<String, List<ScanRecord>> sorted = {};
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => (grouped[b]?.length ?? 0)
          .compareTo(grouped[a]?.length ?? 0));
    
    for (var key in sortedKeys) {
      sorted[key] = grouped[key]!;
    }
    
    return sorted;
  }

  Future<void> _clearHistory() async {
    _deletedHistory = _historyService.getHistory();
    await _historyService.clearHistory();
    if (mounted) {
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_deletedHistory!.length} scans cleared'),
          backgroundColor: const Color(0xFFF44336),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () => _restoreHistory(),
          ),
        ),
      );
    }
  }

  Future<void> _restoreHistory() async {
    if (_deletedHistory != null) {
      for (var record in _deletedHistory!) {
        await _historyService.addScan(
          characterName: record.characterName,
          confidenceScore: record.confidenceScore,
          scanType: record.scanType,
          characterId: record.characterId,
        );
      }
      _deletedHistory = null;
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('History restored'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear History?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'This will delete all ${_historyService.getHistory().length} scan records. You can undo this action.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: AppColors.textDark),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearHistory();
              },
              child: Text(
                'Delete All',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBarChart(List<ScanRecord> history) {
    final scanCounts = _historyService.getScanCountByCharacter();
    final averageConfidence = _historyService.getAverageConfidenceByCharacter();

    if (scanCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < scanCounts.length; i++) {
      final entry = scanCounts[i];
      final character = _getCharacterByName(entry.key);

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: entry.value.toDouble(),
              color: character?.color ?? AppColors.accentMint,
              width: 16,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan Frequency by Character',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Number of scans per character',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 1,
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < scanCounts.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                width: 60,
                                child: Text(
                                  scanCounts[index].key,
                                  style: GoogleFonts.poppins(fontSize: 9),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: GoogleFonts.poppins(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ..._buildCharacterAccuracyList(scanCounts, averageConfidence),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCharacterAccuracyList(
    List<MapEntry<String, int>> scanCounts,
    Map<String, double> averageConfidence,
  ) {
    final widgets = <Widget>[
      Text(
        'Accuracy by Character',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      const SizedBox(height: 8),
    ];

    for (final entry in scanCounts) {
      final character = _getCharacterByName(entry.key);
      final avgConf = averageConfidence[entry.key] ?? 0.0;
      final accuracy = (avgConf * 100).toStringAsFixed(2);

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: character?.color ?? AppColors.accentMint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.key,
                  style: GoogleFonts.poppins(fontSize: 11),
                ),
              ),
              Text(
                '$accuracy%',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildLineChart(List<ScanRecord> history) {
    final chronologicalHistory =
        _historyService.getHistoryInChronologicalOrder();

    if (chronologicalHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    final lineSpots = <FlSpot>[];
    for (int i = 0; i < chronologicalHistory.length; i++) {
      final record = chronologicalHistory[i];
      final yValue = (record.confidenceScore * 100).clamp(0.0, 100.0);
      lineSpots.add(FlSpot(i.toDouble(), yValue));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model Confidence Over Time',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Confidence scores across scan history',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 &&
                              index < chronologicalHistory.length &&
                              index % 5 == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '#${index + 1}',
                                style: GoogleFonts.poppins(fontSize: 9),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: GoogleFonts.poppins(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: lineSpots,
                      isCurved: true,
                      curveSmoothness: 0.4,
                      color: AppColors.accentMint,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          if (index < chronologicalHistory.length) {
                            final record = chronologicalHistory[index];
                            final character =
                                _getCharacterByName(record.characterName);
                            return FlDotCirclePainter(
                              radius: 4,
                              color: character?.color ?? AppColors.accentMint,
                              strokeWidth: 0,
                            );
                          }
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.accentMint,
                            strokeWidth: 0,
                          );
                        },
                      ),
                    ),
                  ],
                  minY: 0.0,
                  maxY: 100.0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Scan Count: ${chronologicalHistory.length}',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
