import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:mental_health/features/auth/domain/entities/auth/googleapisignin.dart';
import 'package:mental_health/features/meditation/presentation/bloc/dailyQuote/daily_quote_bloc.dart';
import 'package:mental_health/features/meditation/presentation/bloc/dailyQuote/daily_quote_event.dart';
import 'package:mental_health/features/meditation/presentation/bloc/dailyQuote/daily_quote_state.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_data/mood_data_bloc.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_data/mood_data_state.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_message/mood_message_bloc.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_message/mood_message_event.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_message/mood_message_state.dart';
import 'package:mental_health/features/meditation/presentation/widgets/moods.dart';
import 'package:mental_health/features/meditation/presentation/widgets/task_card.dart';
import 'package:mental_health/presentation/buddy/supportHub.dart';
import 'package:mental_health/presentation/chat_screen/chat_with_ai.dart';
import 'package:mental_health/resources/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/theme.dart';
import '../../../../presentation/RecoveryStories/RecoveryStories.dart';
import '../../../../presentation/RecoveryStories/RecoveryStoriesScreen.dart';
import '../../../../presentation/buddy/AccountabilityBuddy.dart';
import '../../../../presentation/buddy/findBuddy.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> with SingleTickerProviderStateMixin {
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? dataSources;
  List<CircularChartAnnotation>? _annotationSources;
  List<Color>? colors;
  late GoogleSignInAccount? user2;
  late User? user1;
  List<ChartSampleData>? __chartData;
  TooltipBehavior? __tooltipBehavior;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final bool _hasBuddy = false;

  // Mood animations map
  final Map<String, String> _moodAnimations = {
    "Happy": 'https://lottie.host/b4a596fb-3b74-403a-ba62-94e56dd1662c/n0wCMuhZKw.json',
    "Neutral": 'https://lottie.host/40e7eb6f-1461-4074-b9e6-836c2f59bab3/PB53CLQJwY.json',
    "Sad": 'https://lottie.host/3462abf3-a8a4-4deb-bda8-9457dbba7856/mpGSZCUNdL.json',
    "Calm": 'https://lottie.host/eb85b992-d67e-4308-b566-56b70863528e/pvJy8nX9UM.json',
    "Relax": 'https://lottie.host/5d81afcc-21d6-4395-82f9-b3245bfbdfcd/Tx797g2kdJ.json',
    "Focus": 'https://lottie.host/ec761808-ad04-4b8e-910e-f97234c4d6c6/k1f6uaivUR.json',
  };

  @override
  void initState() {
    super.initState();

    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn)
    );

    _animationController.forward();

    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x : point.y%');
    __tooltipBehavior = _tooltipBehavior;

    _annotationSources = <CircularChartAnnotation>[
      CircularChartAnnotation(
        widget: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 20,
            child: LottieBuilder.network(_moodAnimations["Happy"]!),
          ),
        ),
      ),
      CircularChartAnnotation(
        widget: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 60,
            child: LottieBuilder.network(_moodAnimations["Neutral"]!),
          ),
        ),
      ),
      CircularChartAnnotation(
        widget: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 60,
            child: LottieBuilder.network(_moodAnimations["Sad"]!),
          ),
        ),
      ),
      CircularChartAnnotation(
        widget: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 60,
            child: LottieBuilder.network(_moodAnimations["Calm"]!),
          ),
        ),
      ),
      CircularChartAnnotation(
        widget: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 60,
            child: LottieBuilder.network(_moodAnimations["Relax"]!),
          ),
        ),
      ),
      CircularChartAnnotation(
        widget: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 60,
            child: LottieBuilder.network(_moodAnimations["Focus"]!),
          ),
        ),
      ),
    ];

    colors = const <Color>[
      Color(0xFF64DFDF), // Vibrant teal
      Color(0xFFF3A871), // Soft orange
      Color(0xFF9A76C6), // Muted purple
      Color(0xFFFF73B3), // Soft pink
      Color(0xFF4DAADC), // Sky blue
      Color(0xFFE2B15B), // Golden yellow
    ];
  }

  SfCircularChart _buildCustomizedRadialBarChart() {
    dataSources = <ChartSampleData>[
      ChartSampleData(
          x: 'Happy',
          y: 0.20,
          text: '10%',
          pointColor: colors![0]),
      ChartSampleData(
          x: 'Neutral',
          y: 0.50,
          text: '10%',
          pointColor: colors![1]),
      ChartSampleData(
          x: 'Sad',
          y: 0.6,
          text: '100%',
          pointColor: colors![2]),
      ChartSampleData(
          x: 'Calm',
          y: 0.1,
          text: '100%',
          pointColor: colors![3]),
      ChartSampleData(
          x: 'Relax',
          y: 0.9,
          text: '100%',
          pointColor: colors![4]),
      ChartSampleData(
          x: 'Focus',
          y: 0.8,
          text: '100%',
          pointColor: colors![5])
    ];

    return SfCircularChart(
      title: ChartTitle(
          text: 'Your Mood Analytics',
          textStyle: TextStyle(
              fontFamily: 't3',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600
          )
      ),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.scroll,
        position: LegendPosition.bottom,
        backgroundColor: ColorManager.bubbleColor.withOpacity(0.2),
        borderColor: ColorManager.buttonColor.withOpacity(0.3),
        borderWidth: 1,
        legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
          return Container(
            decoration: BoxDecoration(
              color: ColorManager.bubbleColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colors![index].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  width: 65,
                  child: SfCircularChart(
                    backgroundColor: Colors.transparent,
                    annotations: <CircularChartAnnotation>[
                      _annotationSources![index],
                    ],
                    series: <RadialBarSeries<ChartSampleData, String>>[
                      RadialBarSeries<ChartSampleData, String>(
                        animationDuration: 0,
                        dataSource: <ChartSampleData>[dataSources![index]],
                        maximumValue: 100,
                        radius: '100%',
                        cornerStyle: CornerStyle.bothCurve,
                        xValueMapper: (ChartSampleData data, _) => point.x as String,
                        yValueMapper: (ChartSampleData data, _) => data.y,
                        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
                        innerRadius: '70%',
                        pointRadiusMapper: (ChartSampleData data, _) => data.text,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 72,
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    point.x,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors![index],
                      fontWeight: FontWeight.bold,
                      fontFamily: 't3',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      series: _getRadialBarCustomizedSeries(),
      tooltipBehavior: _tooltipBehavior,
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          height: '90%',
          width: '90%',
          widget: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorManager.buttonColor.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: CircleAvatar(
                  backgroundColor: ColorManager.bubbleColor.withOpacity(0.2),
                  backgroundImage: user1 != null
                      ? (user1?.photoURL != null
                      ? NetworkImage(user1!.photoURL!)
                      : const NetworkImage("https://pbs.twimg.com/media/F3tVQbJWUAEOXJB.jpg:large"))
                      : user2!.photoUrl != null
                      ? NetworkImage(user2!.photoUrl!)
                      : const NetworkImage("https://pbs.twimg.com/media/F3tVQbJWUAEOXJB.jpg:large"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarCustomizedSeries() {
    return <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
        animationDuration: 1000,
        maximumValue: 100,
        gap: '10%',
        radius: '100%',
        dataSource: <ChartSampleData>[
          ChartSampleData(
            x: 'Happy',
            y: 62.70,
            text: '100%',
            pointColor: colors![0],
          ),
          ChartSampleData(
            x: 'Neutral',
            y: 29.20,
            text: '100%',
            pointColor: colors![1],
          ),
          ChartSampleData(
            x: 'Sad',
            y: 85.20,
            text: '100%',
            pointColor: colors![2],
          ),
          ChartSampleData(
            x: 'Calm',
            y: 45.70,
            text: '100%',
            pointColor: colors![3],
          ),
          ChartSampleData(
            x: 'Relax',
            y: 45.70,
            text: '100%',
            pointColor: colors![4],
          ),
          ChartSampleData(
            x: 'Focus',
            y: 45.70,
            text: '100%',
            pointColor: colors![5],
          ),
        ],
        trackColor: ColorManager.bubbleColor.withOpacity(0.2),
        cornerStyle: CornerStyle.bothCurve,
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        legendIconType: LegendIconType.circle,
      ),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    try {
      dataSources!.clear();
      __chartData!.clear();
      _annotationSources!.clear();
    } catch (error) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user1 = FirebaseAuth.instance.currentUser;
    user2 = GoogleSignInApi.details();
    final mybox = Hive.box('firstime');
    String valobatained = mybox.get('firsttime');

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: Stack(
        children: [
          // Gradient background with animated bubble effects
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _fadeAnimation.value,
              child: CustomPaint(
                painter: BubblesPainter(
                  colorManager: ColorManager,
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                _buildCustomAppBar(context),

                // Scrollable content
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Welcome section
                            _buildWelcomeSection(context),

                            Center(
                              child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image(
                                    image: AssetImage('assets/imag.gif'),
                                  )),
                            ),
                            SizedBox(height: 10,),

                            // Mood section
                            _buildMoodSection(context),

                            // Quote card
                            _buildQuoteCard(),

                            const SizedBox(height: 30),

                            // Render mood message alert
                            BlocBuilder<MoodMessageBloc, MoodMessageState>(
                              builder: (context, state) {
                                if (state is MoodMessageLoaded) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    showDialog(
                                      barrierDismissible: false,
                                      barrierColor: Colors.black.withOpacity(0.6),
                                      context: context,
                                      builder: (context) => BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                        child: Dialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: ColorManager.backgroundColor,
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorManager.buttonColor.withOpacity(0.5),
                                                  blurRadius: 20,
                                                  spreadRadius: 5,
                                                ),
                                              ],
                                              border: Border.all(
                                                color: ColorManager.bubbleColor.withOpacity(0.5),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                LottieBuilder.network(
                                                  'https://lottie.host/fc2bc940-1d88-4ea2-8d5d-791e6480760e/4oA0NKLXn3.json',
                                                  height: 80,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  'Mindfulness Advice',
                                                  style: TextStyle(
                                                    fontFamily: 't3',
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorManager.buttonColor,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  state.moodMessage.text,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    height: 1.5,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 24),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    context.read<MoodMessageBloc>().add(ResetMoodMessage());
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorManager.buttonColor,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    elevation: 8,
                                                    shadowColor: ColorManager.buttonColor.withOpacity(0.5),
                                                  ),
                                                  child: const Text(
                                                    "I Understand",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                }
                                return Container();
                              },
                            ),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              child: _hasBuddy
                                  ? YourAccountabilityBuddy(key: ValueKey('buddy'))
                                  : FindABuddy(key: ValueKey('find')),
                            ),

                            SizedBox(height: 10,),

                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecoveryStoriesScreen()),
                                  );
                                },
                                child: RecoveryStories()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: ColorManager.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: ColorManager.bubbleColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Mindful",
            style: TextStyle(
              fontSize: 26,
              color: ColorManager.buttonColor,
              fontWeight: FontWeight.bold,
              fontFamily: 't3',
              letterSpacing: 1,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SupportHubScreen(),),);
                },
                icon: Icon(
                  Icons.message,
                  color: Colors.white.withOpacity(0.8),
                  size: 26,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => showDialog(
                  barrierColor: Colors.black.withOpacity(0.5),
                  builder: (context) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      insetPadding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ColorManager.backgroundColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.buttonColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 1,
                            ),
                          ],
                          border: Border.all(
                            color: ColorManager.bubbleColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              color: ColorManager.buttonColor,
                              size: 36,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              user1 != null
                                  ? (user1?.displayName != null
                                  ? "${user1?.displayName}'s Mood Analytics"
                                  : "Your Mood Analytics")
                                  : "${user2?.displayName}'s Mood Analytics",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width,
                              child: _buildCustomizedRadialBarChart(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  context: context,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorManager.buttonColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.buttonColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    backgroundImage: user1 != null
                        ? (user1?.photoURL != null
                        ? NetworkImage(user1!.photoURL!)
                        : const NetworkImage("https://pbs.twimg.com/media/F3tVQbJWUAEOXJB.jpg:large"))
                        : user2!.photoUrl != null
                        ? NetworkImage(user2!.photoUrl!)
                        : const NetworkImage("https://pbs.twimg.com/media/F3tVQbJWUAEOXJB.jpg:large"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user1 != null
                      ? (user1?.displayName != null
                      ? "Welcome Back, ${user1?.displayName}"
                      : "Welcome Back")
                      : "Welcome Back, ${user2?.displayName}",
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "How's your day going?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ChatWithAi(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(position: offsetAnimation, child: child);
                  },
                ),
              );
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: ColorManager.bubbleColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.buttonColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: LottieBuilder.network(
                "https://lottie.host/7f8fdd94-95c4-4a11-90bb-edc15af41005/jVxlzL8zAW.json",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Text(
            "How are you feeling today?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 30),
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildMoodButton(
                "Happy",
                _moodAnimations["Happy"]!,
                    () => context.read<MoodMessageBloc>().add(FetchMoodMessage('happy')),
                colors![0],
              ),
              _buildMoodButton(
                "Neutral",
                _moodAnimations["Neutral"]!,
                    () => context.read<MoodMessageBloc>().add(FetchMoodMessage('neutral')),
                colors![1],
              ),
              _buildMoodButton(
                "Sad",
                _moodAnimations["Sad"]!,
                    () => context.read<MoodMessageBloc>().add(FetchMoodMessage('sad')),
                colors![2],
              ),
              _buildMoodButton(
                "Calm",
                _moodAnimations["Calm"]!,
                    () => context.read<MoodMessageBloc>().add(FetchMoodMessage('calm')),
                colors![3],
              ),
              _buildMoodButton(
                "Relax",
                _moodAnimations["Relax"]!,
                    () => context.read<MoodMessageBloc>().add(FetchMoodMessage('relax')),
                colors![4],
              ),
              _buildMoodButton(
                "Focus",
                _moodAnimations["Focus"]!,
                    () => context.read<MoodMessageBloc>().add(FetchMoodMessage('focus')),
                colors![5],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodButton(String label, String animationPath, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: ColorManager.bubbleColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: LottieBuilder.network(
                animationPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard() {
    return BlocBuilder<DailyQuoteBloc, DailyQuoteState>(
      builder: (context, state) {
        if (state is DailyQuoteLoading) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: ColorManager.bubbleColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: LottieBuilder.network(
                "https://lottie.host/65bd2e51-261e-4712-a5bd-38451aac4977/viHIqd4hxU.json",
                height: 100,
                width: 100,
              ),
            ),
          );
        } else if (state is DailyQuoteLoaded) {
          final int h = DateTime.now().hour;
          String title;
          String quote;
          Color cardColor;
          String lottieUrl;

          if (0 <= h && h <= 12) {
            title = "A Very Good Morning";
            quote = state.dailyQuote.morningQuote;
            cardColor = ColorManager.buttonColor;
            lottieUrl = "https://lottie.host/b4a596fb-3b74-403a-ba62-94e56dd1662c/n0wCMuhZKw.json";
          } else if (12 <= h && h <= 17) {
            title = "Good Afternoon";
            quote = state.dailyQuote.noonQuote;
            cardColor = Colors.orange;
            lottieUrl = "https://lottie.host/40e7eb6f-1461-4074-b9e6-836c2f59bab3/PB53CLQJwY.json";
          } else {
            title = "Good Evening";
            quote = state.dailyQuote.eveningQuote;
            cardColor = Colors.indigo;
            lottieUrl = "https://lottie.host/5d81afcc-21d6-4395-82f9-b3245bfbdfcd/Tx797g2kdJ.json";
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorManager.bubbleColor.withOpacity(0.3),
                  cardColor.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: cardColor.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: cardColor.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ColorManager.bubbleColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: LottieBuilder.network(
                          lottieUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      title,
                      style: TextStyle(
                        color: cardColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '"$quote"',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: cardColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: cardColor,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Daily Inspiration",
                          style: TextStyle(
                            color: cardColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is DailyQuoteError) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorManager.bubbleColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: LottieBuilder.network(
                      "https://lottie.host/628ae316-ce58-4c02-a205-d29fe845a04a/DsXepW48Af.json",
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Please Check Server Connection and Refresh (Errorx01)",
                    style: TextStyle(
                      color: Colors.red.shade300,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorManager.bubbleColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.yellow.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: LottieBuilder.network(
                      "https://lottie.host/fc2bc940-1d88-4ea2-8d5d-791e6480760e/4oA0NKLXn3.json",
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Please Refresh (Errorx02)",
                    style: TextStyle(
                      color: Colors.yellow.shade300,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

// Custom bubble painter for beautiful background effect
class BubblesPainter extends CustomPainter {
  final dynamic colorManager;

  BubblesPainter({required this.colorManager});

  @override
  void paint(Canvas canvas, Size size) {
    // Create multiple blurred circles for a layered effect
    final Paint paint1 = Paint()
      ..color = colorManager.buttonColor.withOpacity(0.05)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    final Paint paint2 = Paint()
      ..color = colorManager.bubbleColor.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    // Top left bubble
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.15),
      size.width * 0.3,
      paint1,
    );

    // Bottom right bubble
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.8),
      size.width * 0.4,
      paint2,
    );

    // Middle bubble
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.2,
      Paint()
        ..color = colorManager.buttonColor.withOpacity(0.04)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60),
    );

    // Additional small accent bubbles
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.6),
      size.width * 0.1,
      Paint()
        ..color = Colors.white.withOpacity(0.02)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );

    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.25),
      size.width * 0.15,
      Paint()
        ..color = colorManager.bubbleColor.withOpacity(0.07)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData({
    this.x,
    this.y,
    this.xValue,
    this.yValue,
    this.secondSeriesYValue,
    this.thirdSeriesYValue,
    this.pointColor,
    this.size,
    this.text,
    this.open,
    this.close,
    this.low,
    this.high,
    this.volume
  });

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}