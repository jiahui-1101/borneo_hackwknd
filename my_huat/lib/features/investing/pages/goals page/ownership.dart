// features/investing/goals/ownership_investments.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:my_huat/shared/widgets/arc_header.dart'; // Add this import

class OwnershipInvestmentsPage extends StatefulWidget {
  const OwnershipInvestmentsPage({super.key});

  @override
  State<OwnershipInvestmentsPage> createState() => _OwnershipInvestmentsPageState();
}

class _OwnershipInvestmentsPageState extends State<OwnershipInvestmentsPage> {
  // Dropdown selection
  String? _selectedTopic;
  final List<String> _topics = [
    'Stocks',
    'Real Estate Investment Trusts (REITs)',
    'Exchange-Traded Fund (ETF)',
    'Unit Trust'
  ];

  // Video players - lazy initialization
  VideoPlayerController? _stocksController;
  VideoPlayerController? _reitController;
  VideoPlayerController? _etfController;
  VideoPlayerController? _unitTrustController;

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
    _stocksController?.dispose();
    _reitController?.dispose();
    _etfController?.dispose();
    _unitTrustController?.dispose();
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

  // Lazy initialize stocks video
  Future<void> _initStocksVideo() async {
    if (_stocksController != null) return;

    setState(() {
      _isLoadingVideo = true;
    });

    _stocksController = VideoPlayerController.asset('assets/video/Stocks.mp4');

    await _initVideo(_stocksController!);

    if (mounted) {
      setState(() {
        _isLoadingVideo = false;
      });
    }
  }

  // Lazy initialize REIT video
  Future<void> _initREITVideo() async {
    if (_reitController != null) return;

    setState(() {
      _isLoadingVideo = true;
    });

    _reitController = VideoPlayerController.asset('assets/video/REIT.mp4');

    await _initVideo(_reitController!);

    if (mounted) {
      setState(() {
        _isLoadingVideo = false;
      });
    }
  }

  // Lazy initialize ETF video
  Future<void> _initETFVideo() async {
    if (_etfController != null) return;

    setState(() {
      _isLoadingVideo = true;
    });

    _etfController = VideoPlayerController.asset('assets/video/ETF.mp4');

    await _initVideo(_etfController!);

    if (mounted) {
      setState(() {
        _isLoadingVideo = false;
      });
    }
  }

  // Lazy initialize Unit Trust video
  Future<void> _initUnitTrustVideo() async {
    if (_unitTrustController != null) return;

    setState(() {
      _isLoadingVideo = true;
    });

    _unitTrustController = VideoPlayerController.asset('assets/video/Unit_Trust.mp4');

    await _initVideo(_unitTrustController!);

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

    if (newValue == 'Stocks') {
      _initStocksVideo().then((_) {
        if (mounted && _stocksController != null) {
          setState(() {
            _activeController = _stocksController;
            _isVideoInitialized = true;
          });
        }
      });
    } else if (newValue == 'Real Estate Investment Trusts (REITs)') {
      _initREITVideo().then((_) {
        if (mounted && _reitController != null) {
          setState(() {
            _activeController = _reitController;
            _isVideoInitialized = true;
          });
        }
      });
    } else if (newValue == 'Exchange-Traded Fund (ETF)') {
      _initETFVideo().then((_) {
        if (mounted && _etfController != null) {
          setState(() {
            _activeController = _etfController;
            _isVideoInitialized = true;
          });
        }
      });
    } else if (newValue == 'Unit Trust') {
      _initUnitTrustVideo().then((_) {
        if (mounted && _unitTrustController != null) {
          setState(() {
            _activeController = _unitTrustController;
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
    if (_selectedTopic == 'Stocks') return 0;
    if (_selectedTopic == 'Real Estate Investment Trusts (REITs)') return 3;
    if (_selectedTopic == 'Exchange-Traded Fund (ETF)') return 6;
    if (_selectedTopic == 'Unit Trust') return 9;
    return 0;
  }

  // Get ending index for selected topic
  int _getEndingIndexForTopic() {
    if (_selectedTopic == 'Stocks') return 2;
    if (_selectedTopic == 'Real Estate Investment Trusts (REITs)') return 5;
    if (_selectedTopic == 'Exchange-Traded Fund (ETF)') return 8;
    if (_selectedTopic == 'Unit Trust') return 11;
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
      // Stocks Questions (0-2)
      {
        'topic': 'Stocks',
        'question': 'What is a stock?',
        'options': [
          'Loan given to bank',
          'Ownership share in a company',
          'Type of savings account',
          'Insurance product'
        ],
        'correctAnswer': 1,
      },
      {
        'topic': 'Stocks',
        'question': 'When you buy stocks, you are usually:',
        'options': [
          'Borrowing money',
          'Owning part of the company',
          'Paying tax only',
          'Depositing money in bank'
        ],
        'correctAnswer': 1,
      },
      {
        'topic': 'Stocks',
        'question': 'Stock price is mainly affected by:',
        'options': [
          'Company performance and market demand',
          'Colour of the stock certificate',
          'Age of investor',
          'Number of banks'
        ],
        'correctAnswer': 0,
      },

      // REIT Questions (3-5)
      {
        'topic': 'REIT',
        'question': 'REIT mainly invests in:',
        'options': [
          'Technology software',
          'Real estate properties',
          'Gold only',
          'Bank loans'
        ],
        'correctAnswer': 1,
      },
      {
        'topic': 'REIT',
        'question': 'REIT usually gives income through:',
        'options': [
          'Rent from properties',
          'Lottery',
          'Government subsidy',
          'Salary'
        ],
        'correctAnswer': 0,
      },
      {
        'topic': 'REIT',
        'question': 'REIT is suitable for investors who want:',
        'options': [
          'Fast high-risk trading only',
          'Regular income with moderate risk',
          'No return investment',
          'Only short-term loss'
        ],
        'correctAnswer': 1,
      },

      // ETF Questions (6-8)
      {
        'topic': 'ETF',
        'question': 'ETF is a fund that:',
        'options': [
          'Invests in many assets together',
          'Invests in one company only',
          'Gives bank interest',
          'Is not traded in market'
        ],
        'correctAnswer': 0,
      },
      {
        'topic': 'ETF',
        'question': 'ETF can be bought and sold:',
        'options': [
          'Only once per year',
          'In stock market during trading hours',
          'Only at bank counter',
          'By government approval only'
        ],
        'correctAnswer': 1,
      },
      {
        'topic': 'ETF',
        'question': 'ETF helps investors by:',
        'options': [
          'Providing diversification',
          'Increasing tax rate',
          'Removing investment risk completely',
          'Locking money permanently'
        ],
        'correctAnswer': 0,
      },

      // Unit Trust Questions (9-11)
      {
        'topic': 'Unit Trust',
        'question': 'Unit trust is managed by:',
        'options': [
          'Professional fund manager',
          'Random investor',
          'Bank teller only',
          'Government school'
        ],
        'correctAnswer': 0,
      },
      {
        'topic': 'Unit Trust',
        'question': 'Unit trust investment is suitable for beginners because:',
        'options': [
          'It is professionally managed',
          'It has no risk at all',
          'It guarantees rich instantly',
          'It cannot be withdrawn'
        ],
        'correctAnswer': 0,
      },
      {
        'topic': 'Unit Trust',
        'question': 'Unit trust usually invests in:',
        'options': [
          'Mix of stocks, bonds, or other assets',
          'Only one property',
          'Only cash at home',
          'Personal phone'
        ],
        'correctAnswer': 0,
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
    if (_selectedTopic == 'Stocks') return '📈';
    if (_selectedTopic == 'Real Estate Investment Trusts (REITs)') return '🏢';
    if (_selectedTopic == 'Exchange-Traded Fund (ETF)') return '📊';
    if (_selectedTopic == 'Unit Trust') return '💰';
    return '📈';
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
                  "Ownership",
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
                                      _selectedTopic ?? 'Ownership Investments',
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