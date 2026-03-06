import 'package:flutter/material.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';

class RiskAssessmentPage extends StatefulWidget {
  const RiskAssessmentPage({super.key});

  @override
  State<RiskAssessmentPage> createState() => _RiskAssessmentPageState();
}

class _RiskAssessmentPageState extends State<RiskAssessmentPage> {
  int _currentQuestionIndex = 0;
  final Map<int, dynamic> _answers = {};

  // Define blue color to match BNPL page
  final Color navyBlue = const Color(0xFF0B3A76); // Updated to match InvestNowPage

  final List<Question> _questions = [
    Question(
      text: 'Do you expect to withdraw more than 5% of your investment portfolio every year?',
      type: QuestionType.yesNo,
    ),
    Question(
      text: 'Do you have any income or assets other than your savings? (Eg. Bond, Unit Trust, Stock, Property)',
      type: QuestionType.yesNo,
    ),
    Question(
      text: 'I am willing to take financial risks with my investments. Do you agree with the statement above?',
      type: QuestionType.agreement,
    ),
    Question(
      text: 'What is your preference when investing?',
      type: QuestionType.preference,
    ),
    Question(
      text: 'How much do you know about finance & investment concepts?',
      type: QuestionType.knowledge,
    ),
    Question(
      text: 'How much experience do you have in buying & selling investment products? (e.g. Unit trust, ETFs, Shares)',
      type: QuestionType.experience,
    ),
    Question(
      text: 'How risky do you think investing in the stock market is?',
      type: QuestionType.riskPerception,
    ),
    Question(
      text: 'What have you done in the past when you started losing money? Please answer based on your experience.',
      type: QuestionType.pastAction,
    ),
    Question(
      text: 'How long do you expect to invest?',
      type: QuestionType.investmentDuration,
    ),
  ];

  void _nextQuestion() {
    if (_answers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer before proceeding'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showResults();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assessment Complete'),
        content: Text('You have completed all ${_questions.length} questions! Your portfolio will now be generated.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to portfolio setup
            },
            child: Text('OK', style: TextStyle(color: navyBlue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Arc Header with title (matching MHuat pattern)
          const ArcHeader(title: "MHuat"),

          // Back button and Risk Assessment title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Risk Assessment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3A76),
                  ),
                ),
              ],
            ),
          ),

          // Progress Bar
          Container(
            width: double.infinity,
            height: 4,
            color: Colors.grey.shade200,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                color: navyBlue,
              ),
            ),
          ),

          // Question Number
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: navyBlue,
                  ),
                ),
                Text(
                  ' of ${_questions.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Question Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Text
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: navyBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: navyBlue.withOpacity(0.2)),
                    ),
                    child: Text(
                      question.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Answer Options
                  Expanded(
                    child: _buildAnswerOptions(question),
                  ),

                  // Navigation Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        if (_currentQuestionIndex > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _previousQuestion,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: navyBlue,
                                side: BorderSide(color: navyBlue.withOpacity(0.3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Previous'),
                            ),
                          ),
                        if (_currentQuestionIndex > 0) const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _nextQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: navyBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              _currentQuestionIndex == _questions.length - 1
                                  ? 'Submit'
                                  : 'Next',
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(Question question) {
    switch (question.type) {
      case QuestionType.yesNo:
        return _buildYesNoOptions();
      case QuestionType.agreement:
        return _buildAgreementOptions();
      case QuestionType.preference:
        return _buildPreferenceOptions();
      case QuestionType.knowledge:
        return _buildKnowledgeOptions();
      case QuestionType.experience:
        return _buildExperienceOptions();
      case QuestionType.riskPerception:
        return _buildRiskPerceptionOptions();
      case QuestionType.pastAction:
        return _buildPastActionOptions();
      case QuestionType.investmentDuration:
        return _buildDurationOptions();
    }
  }

  Widget _buildYesNoOptions() {
    return Column(
      children: [
        _buildAnswerCard(
          'Yes',
          _answers[_currentQuestionIndex] == 'Yes',
              () => setState(() => _answers[_currentQuestionIndex] = 'Yes'),
        ),
        const SizedBox(height: 12),
        _buildAnswerCard(
          'No',
          _answers[_currentQuestionIndex] == 'No',
              () => setState(() => _answers[_currentQuestionIndex] = 'No'),
        ),
      ],
    );
  }

  Widget _buildAgreementOptions() {
    final options = [
      'Strongly disagree',
      'Disagree',
      'Neutral',
      'Agree',
      'Strongly agree',
    ];
    return _buildOptionsList(options);
  }

  Widget _buildPreferenceOptions() {
    final options = [
      'Maximize safety',
      'Mostly safety',
      'Mix of safety & return',
      'Mostly return',
      'Maximize return',
    ];
    return _buildOptionsList(options);
  }

  Widget _buildKnowledgeOptions() {
    final options = [
      'Not at all knowledgeable',
      'Minimally knowledgeable',
      'Moderately knowledgeable',
      'Competent',
      'Very knowledgeable',
    ];
    return _buildOptionsList(options);
  }

  Widget _buildExperienceOptions() {
    final options = [
      'No experience',
      'Very little experience',
      'Some experience',
      'Quite experienced',
      'Very experienced',
    ];
    return _buildOptionsList(options);
  }

  Widget _buildRiskPerceptionOptions() {
    final options = [
      'Very Risky',
      'Somewhat Risky',
      'Neutral',
      'Somewhat Safe',
      'Very Safe',
    ];
    return _buildOptionsList(options);
  }

  Widget _buildPastActionOptions() {
    final options = [
      'Sold Investment',
      'Did Nothing',
      'Purchased More',
    ];
    return _buildOptionsList(options);
  }

  Widget _buildDurationOptions() {
    final options = [
      'Less than 5 years',
      '5 - 10 years',
      'More than 10 years',
    ];
    return _buildOptionsList(options);
  }

  Widget _buildOptionsList(List<String> options) {
    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildAnswerCard(
            option,
            _answers[_currentQuestionIndex] == option,
                () => setState(() => _answers[_currentQuestionIndex] = option),
          ),
        );
      },
    );
  }

  Widget _buildAnswerCard(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? navyBlue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? navyBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? navyBlue : Colors.grey.shade400,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? navyBlue : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum QuestionType {
  yesNo,
  agreement,
  preference,
  knowledge,
  experience,
  riskPerception,
  pastAction,
  investmentDuration,
}

class Question {
  final String text;
  final QuestionType type;

  Question({
    required this.text,
    required this.type,
  });
}