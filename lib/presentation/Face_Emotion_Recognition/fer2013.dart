import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mental_health/resources/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

class _FaceEmotionDetector extends State<FaceEmotionDetector> with SingleTickerProviderStateMixin {
  File? _image;
  List<Face> _faces = [];
  final ImagePicker _picker = ImagePicker();
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableLandmarks: true,
        enableTracking: true),
  );

  double _imageWidth = 0;
  double _imageHeight = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isProcessing = true;
      });

      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final file = File(pickedFile.path);

        final decodedImage = await decodeImageFromList(file.readAsBytesSync());
        _imageWidth = decodedImage.width.toDouble();
        _imageHeight = decodedImage.height.toDouble();

        setState(() {
          _image = file;
          _faces = [];
        });

        _animationController.reset();
        _animationController.forward();
        _detectEmotion();
      } else {
        _showSnackBar("No image selected", isError: false);
      }
    } catch (e) {
      _showSnackBar("Error accessing ${source == ImageSource.camera ? 'camera' : 'gallery'}: $e", isError: true);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent.withOpacity(0.9) : Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _detectEmotion() async {
    if (_image == null) {
      print("No image selected for detection");
      return;
    }
    print("Processing image: ${_image!.path}");
    final inputImage = InputImage.fromFile(_image!);

    try {
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      print("Detected ${faces.length} face(s)");

      if (faces.isNotEmpty) {
        for (int i = 0; i < faces.length; i++) {
          print("Face $i: smilingProbability=${faces[i].smilingProbability}, "
              "leftEyeOpen=${faces[i].leftEyeOpenProbability}, "
              "rightEyeOpen=${faces[i].rightEyeOpenProbability}");
        }
        setState(() {
          _faces = faces;
        });
      } else {
        print("No faces detected");
        setState(() {
          _faces = [];
        });
        _showSnackBar("No faces detected in the image", isError: false);
      }
    } catch (e) {
      print("Error in face detection: $e");
      _showSnackBar("Error detecting faces: $e", isError: true);
    }
  }

  @override
  void dispose() {
    _faceDetector.close();
    _animationController.dispose();
    super.dispose();
  }

  String _classifyEmotion(Face face) {
    final double? smileProb = face.smilingProbability;
    final double? leftEyeOpenProb = face.leftEyeOpenProbability;
    final double? rightEyeOpenProb = face.rightEyeOpenProbability;

    print("Classifying emotion: smileProb=$smileProb, "
        "leftEyeOpen=$leftEyeOpenProb, rightEyeOpen=$rightEyeOpenProb");

    if (smileProb != null && smileProb > 0.6) {
      return 'Happy';
    } else if (smileProb != null && smileProb < 0.3) {
      return 'Sad';
    } else if (leftEyeOpenProb != null &&
        rightEyeOpenProb != null &&
        leftEyeOpenProb < 0.3 &&
        rightEyeOpenProb < 0.3) {
      return 'Eyes Closed';
    } else if (smileProb != null &&
        smileProb > 0.4 &&
        leftEyeOpenProb != null &&
        rightEyeOpenProb != null &&
        leftEyeOpenProb > 0.6 &&
        rightEyeOpenProb > 0.6) {
      return 'Surprised';
    } else {
      return 'Neutral';
    }
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Colors.amber;
      case 'Sad':
        return Colors.blueAccent;
      case 'Eyes Closed':
        return Colors.purpleAccent;
      case 'Surprised':
        return Colors.orangeAccent;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "EmotionSense",
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
               ColorManager.backgroundColor,
               ColorManager.bubbleColor,
               ColorManager.buttonColor,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Image Display Container
                  Expanded(
                    flex: 6,
                    child: Hero(
                      tag: 'imageContainer',
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: _image != null
                              ? LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              double maxWidth = constraints.maxWidth;
                              double maxHeight = constraints.maxHeight;

                              return Stack(
                                children: [
                                  Container(
                                    width: maxWidth,
                                    height: maxHeight,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    child: Image.file(
                                      _image!,
                                      width: maxWidth,
                                      height: maxHeight,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  ..._faces.map((face) {
                                    final boundingBox = face.boundingBox;
                                    double scaleX = maxWidth / _imageWidth;
                                    double scaleY = maxHeight / _imageHeight;

                                    String emotion = _classifyEmotion(face);
                                    Color emotionColor = _getEmotionColor(emotion);

                                    return Positioned(
                                      left: boundingBox.left * scaleX,
                                      top: boundingBox.top * scaleY,
                                      width: boundingBox.width * scaleX,
                                      height: boundingBox.height * scaleY,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 400),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: emotionColor,
                                            width: 3,
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            Transform.translate(
                                              offset: const Offset(0, -20),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      emotionColor.withOpacity(0.7),
                                                      emotionColor,
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: emotionColor.withOpacity(0.5),
                                                      blurRadius: 10,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  emotion,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  if (_isProcessing)
                                    Container(
                                      color: Colors.black54,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          )
                              : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.black.withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.1),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.face_retouching_natural,
                                    size: 70,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Capture or Select an Image to\nAnalyze Emotions",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Container(
                                  width: 180,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF7F7FD5),
                                        const Color(0xFF91EAE4),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Get Started",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Results Summary
                  if (_faces.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "Detected ${_faces.length} ${_faces.length == 1 ? 'face' : 'faces'} in the image",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                  // Action Buttons
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.photo_library_rounded,
                            label: "Gallery",
                            color1: const Color(0xFF8A2387),
                            color2: const Color(0xFFE94057),
                            onTap: () => _pickImage(ImageSource.gallery),
                          ),
                          _buildActionButton(
                            icon: Icons.camera_alt_rounded,
                            label: "Camera",
                            color1: const Color(0xFF11998e),
                            color2: const Color(0xFF38ef7d),
                            onTap: () => _pickImage(ImageSource.camera),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color1, color2],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: color1.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class FaceEmotionDetector extends StatefulWidget {
  const FaceEmotionDetector({super.key});

  @override
  _FaceEmotionDetector createState() => _FaceEmotionDetector();
}