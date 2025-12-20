import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanrio_characters_app/main.dart';
import 'package:sanrio_characters_app/screens/scan_result_screen.dart';
import 'package:sanrio_characters_app/services/analytics_service.dart';
import 'package:sanrio_characters_app/services/ml_model_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with TickerProviderStateMixin {
  bool isScanning = false;
  bool showingPreview = false;
  late AnimationController _borderController;
  final ImagePicker _imagePicker = ImagePicker();
  late MLModelService _mlModelService;
  File? _selectedImageFile;
  String? _captureSource;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: 'scan_screen');
    _mlModelService = MLModelService();
    _initializeModel();
    _borderController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  Future<void> _initializeModel() async {
    try {
      await _mlModelService.initialize();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading model: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _borderController.dispose();
    _mlModelService.dispose();
    super.dispose();
  }

  Future<void> _captureFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image != null) {
        await _processImage(image, 'camera');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        await _processImage(image, 'gallery');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _processImage(XFile imageFile, String source) async {
    setState(() {
      showingPreview = true;
      _selectedImageFile = File(imageFile.path);
      _captureSource = source;
    });
  }

  Future<void> _startScanning() async {
    if (_selectedImageFile == null || _captureSource == null) return;

    setState(() {
      isScanning = true;
      showingPreview = false;
    });

    AnalyticsService().logScanStarted(scanType: _captureSource!);

    try {
      final imageBytes = await _selectedImageFile!.readAsBytes();
      final result = await _mlModelService.classifyImage(imageBytes);

      if (mounted) {
        setState(() {
          isScanning = false;
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScanResultScreen(
              character: result.character,
              confidence: result.confidence,
              rawPredictions: result.rawPredictions,
              scannedImage: _selectedImageFile!,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isScanning = false;
          _selectedImageFile = null;
          showingPreview = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _retryCapture() {
    setState(() {
      showingPreview = false;
      _selectedImageFile = null;
      _captureSource = null;
    });
  }

  Widget _buildDirectScanButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              color: onTap == null
                  ? AppColors.accentMint.withValues(alpha: 0.4)
                  : AppColors.accentMint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 28,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accentMint,
        title: const Text('Scan Character'),
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
              const SizedBox(height: 20),
              Text(
                'Point the camera at a Sanrio character',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: AnimatedBuilder(
                  animation: _borderController,
                  builder: (context, child) {
                    return Column(
                      children: [
                        Container(
                          width: screen.width * 0.9,
                          height: screen.height * 0.55,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.accentMint.withValues(
                                alpha: showingPreview
                                    ? 1.0
                                    : 0.3 + (0.7 * _borderController.value),
                              ),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.accentMint.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                _selectedImageFile != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.file(
                                          _selectedImageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: isMobile ? 80 : 100,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                if (isScanning)
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.45),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Scanning character...',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (showingPreview) ...[
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: _retryCapture,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.accentMint,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Retry',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 120,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _startScanning,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accentMint,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'OK',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 48),
              if (!showingPreview)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDirectScanButton(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap:
                          isScanning || showingPreview ? null : _captureFromCamera,
                    ),
                    _buildDirectScanButton(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap:
                          isScanning || showingPreview ? null : _pickFromGallery,
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Text(
                'Make sure the character is well-lit and clearly visible',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
