// features/insurance/goals/types_of_insurance.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';

// Global variable to track points (in a real app, this would be in a state management solution)
int userPoints = 0;

class ProtectionPlansPage extends StatefulWidget {
  const ProtectionPlansPage({super.key});

  @override
  State<ProtectionPlansPage> createState() => _ProtectionPlansPageState();
}

class _ProtectionPlansPageState extends State<ProtectionPlansPage> {
  // Dropdown selection
  String? _selectedTopic;
  final List<String> _topics = [
    'Medical Insurance',
    'Critical Illness Insurance',
    'Personal Accident Insurance',
    'Mortgage Reducing Term Assurance (MRTA)'
  ];

  // Video players
  late VideoPlayerController _medicalController;
  late VideoPlayerController _criticalController;
  late VideoPlayerController _personalController;
  late VideoPlayerController _mrtaController;
  late Future<void> _medicalInitializeFuture;
  late Future<void> _criticalInitializeFuture;
  late Future<void> _personalInitializeFuture;
  late Future<void> _mrtaInitializeFuture;

  // Track which video is currently playing
  VideoPlayerController? _activeController;
  bool _isVideoInitialized = false;

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

  @override
  void initState() {
    super.initState();

    // Initialize medical video controller (Medical Insurance)
    _medicalController = VideoPlayerController.asset('assets/video/medical.mp4');
    _medicalInitializeFuture = _medicalController.initialize().then((_) {
      _medicalController.setLooping(false);
      _medicalController.setVolume(1.0);
      if (mounted) setState(() {});
    }).catchError((error) {
      debugPrint('Error loading medical video: $error');
    });

    // Initialize critical illness video controller (Critical Illness Insurance)
    _criticalController = VideoPlayerController.asset('assets/video/critical.mp4');
    _criticalInitializeFuture = _criticalController.initialize().then((_) {
      _criticalController.setLooping(false);
      _criticalController.setVolume(1.0);
      if (mounted) setState(() {});
    }).catchError((error) {
      debugPrint('Error loading critical illness video: $error');
    });

    // Initialize personal accident video controller (Personal Accident Insurance)
    _personalController = VideoPlayerController.asset('assets/video/personal.mp4');
    _personalInitializeFuture = _personalController.initialize().then((_) {
      _personalController.setLooping(false);
      _personalController.setVolume(1.0);
      if (mounted) setState(() {});
    }).catchError((error) {
      debugPrint('Error loading personal accident video: $error');
    });

    // Initialize MRTA video controller (Mortgage Reducing Term Assurance)
    _mrtaController = VideoPlayerController.asset('assets/video/MRTA.mp4');
    _mrtaInitializeFuture = _mrtaController.initialize().then((_) {
      _mrtaController.setLooping(false);
      _mrtaController.setVolume(1.0);
      if (mounted) setState(() {});
    }).catchError((error) {
      debugPrint('Error loading MRTA video: $error');
    });
  }

  @override
  void dispose() {
    _medicalController.dispose();
    _criticalController.dispose();
    _personalController.dispose();
    _mrtaController.dispose();
    super.dispose();
  }

  // Handle topic selection
  void _onTopicChanged(String? newValue) {
    setState(() {
      _selectedTopic = newValue;
      _showCompleteButton = false;
      _showQuestionPage = false;
      _showEarnPointsDialog = false;
      _isVideoInitialized = false;
      _resetQuiz();

      // Pause any active video
      _activeController?.pause();

      // Set active controller based on selection
      if (newValue == 'Medical Insurance') {
        _activeController = _medicalController;
        _medicalInitializeFuture.then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
          }
        });
      } else if (newValue == 'Critical Illness Insurance') {
        _activeController = _criticalController;
        _criticalInitializeFuture.then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
          }
        });
      } else if (newValue == 'Personal Accident Insurance') {
        _activeController = _personalController;
        _personalInitializeFuture.then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
          }
        });
      } else if (newValue == 'Mortgage Reducing Term Assurance (MRTA)') {
        _activeController = _mrtaController;
        _mrtaInitializeFuture.then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
          }
        });
      } else {
        _activeController = null;
      }
    });
  }

  // Reset quiz
  void _resetQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _showAnswerResult = false;
    _isAnswerCorrect = false;
    _score = 0;
    _quizCompleted = false;
  }

  // Handle video completion
  void _onVideoCompleted() {
    if (_activeController != null &&
        _activeController!.value.position >= const Duration(seconds: 5)) {
      setState(() {
        _showCompleteButton = true;
      });
    }
  }

  // Show earn points dialog
  void _showEarnPointsDialogFn() {
    setState(() {
      _showEarnPointsDialog = true;
      _activeController?.pause();
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
    // Update global points before returning
    userPoints += _score * 10;
    Navigator.pop(context, _score * 10); // Pass points back to goals page
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
    if (_currentQuestionIndex < _getQuestionsForTopic().length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _showAnswerResult = false;
      });
    } else {
      // Quiz completed
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  // Get questions for selected topic
  List<Map<String, dynamic>> _getQuestionsForTopic() {
    if (_selectedTopic == 'Medical Insurance') {
      return [
        {
          'question': 'What does medical insurance mainly cover?',
          'options': [
            'Car repairs',
            'Hospital and medical expenses',
            'House damage',
            'School fees'
          ],
          'correctAnswer': 1, // B - Hospital and medical expenses
        },
        {
          'question': 'Which situation is usually covered by medical insurance?',
          'options': [
            'Buying groceries',
            'Staying in a hospital for treatment',
            'Paying electricity bills',
            'Buying clothes'
          ],
          'correctAnswer': 1, // B - Staying in a hospital for treatment
        },
        {
          'question': 'Why do people buy medical insurance?',
          'options': [
            'To earn profit',
            'To reduce hospital costs',
            'To buy a new house',
            'To increase salary'
          ],
          'correctAnswer': 1, // B - To reduce hospital costs
        },
      ];
    } else if (_selectedTopic == 'Critical Illness Insurance') {
      return [
        {
          'question': 'What does critical illness insurance provide?',
          'options': [
            'Free groceries',
            'Cash payout if diagnosed with serious illness',
            'Car repairs',
            'Travel tickets'
          ],
          'correctAnswer': 1, // B - Cash payout if diagnosed with serious illness
        },
        {
          'question': 'Which of the following may be covered under critical illness insurance?',
          'options': [
            'Fever',
            'Heart attack',
            'Headache',
            'Cold'
          ],
          'correctAnswer': 1, // B - Heart attack
        },
        {
          'question': 'What is the purpose of critical illness insurance?',
          'options': [
            'To pay school fees',
            'To help with financial needs during serious illness',
            'To repair houses',
            'To buy cars'
          ],
          'correctAnswer': 1, // B - To help with financial needs during serious illness
        },
      ];
    } else if (_selectedTopic == 'Personal Accident Insurance') {
      return [
        {
          'question': 'What does personal accident insurance protect against?',
          'options': [
            'Car theft',
            'Injuries caused by accidents',
            'House fire',
            'Phone damage'
          ],
          'correctAnswer': 1, // B - Injuries caused by accidents
        },
        {
          'question': 'Which situation may be covered by personal accident insurance?',
          'options': [
            'Slipping and breaking a leg',
            'Buying a new laptop',
            'Paying rent',
            'Going on vacation'
          ],
          'correctAnswer': 0, // A - Slipping and breaking a leg
        },
        {
          'question': 'What benefit may personal accident insurance provide?',
          'options': [
            'Free food',
            'Compensation for injury or disability',
            'Discount on shopping',
            'Free travel'
          ],
          'correctAnswer': 1, // B - Compensation for injury or disability
        },
      ];
    } else {
      // Mortgage Reducing Term Assurance (MRTA) questions
      return [
        {
          'question': 'What does MRTA stand for?',
          'options': [
            'Mortgage Reducing Term Assurance',
            'Medical Risk Term Agreement',
            'Money Return Term Account',
            'Mortgage Repair Tax Assistance'
          ],
          'correctAnswer': 0, // A - Mortgage Reducing Term Assurance
        },
        {
          'question': 'What is the main purpose of MRTA?',
          'options': [
            'To protect a housing loan',
            'To buy a car',
            'To pay school fees',
            'To invest in stocks'
          ],
          'correctAnswer': 0, // A - To protect a housing loan
        },
        {
          'question': 'When is MRTA usually used?',
          'options': [
            'When buying a house with a loan',
            'When buying groceries',
            'When traveling overseas',
            'When starting a business'
          ],
          'correctAnswer': 0, // A - When buying a house with a loan
        },
      ];
    }
  }

  // Get current question
  Map<String, dynamic> _getCurrentQuestion() {
    return _getQuestionsForTopic()[_currentQuestionIndex];
  }

  // Get correct answer index
  int _getCurrentQuestionCorrectAnswer() {
    return _getCurrentQuestion()['correctAnswer'];
  }

  // Get topic emoji
  String _getTopicEmoji() {
    if (_selectedTopic == 'Medical Insurance') {
      return '🏥';
    } else if (_selectedTopic == 'Critical Illness Insurance') {
      return '💔';
    } else if (_selectedTopic == 'Personal Accident Insurance') {
      return '⚠️';
    } else if (_selectedTopic == 'Mortgage Reducing Term Assurance (MRTA)') {
      return '🏠💰';
    }
    return '📋';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      body: Column(
        children: [
          // Arc Header with MHuat text
          const ArcHeader(title: "MHuat"),

          // Title Section with Back Arrow
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            color: const Color(0xFFFEF7FF),
            child: Row(
              children: [
                // Back arrow
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context, 0),
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
                  "Insurance Protection Plans",
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
                                    prefixIcon: Icon(Icons.play_circle_fill, color: const Color(0xFF0D3A6D)), // Navy blue
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Video player section
                        if (_selectedTopic != null) ...[
                          // Show loading or video
                          if (!_isVideoInitialized)
                            Container(
                              height: 220,
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
                          else
                            Container(
                              height: 220,
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
                                    // Video player
                                    if (_activeController != null && _activeController!.value.isInitialized)
                                      AspectRatio(
                                        aspectRatio: _activeController!.value.aspectRatio,
                                        child: VideoPlayer(_activeController!),
                                      ),

                                    // Video controls overlay
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
                                              _activeController != null && _activeController!.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (_activeController!.value.isPlaying) {
                                                  _activeController!.pause();
                                                } else {
                                                  _activeController!.play();
                                                }
                                              });
                                            },
                                          ),
                                          if (_activeController != null)
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

                          // Please wait for 5 seconds section
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

                          // Video control buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isVideoInitialized
                                      ? () {
                                    setState(() {
                                      if (_activeController!.value.isPlaying) {
                                        _activeController!.pause();
                                      } else {
                                        _activeController!.play();
                                      }
                                    });

                                    _activeController!.addListener(() {
                                      if (_activeController!.value.position >= const Duration(seconds: 5)) {
                                        _onVideoCompleted();
                                      }
                                    });
                                  }
                                      : null,
                                  icon: Icon(
                                    _activeController != null && _activeController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  label: Text(
                                    _activeController != null && _activeController!.value.isPlaying
                                        ? 'Pause'
                                        : 'Play',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D3A6D), // Navy blue
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isVideoInitialized
                                      ? () {
                                    _activeController!.seekTo(Duration.zero);
                                    setState(() {
                                      _showCompleteButton = false;
                                    });
                                  }
                                      : null,
                                  icon: const Icon(Icons.replay),
                                  label: const Text('Replay'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Show Complete button after 5 seconds
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
                              // Header with back button and progress
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
                                      _selectedTopic ?? 'Insurance Protection Plans',
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
                                      '${_currentQuestionIndex + 1}/${_getQuestionsForTopic().length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Quiz completed view
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
                                  'You scored $_score/${_getQuestionsForTopic().length}',
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
                                    foregroundColor: const Color(0xFF0D3A6D), // Navy blue
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
                                // Question card
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
                                      // Topic icon and AI generated indicator
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0D3A6D).withValues(alpha: 0.1), // Navy blue
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
                                                  'Question ${_currentQuestionIndex + 1}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF0D3A6D), // Navy blue
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

                                      // Question text
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

                                      // Answer options
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
                                          backgroundColor = const Color(0xFF0D3A6D).withValues(alpha: 0.1); // Navy blue
                                        }

                                        BorderSide borderSide = BorderSide(
                                          color: isCorrect
                                              ? Colors.green
                                              : isWrong
                                              ? Colors.red
                                              : isSelected
                                              ? const Color(0xFF0D3A6D) // Navy blue
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
                                                          ? const Color(0xFF0D3A6D) // Navy blue
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
                                      }),

                                      const SizedBox(height: 20),

                                      // Check Answer or Next button
                                      if (!_showAnswerResult)
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _selectedAnswerIndex == null ? null : _checkAnswer,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF0D3A6D), // Navy blue
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
                                              backgroundColor: const Color(0xFF0D3A6D), // Navy blue
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Text(
                                              _currentQuestionIndex < _getQuestionsForTopic().length - 1
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

                // Earn Points Dialog Overlay
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
                                color: const Color(0xFF0D3A6D).withValues(alpha: 0.1), // Navy blue
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.emoji_events,
                                color: Color(0xFF0D3A6D), // Navy blue
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
                                color: const Color(0xFF0D3A6D).withValues(alpha: 0.1), // Navy blue
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.stars, color: Color(0xFF0D3A6D), size: 16), // Navy blue
                                  SizedBox(width: 4),
                                  Text(
                                    'Earn up to 30 points',
                                    style: TextStyle(
                                      color: Color(0xFF0D3A6D), // Navy blue
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
                                      _goBackToGoals(); // No points earned
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
                                      backgroundColor: const Color(0xFF0D3A6D), // Navy blue
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