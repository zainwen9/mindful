import 'package:flutter/material.dart';
import 'package:mental_health/presentation/Questions/Question8.dart';
import 'package:mental_health/resources/app_colors.dart';


class questionSeven extends StatefulWidget {
  const questionSeven({Key? key}) : super(key: key);

  @override
  _questionSevenState createState() => _questionSevenState();
}

class _questionSevenState extends State<questionSeven> with SingleTickerProviderStateMixin {
  String? _selectedOption;
  bool _isDropdownOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _options = [
    'Yes, I have strong support',
    'Somewhat, but not always',
    'No, I feel mostly alone',
    'I don\'t know'
  ];

  final Map<String, Color> _optionColors = {
    'Yes, I have strong support': const Color(0xFF4CAF50),
    'Somewhat, but not always': const Color(0xFFFFC107),
    'No, I feel mostly alone': const Color(0xFFEF5350),
    'I don\'t know': const Color(0xFF78909C),
  };

  final Map<String, IconData> _optionIcons = {
    'Yes, I have strong support': Icons.favorite,
    'Somewhat, but not always': Icons.sentiment_neutral,
    'No, I feel mostly alone': Icons.sentiment_dissatisfied,
    'I don\'t know': Icons.help_outline,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
      if (_isDropdownOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
      _isDropdownOpen = false;
      _animationController.reverse();
    });
  }

  void _handleSubmission() {
    if (_selectedOption != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Your response has been saved!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          backgroundColor: ColorManager.bubbleColor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ).closed.then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  questionEight()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF080D13);
    final cardColor = const Color(0xFF121821);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with Gradient
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, ColorManager.bubbleColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "Your Support System",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              Text(
                "Understanding who's there for you can help identify resources.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 40),

              // Question Box
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cardColor,
                      cardColor.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(4, 4),
                    ),
                    BoxShadow(
                      color: ColorManager.bubbleColor.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(-4, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorManager.bubbleColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "7",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.bubbleColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            "Do you feel supported by the people around you?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Custom Dropdown
                    GestureDetector(
                      onTap: _toggleDropdown,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isDropdownOpen
                                ? ColorManager.bubbleColor
                                : Colors.grey.withOpacity(0.3),
                            width: 1.5,
                          ),
                          color: _isDropdownOpen
                              ? ColorManager.bubbleColor.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            if (_selectedOption != null) ...[
                              Icon(
                                _optionIcons[_selectedOption]!,
                                color: _optionColors[_selectedOption],
                                size: 24,
                              ),
                              const SizedBox(width: 14),
                            ],
                            Expanded(
                              child: Text(
                                _selectedOption ?? "Select an option",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: _selectedOption == null
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.white,
                                  fontWeight: _selectedOption == null
                                      ? FontWeight.normal
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              _isDropdownOpen
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: _isDropdownOpen
                                  ? ColorManager.bubbleColor
                                  : Colors.grey.shade500,
                              size: 26,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Dropdown Options
                    SizeTransition(
                      sizeFactor: _animation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A202C),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: _options.map((option) {
                              final isSelected = _selectedOption == option;
                              return InkWell(
                                onTap: () => _selectOption(option),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? ColorManager.bubbleColor.withOpacity(0.1)
                                        : Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.1),
                                        width: option != _options.last ? 1 : 0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _optionIcons[option],
                                        color: _optionColors[option],
                                        size: 24,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: isSelected
                                                ? ColorManager.bubbleColor
                                                : Colors.white,
                                            fontWeight: isSelected
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: ColorManager.bubbleColor,
                                          size: 22,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Submit Button
              Center(
                child: GestureDetector(
                  onTap: _selectedOption != null ? _handleSubmission : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _selectedOption != null
                              ? ColorManager.bubbleColor
                              : ColorManager.bubbleColor.withOpacity(0.3),
                          _selectedOption != null
                              ? ColorManager.bubbleColor.withOpacity(0.8)
                              : ColorManager.bubbleColor.withOpacity(0.2),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: _selectedOption != null
                          ? [
                        BoxShadow(
                          color: ColorManager.bubbleColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : [],
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(_selectedOption != null ? 1.0 : 0.5),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
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
}