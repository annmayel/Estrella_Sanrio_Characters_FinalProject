import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:sanrio_characters_app/models/character.dart';

class MLModelService {
  static final MLModelService _instance = MLModelService._internal();
  late tfl.Interpreter _interpreter;
  late List<String> _labels;
  bool _isInitialized = false;

  factory MLModelService() {
    return _instance;
  }

  MLModelService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _interpreter = await tfl.Interpreter.fromAsset('assets/model_unquant.tflite');
      await _loadLabels();
      _isInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelData
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) {
        final parts = line.split(' ');
        return parts.skip(1).join(' ');
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  static const double confidenceThreshold = 0.8;

  Future<ScanResult> classifyImage(List<int> imageBytes) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final image = img.decodeImage(Uint8List.fromList(imageBytes));
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      final resizedImage = img.copyResize(image, width: 224, height: 224);
      final inputData = _preprocessImage(resizedImage);
      final outputData = List<List<double>>.filled(1, List<double>.filled(_labels.length, 0));
      _interpreter.run(inputData, outputData);

      final predictions = outputData[0];
      
      int maxIndex = 0;
      double maxConfidence = predictions[0];

      for (int i = 1; i < predictions.length; i++) {
        if (predictions[i] > maxConfidence) {
          maxConfidence = predictions[i];
          maxIndex = i;
        }
      }

      // Debug print to check predictions
      print('Predictions: $predictions');
      print('Max Confidence: $maxConfidence');

      if (maxConfidence < confidenceThreshold) {
        return ScanResult(
          character: null,
          confidence: (maxConfidence * 100).clamp(0.0, 100.0),
          rawPredictions: Map.fromEntries(
            _labels.asMap().entries.map(
              (entry) => MapEntry(entry.value, (predictions[entry.key] * 100).toStringAsFixed(2)),
            ),
          ),
        );
      }

      final detectedCharacterName = _labels[maxIndex];
      final detectedCharacter = getCharacterByLabel(detectedCharacterName) ??
          characters.firstWhere(
            (char) => char.name.toLowerCase() == detectedCharacterName.toLowerCase(),
            orElse: () => characters[maxIndex % characters.length],
          );

      final confidence = (maxConfidence * 100).clamp(0.0, 100.0);

      return ScanResult(
        character: detectedCharacter,
        confidence: confidence,
        rawPredictions: Map.fromEntries(
          _labels.asMap().entries.map(
            (entry) => MapEntry(entry.value, (predictions[entry.key] * 100).toStringAsFixed(2)),
          ),
        ),
      );
    } catch (e) {
      throw Exception('Classification failed: $e');
    }
  }

  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    final List<List<List<List<double>>>> input = List.generate(
      1,
      (i) => List.generate(
        224,
        (j) => List.generate(
          224,
          (k) => List.filled(3, 0.0),
        ),
      ),
    );

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = image.getPixelSafe(x, y);
        // Normalize to -1 to 1 for better accuracy with Teachable Machine models
        input[0][y][x][0] = (pixel.r.toInt() - 127.5) / 127.5;
        input[0][y][x][1] = (pixel.g.toInt() - 127.5) / 127.5;
        input[0][y][x][2] = (pixel.b.toInt() - 127.5) / 127.5;
      }
    }

    return input;
  }

  void dispose() {
    if (_isInitialized) {
      _interpreter.close();
      _isInitialized = false;
    }
  }
}

class ScanResult {
  final SanrioCharacter? character;
  final double confidence;
  final Map<String, dynamic> rawPredictions;

  ScanResult({
    this.character,
    required this.confidence,
    required this.rawPredictions,
  });
}
