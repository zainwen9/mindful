import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class _FaceEmotionDetector extends State<FaceEmotionDetector> {
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


  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final file = File(pickedFile.path);

        final decodedImage = await decodeImageFromList(file.readAsBytesSync());
        _imageWidth = decodedImage.width.toDouble();
        _imageHeight = decodedImage.height.toDouble();

        setState(() {
          _image = file;
        });
        _detectEmotion();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error accessing ${source == ImageSource.camera ? 'camera' : 'gallery'}: $e")),
      );
    }
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No faces detected in the image")),
        );
      }
    } catch (e) {
      print("Error in face detection: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error detecting faces: $e")),
      );
    }
  }

  @override
  void dispose() {
    _faceDetector.close();
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

  @override
  Widget build(BuildContext bc) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "EmotionSense",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // Image Display Section
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _image != null
                                ? LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                double maxWidth = constraints.maxWidth;
                                double maxHeight =
                                    maxWidth * (_imageHeight / _imageWidth);

                                return Stack(
                                  children: [
                                    Image.file(
                                      _image!,
                                      width: maxWidth,
                                      height: maxHeight,
                                      fit: BoxFit.contain,
                                    ),
                                    ..._faces.map((face) {
                                      final boundingBox = face.boundingBox;
                                      double scaleX =
                                          maxWidth / _imageWidth;
                                      double scaleY =
                                          maxHeight / _imageHeight;

                                      return Positioned(
                                        left: boundingBox.left * scaleX,
                                        top: boundingBox.top * scaleY,
                                        width: boundingBox.width * scaleX,
                                        height: boundingBox.height * scaleY,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.amber,
                                              width: 3,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          child: Align(
                                            alignment:
                                            Alignment.topCenter,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.amber
                                                    .withOpacity(0.9),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    4),
                                              ),
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 4,
                                                  horizontal: 8),
                                              child: Text(
                                                _classifyEmotion(face),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              },
                            )
                                : Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 80,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Select or Capture an Image",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color:
                                      Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Buttons Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildNeumorphicButton(
                              icon: Icons.photo,
                              text: "Gallery",
                              onPressed: () => _pickImage(ImageSource.gallery),
                            ),
                            const SizedBox(width: 20),
                            _buildNeumorphicButton(
                              icon: Icons.camera_alt,
                              text: "Camera",
                              onPressed: () => _pickImage(ImageSource.camera),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
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

  Widget _buildNeumorphicButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(5, 5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: const Offset(-5, -5),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}

class FaceEmotionDetector extends StatefulWidget {
  FaceEmotionDetector({super.key});

  @override
  _FaceEmotionDetector createState() => _FaceEmotionDetector();
}