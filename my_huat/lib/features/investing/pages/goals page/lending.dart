// features/investing/goals/lending_investments.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:my_huat/shared/widgets/arc_header.dart'; // Add this import

class LendingInvestmentsPage extends StatefulWidget {
  const LendingInvestmentsPage({super.key});

  @override
  State<LendingInvestmentsPage> createState() => _LendingInvestmentsPageState();
}

class _LendingInvestmentsPageState extends State<LendingInvestmentsPage> {
  // Dropdown selection
  String? _selectedTopic;
  final List<String> _topics = [
    'Bonds',
    'Money Market Funds (MMF)',
  ];

  // Video players - lazy initialization
  VideoPlayerController? _bondsController;
  VideoPlayerController? _mmfController;

  // Track which video is currently playing
  VideoPlayerController? _activeController;
  bool _isVideoInitialized = false;
  bool _isLoadingVideo = false;

  // Track user progress
  bool _showCompleteButton = false;
  bool _showQuestionPage = false;
  bool _showEarnPointsDialog = false;

  // Quiz tracking
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _showAnswerResult = false;
  bool _isAnswerCorrect = false;
  int _score = 0;
  bool _quizCompleted = false;

  // Timer for checking video position
  Timer? _videoCheckTimer;

  // Navy blue color
  final Color navyBlue = const Color(0xFF0D3A6D);

  @override
  void initState() {
    super.initState();
    // Don't initialize videos here - do it lazily when needed
  }

  @override
  void dispose() {
    _videoCheckTimer?.cancel();
    _bondsController?.dispose();
    _mmfController?.dispose();
    super.dispose();
  }

  // Optimized video initialization with quality settings
  Future<void> _initVideo(VideoPlayerController controller) async {
    try {
      await controller.initialize();
      controller.setLooping(false);
      controller.setVolume(0.7);
    } catch (error) {
      debugPrint('Error loading video: $error');
    }
  }

  // Lazy initialize bonds video
  Future<void> _initBondsVideo() async {
    if (_bondsController != null) return;

    setState(() {
      _isLoadingVideo = true;
    });

    _bondsController = VideoPlayerController.asset('assets/video/Bonds.mp4');

    await _initVideo(_bondsController!);

    if (mounted) {
      setState(() {
        _isLoadingVideo = false;
      });
    }
  }

  // Lazy initialize MMF video
  Future<void> _initMMFVideo() async {
    if (_mmfController != null) return;

    setState(() {
      _isLoadingVideo = true;
    });

    _mmfController = VideoPlayerController.asset('assets/video/MMF.mp4');

    await _initVideo(_mmfController!);

    if (mounted) {
      setState(() {
        _isLoadingVideo = false;
      });
    }
  }

  // Handle topic selection
  void _onTopicChanged(String? newValue) {
    _videoCheckTimer?.cancel();

    setState(() {
      _selectedTopic = newValue;
      _showCompleteButton = false;
      _showQuestionPage = false;
      _showEarnPointsDialog = false;
      _isVideoInitialized = false;
      _resetQuiz();

      _activeController?.pause();
    });

    if (newValue == 'Bonds') {
      _initBondsVideo().then((_) {
        if (mounted && _bondsController != null) {
          setState(() {
            _activeController = _bondsController;
            _isVideoInitialized = true;
          });
        }
      });
    } else if (newValue == 'Money Market Funds (MMF)') {
      _initMMFVideo().then((_) {
        if (mounted && _mmfController != null) {
          setState(() {
            _activeController = _mmfController;
            _isVideoInitialized = true;
          });
        }
      });
    } else {
      _activeController = null;
    }
  }

  // Start checking video position
  void _startVideoCheck() {
    _videoCheckTimer?.cancel();
    _videoCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_activeController != null &&
          _activeController!.value.isPlaying &&
          _activeController!.value.position >= const Duration(seconds: 5) &&
          !_showCompleteButton) {
        setState(() {
          _showCompleteButton = true;
        });
        timer.cancel();
      }

      if (!mounted || _activeController == null || !_activeController!.value.isPlaying) {
        timer.cancel();
      }
    });
  }

  // Reset quiz
  void _resetQuiz() {
    _currentQuestionIndex = _getStartingIndexForTopic();
    _selectedAnswerIndex = null;
    _showAnswerResult = false;
    _isAnswerCorrect = false;
    _score = 0;
    _quizCompleted = false;
  }

  // Get starting index for selected topic
  int _getStartingIndexForTopic() {
    if (_selectedTopic == 'Bonds') return 0;
    if (_selectedTopic == 'Money Market Funds (MMF)') return 3;
    return 0;
  }

  // Get ending index for selected topic
  int _getEndingIndexForTopic() {
    if (_selectedTopic == 'Bonds') return 2;
    if (_selectedTopic == 'Money Market Funds (MMF)') return 5;
    return 2;
  }

  // Get total questions for selected topic
  int _getTotalQuestionsForTopic() {
    return 3;
  }

  // Show earn points dialog
  void _showEarnPointsDialogFn() {
    setState(() {
      _showEarnPointsDialog = true;
      _activeController?.pause();
      _videoCheckTimer?.cancel();
    });
  }

  // Go to question page
  void _goToQuestions() {
    setState(() {
      _showEarnPointsDialog = false;
      _showQuestionPage = true;
      _resetQuiz();
    });
  }

  // Go back to goals page with points update
  void _goBackToGoals() {
    Navigator.pop(context, _score * 10); // Return points to goals page
  }

  // Handle answer selection
  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  // Check answer
  void _checkAnswer() {
    if (_selectedAnswerIndex == null) return;

    bool isCorrect = _getCurrentQuestionCorrectAnswer() == _selectedAnswerIndex;

    setState(() {
      _isAnswerCorrect = isCorrect;
      _showAnswerResult = true;
      if (isCorrect) {
        _score++;
      }
    });
  }

  // Go to next question
  void _nextQuestion() {
    if (_currentQuestionIndex < _getEndingIndexForTopic()) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _showAnswerResult = false;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  // Get all questions
  List<Map<String, dynamic>> _getAllQuestions() {
    return [
      // Bonds Questions (0-2)
      {
        'topic': 'Bonds',
        'question': 'What is a bond?',
        'options': [
          'Ownership in a company',
          'Loan given by investor to government or company',
          'Type of insurance',
          'Bank saving account'
        ],
        'correctAnswer': 1,
      },
      {
        'topic': 'Bonds',
        'question': 'Bonds are generally considered:',
        'options': [
          'Very high risk investment',
          'Lower risk than stocks',
          'Only for rich people',
          'Gambling product'
        ],
        'correctAnswer': 1,
      },
      {
        'topic': 'Bonds',
        'question': 'Bond investors usually receive:',
        'options': [
          'Regular interest income',
          'Free property',
          'Lottery prize',
          'Salary'
        ],
        'correctAnswer': 0,
      },

      // Money Market Funds Questions (3-5)
      {
        'topic': 'Money Market Funds',
        'question': 'Money market fund (MMF) invests in:',
        'options': [
          'Short-term and low-risk instruments',
          'Only property',
          'New company startups only',
          'Art and jewellery'
        ],
        'correctAnswer': 0,
      },
      {
        'topic': 'Money Market Funds',
        'question': 'MMF is suitable for investors who want:',
        'options': [
          'Very high profit quickly',
          'Safety and high liquidity',
          'Only long-term loss',
          'No access to money'
        ],
        'correctAnswer': 1,
      },
      {
        'topic': 'Money Market Funds',
        'question': 'Money market fund is usually:',
        'options': [
          'High risk investment',
          'Short-term low risk investment',
          'Gambling investment',
          'Fixed property investment'
        ],
        'correctAnswer': 1,
      },
    ];
  }

  // Get current question
  Map<String, dynamic> _getCurrentQuestion() {
    return _getAllQuestions()[_currentQuestionIndex];
  }

  // Get correct answer index
  int _getCurrentQuestionCorrectAnswer() {
    return _getCurrentQuestion()['correctAnswer'];
  }

  // Get topic emoji
  String _getTopicEmoji() {
    if (_selectedTopic == 'Bonds') return '📜';
    if (_selectedTopic == 'Money Market Funds (MMF)') return '💰';
    return '📜';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Arc Header with MHuat text
          const ArcHeader(title: "MHuat"),

          // Title Section with Back Arrow
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            color: Colors.white,
            child: Row(
              children: [
                // Back arrow
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    _videoCheckTimer?.cancel();
                    Navigator.pop(context, 0);
                  },
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
                const SizedBox(width: 12),
                // Title
                const Text(
                  "Lending & Low-risk",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D3A6D), // Navy blue
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_showQuestionPage && !_showEarnPointsDialog) ...[
                        // Dropdown
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedTopic,
                                  hint: const Text('Select a topic'),
                                  isExpanded: true,
                                  items: _topics.map((topic) {
                                    return DropdownMenuItem(
                                      value: topic,
                                      child: Text(
                                        topic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: _onTopicChanged,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFF0D3A6D), width: 2), // Navy blue
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(Icons.play_circle_fill, color: navyBlue), // Navy blue
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Video player section
                        if (_selectedTopic != null) ...[
                          if (_isLoadingVideo)
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 10),
                                    Text('Loading video...'),
                                  ],
                                ),
                              ),
                            )
                          else if (_isVideoInitialized && _activeController != null)
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: _activeController!.value.aspectRatio,
                                      child: VideoPlayer(_activeController!),
                                    ),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.5),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              _activeController!.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (_activeController!.value.isPlaying) {
                                                  _activeController!.pause();
                                                  _videoCheckTimer?.cancel();
                                                } else {
                                                  _activeController!.play();
                                                  _startVideoCheck();
                                                }
                                              });
                                            },
                                          ),
                                          Text(
                                            '${_formatDuration(_activeController!.value.position)} / ${_formatDuration(_activeController!.value.duration)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 12),

                          if (_isVideoInitialized && !_showCompleteButton)
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.timer, color: Colors.amber),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Please wait for 5 seconds after playing the video for the "Complete" button to appear',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (_isVideoInitialized)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (_activeController!.value.isPlaying) {
                                        _activeController!.pause();
                                        _videoCheckTimer?.cancel();
                                      } else {
                                        _activeController!.play();
                                        _startVideoCheck();
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    _activeController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  ),
                                  label: Text(_activeController!.value.isPlaying ? 'Pause' : 'Play'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: navyBlue, // Navy blue
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _activeController!.seekTo(Duration.zero);
                                    setState(() {
                                      _showCompleteButton = false;
                                    });
                                    _videoCheckTimer?.cancel();
                                  },
                                  icon: const Icon(Icons.replay),
                                  label: const Text('Replay'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 20),

                          if (_showCompleteButton)
                            Center(
                              child: ElevatedButton(
                                onPressed: _showEarnPointsDialogFn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle),
                                    SizedBox(width: 10),
                                    Text(
                                      'Complete',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ],

                      // Question Page
                      if (_showQuestionPage) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: const [
                                Color(0xFF0D3A6D), // Dark navy
                                Color(0xFF2A5A8C), // Lighter navy
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _showQuestionPage = false;
                                        _showCompleteButton = true;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _selectedTopic ?? 'Lending & Low-risk Investments',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${_currentQuestionIndex - _getStartingIndexForTopic() + 1}/${_getTotalQuestionsForTopic()}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              if (_quizCompleted) ...[
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.emoji_events,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Quiz Completed!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'You scored $_score/${_getTotalQuestionsForTopic()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    'Earned ${_score * 10} points!',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: _goBackToGoals,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: navyBlue, // Navy blue
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Back to Goals',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: navyBlue.withValues(alpha: 0.1), // Navy blue
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              _getTopicEmoji(),
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _getCurrentQuestion()['topic'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: navyBlue, // Navy blue
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.auto_awesome, size: 12, color: Colors.blue),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'AI Generated',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.blue,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      Text(
                                        _getCurrentQuestion()['question'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Divider(),
                                      const SizedBox(height: 15),

                                      ...(_getCurrentQuestion()['options'] as List<String>).asMap().entries.map((entry) {
                                        int index = entry.key;
                                        String option = entry.value;
                                        bool isSelected = _selectedAnswerIndex == index;
                                        bool isCorrect = _showAnswerResult && index == _getCurrentQuestionCorrectAnswer();
                                        bool isWrong = _showAnswerResult && isSelected && !isCorrect;

                                        Color? backgroundColor;
                                        if (isCorrect) {
                                          backgroundColor = Colors.green.withValues(alpha: 0.1);
                                        } else if (isWrong) {
                                          backgroundColor = Colors.red.withValues(alpha: 0.1);
                                        } else if (isSelected) {
                                          backgroundColor = navyBlue.withValues(alpha: 0.1); // Navy blue
                                        }

                                        BorderSide borderSide = BorderSide(
                                          color: isCorrect
                                              ? Colors.green
                                              : isWrong
                                              ? Colors.red
                                              : isSelected
                                              ? navyBlue // Navy blue
                                              : Colors.grey.shade300,
                                        );

                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: _showAnswerResult ? null : () => _selectAnswer(index),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: backgroundColor ?? Colors.grey[50],
                                                foregroundColor: Colors.black87,
                                                elevation: 0,
                                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  side: borderSide,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                      color: isCorrect
                                                          ? Colors.green
                                                          : isWrong
                                                          ? Colors.red
                                                          : isSelected
                                                          ? navyBlue // Navy blue
                                                          : Colors.grey.shade200,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        String.fromCharCode(65 + index),
                                                        style: TextStyle(
                                                          color: (isCorrect || isWrong || isSelected)
                                                              ? Colors.white
                                                              : Colors.black54,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      option,
                                                      style: const TextStyle(fontSize: 15),
                                                    ),
                                                  ),
                                                  if (isCorrect)
                                                    const Icon(Icons.check_circle, color: Colors.green),
                                                  if (isWrong)
                                                    const Icon(Icons.cancel, color: Colors.red),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),

                                      const SizedBox(height: 20),

                                      if (!_showAnswerResult)
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _selectedAnswerIndex == null ? null : _checkAnswer,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: navyBlue, // Navy blue
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: const Text(
                                              'Check Answer',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),

                                      if (_showAnswerResult)
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _nextQuestion,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: navyBlue, // Navy blue
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Text(
                                              _currentQuestionIndex < _getEndingIndexForTopic()
                                                  ? 'Next Question'
                                                  : 'See Results',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (_showEarnPointsDialog)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: navyBlue.withValues(alpha: 0.1), // Navy blue
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.emoji_events,
                                color: navyBlue, // Navy blue
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Earn Points!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Would you like to answer questions about ${_selectedTopic ?? "this topic"} to earn points?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: navyBlue.withValues(alpha: 0.1), // Navy blue
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.stars, color: navyBlue, size: 16), // Navy blue
                                  const SizedBox(width: 4),
                                  Text(
                                    'Earn up to 30 points',
                                    style: TextStyle(
                                      color: navyBlue, // Navy blue
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _showEarnPointsDialog = false;
                                      });
                                      _goBackToGoals();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black87,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('No'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _goToQuestions,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: navyBlue, // Navy blue
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Yes'),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}