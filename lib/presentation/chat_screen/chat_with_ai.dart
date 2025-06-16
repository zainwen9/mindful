import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

// Define color manager for consistent theming with green shades
class ColorTheme {
  // Core palette - emerald greens with dark backgrounds
  static const backgroundColor = Color(0xFF0A1F1C);
  static const surfaceColor = Color(0xFF122C28);
  static const primaryColor = Color(0xFF10B981); // Emerald green
  static const accentColor = Color(0xFF34D399); // Light emerald
  static const tertiaryColor = Color(0xFF059669); // Deep emerald

  // Bubble colors
  static const userBubbleColor = Color(0xFF10B981);
  static const botBubbleColor = Color(0xFF1E3A37);

  // Text colors
  static const textPrimaryColor = Color(0xFFF9FAFB);
  static const textSecondaryColor = Color(0xFFABB9B7);

  // Gradients
  static const gradientStart = Color(0xFF042F2E);
  static const gradientEnd = Color(0xFF071F1E);

  // Accent highlights
  static const highlightColor = Color(0xFF6EE7B7);
  static const subtleHighlight = Color(0xFF065F46);
}

class ChatWithAi extends StatefulWidget {
  const ChatWithAi({super.key});

  @override
  State<ChatWithAi> createState() => _ChatWithAiState();
}

class _ChatWithAiState extends State<ChatWithAi> with TickerProviderStateMixin {
  final TextEditingController _userInput = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _typingAnimationController;
  late AnimationController _pulseController;

  final List<Particle> _particles = [];
  bool _isAiTyping = false;
  bool _isInputFocused = false;
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _userInput.dispose();
    _animationController.dispose();
    _typingAnimationController.dispose();
    _pulseController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _inputFocusNode.hasFocus;
      });
    });

    // Initialize particles for ambient background effect
    for (int i = 0; i < 40; i++) {
      _particles.add(Particle(
        position: Offset(
          (i % 10) * 40.0 + (i * 3.7).truncateToDouble(),
          (i ~/ 10) * 70.0 + (i * 2.3).truncateToDouble(),
        ),
        velocity: Offset(
          -0.3 + (i % 5) * 0.2,
          -0.1 + (i % 7) * 0.08,
        ),
        color: i % 3 == 0
            ? ColorTheme.primaryColor.withOpacity(0.3)
            : i % 3 == 1
            ? ColorTheme.accentColor.withOpacity(0.3)
            : ColorTheme.highlightColor.withOpacity(0.3),
        size: 3.0 + (i % 4) * 1.5,
      ));
    }
  }

  var scrollController = ScrollController();
  static const apiKey = "AIzaSyDv5CugKqpf44FaB_jlIvMFI0BEEj8niig";
  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);

  final List<Message> _messages = [];
  double c = 0;

  Future<void> sendMessage() async {
    final message = _userInput.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
      c++;
      _userInput.text = '';
    });

    _scrollToBottom();

    // Show AI typing indicator
    setState(() {
      _isAiTyping = true;
    });

    // Send message to API
    try {
      final content = [Content.text(message)];
      final response = await model.generateContent(content);

      setState(() {
        _isAiTyping = false;
        _messages.add(Message(
            isUser: false, message: response.text ?? "", date: DateTime.now()));
        c++;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isAiTyping = false;
        _messages.add(Message(
            isUser: false,
            message: "Sorry, I couldn't process that request. Please try again.",
            date: DateTime.now()));
        c++;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleBackPress() {
    // Handle back navigation
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: ColorTheme.backgroundColor.withOpacity(0.7),
            ),
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorTheme.surfaceColor.withOpacity(0.8),
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorTheme.subtleHighlight.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorTheme.textPrimaryColor,
              size: 18,
            ),
          ),
          onPressed: _handleBackPress,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        ColorTheme.primaryColor,
                        ColorTheme.accentColor,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorTheme.primaryColor.withOpacity(0.3 + 0.2 * _pulseController.value),
                        blurRadius: 12 + 8 * _pulseController.value,
                        spreadRadius: 1 + 2 * _pulseController.value,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                );
              },
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Emerald Assistant",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ColorTheme.textPrimaryColor,
                    letterSpacing: 0.2,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorTheme.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        backgroundColor: ColorTheme.accentColor,
                        radius: 3,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Active Now",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: ColorTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: ColorTheme.textPrimaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Ambient gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorTheme.gradientStart,
                  ColorTheme.gradientEnd,
                ],
              ),
            ),
          ),

          // Animated particles - Using CustomPainter
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              for (var particle in _particles) {
                particle.update();
              }
              return CustomPaint(
                painter: ParticlePainter(_particles),
                size: Size.infinite,
              );
            },
          ),

          // Glowing orbs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorTheme.primaryColor.withOpacity(0.08),
                    blurRadius: 120,
                    spreadRadius: 60,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorTheme.accentColor.withOpacity(0.06),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Chat messages
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: ColorTheme.surfaceColor.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: ColorTheme.subtleHighlight.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(top: 20, bottom: 16),
                          itemCount: _messages.length + (_isAiTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _messages.length && _isAiTyping) {
                              return const TypingIndicator();
                            }
                            final message = _messages[index];
                            return MessageBubble(
                              isUser: message.isUser,
                              message: message.message,
                              time: DateFormat('HH:mm').format(message.date),
                              animate: index == _messages.length - 1,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Input area
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorTheme.surfaceColor.withOpacity(0.8),
                      border: Border(
                        top: BorderSide(
                          color: ColorTheme.subtleHighlight.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorTheme.backgroundColor.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorTheme.subtleHighlight.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: ColorTheme.textSecondaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: _isInputFocused
                                  ? ColorTheme.surfaceColor.withOpacity(0.9)
                                  : ColorTheme.surfaceColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: _isInputFocused
                                    ? ColorTheme.primaryColor.withOpacity(0.6)
                                    : ColorTheme.subtleHighlight.withOpacity(0.4),
                                width: _isInputFocused ? 1.5 : 1,
                              ),
                              boxShadow: _isInputFocused
                                  ? [
                                BoxShadow(
                                  color: ColorTheme.primaryColor.withOpacity(0.15),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                                  : null,
                            ),
                            child: TextField(
                              controller: _userInput,
                              focusNode: _inputFocusNode,
                              cursorColor: ColorTheme.primaryColor,
                              style: const TextStyle(
                                color: ColorTheme.textPrimaryColor,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Ask me anything...',
                                hintStyle: TextStyle(
                                  color: ColorTheme.textSecondaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: sendMessage,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  ColorTheme.primaryColor,
                                  ColorTheme.tertiaryColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorTheme.primaryColor.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                splashColor: Colors.white.withOpacity(0.1),
                                highlightColor: Colors.white.withOpacity(0.1),
                                onTap: sendMessage,
                                child: const Center(
                                  child: Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Message model class
class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

// Custom message bubble widget with animation
class MessageBubble extends StatefulWidget {
  final bool isUser;
  final String message;
  final String time;
  final bool animate;

  const MessageBubble({
    super.key,
    required this.isUser,
    required this.message,
    required this.time,
    this.animate = false,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Align(
          alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: EdgeInsets.only(
              left: widget.isUser ? 64 : 16,
              right: widget.isUser ? 16 : 64,
              bottom: 18,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              gradient: widget.isUser
                  ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorTheme.primaryColor,
                  ColorTheme.tertiaryColor,
                ],
              )
                  : null,
              color: widget.isUser ? null : ColorTheme.botBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(22),
                topRight: const Radius.circular(22),
                bottomLeft: widget.isUser ? const Radius.circular(22) : const Radius.circular(4),
                bottomRight: widget.isUser ? const Radius.circular(4) : const Radius.circular(22),
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isUser
                      ? ColorTheme.primaryColor.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: widget.isUser
                  ? null
                  : Border.all(
                color: ColorTheme.subtleHighlight.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.isUser)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                ColorTheme.accentColor,
                                ColorTheme.primaryColor,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Emerald Assistant",
                          style: TextStyle(
                            color: ColorTheme.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.isUser
                        ? Colors.white
                        : ColorTheme.textPrimaryColor,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isUser)
                        const Icon(
                          Icons.check_circle,
                          size: 12,
                          color: Colors.white70,
                        ),
                      if (widget.isUser)
                        const SizedBox(width: 4),
                      Text(
                        widget.time,
                        style: TextStyle(
                          color: widget.isUser
                              ? Colors.white.withOpacity(0.7)
                              : ColorTheme.textPrimaryColor.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Typing indicator animation
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16, bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ColorTheme.botBubbleColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorTheme.subtleHighlight.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            _buildDot(1),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Interval(
          index * 0.2,
          0.6 + index * 0.2,
          curve: Curves.easeInOut,
        ),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, -4 * value * (1 - value) * 4),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: ColorTheme.accentColor.withOpacity(0.5 + 0.5 * value),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorTheme.accentColor.withOpacity(0.2 * value),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Particle class for ambient background effect
class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
  });

  void update() {
    position += velocity;

    // Screen wrap logic
    if (position.dx < -50) position = Offset(400, position.dy);
    if (position.dx > 450) position = Offset(0, position.dy);
    if (position.dy < -50) position = Offset(position.dx, 800);
    if (position.dy > 850) position = Offset(position.dx, 0);
  }
}

// Custom painter for drawing particles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}