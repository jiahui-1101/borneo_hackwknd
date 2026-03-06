import 'package:flutter/material.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'package:my_huat/features/spending/pages/retirement_result_page.dart';

export 'retirement_page.dart' show RetirementData;

class RetirementPage extends StatefulWidget {
  const RetirementPage({super.key});

  @override
  State<RetirementPage> createState() => _RetirementPageState();
}

class _RetirementPageState extends State<RetirementPage> {
  final Color navyBlue = const Color(0xFF0B3A76);

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;

  // Page 1: Personal Info controllers
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _retirementAgeController = TextEditingController();
  final TextEditingController _lifeExpectancyController = TextEditingController(text: '85');
  String? _gender;
  final List<String> _genders = ['Male', 'Female'];

  // Page 2: Income & Savings controllers
  final TextEditingController _currentIncomeController = TextEditingController();
  final TextEditingController _currentSavingsController = TextEditingController();
  final TextEditingController _monthlyContributionController = TextEditingController();

  // EPF Section
  bool _includeEpf = true;
  final TextEditingController _epfBalanceController = TextEditingController();
  final TextEditingController _epfEmployeeRateController = TextEditingController(text: '11');
  final TextEditingController _epfEmployerRateController = TextEditingController(text: '13');
  final TextEditingController _epfDividendRateController = TextEditingController(text: '5.5');

  // Page 3: Assumptions
  final TextEditingController _expectedReturnController = TextEditingController();
  final TextEditingController _inflationRateController = TextEditingController(text: '3.0');
  String? _riskTolerance;
  final List<String> _riskLevels = ['Conservative', 'Moderate', 'Aggressive'];

  // Page 4: Retirement Goals
  final TextEditingController _desiredIncomeController = TextEditingController();

  // Retirement Expenses
  double _housingExpense = 0;
  double _healthcareExpense = 0;
  double _foodExpense = 0;
  double _transportExpense = 0;
  double _utilitiesExpense = 0;
  double _insuranceExpense = 0;
  double _travelExpense = 0;
  double _entertainmentExpense = 0;

  // Health factors
  bool _isSmoker = false;
  bool _exercisesRegularly = true;

  @override
  void dispose() {
    _ageController.dispose();
    _retirementAgeController.dispose();
    _lifeExpectancyController.dispose();
    _currentIncomeController.dispose();
    _currentSavingsController.dispose();
    _monthlyContributionController.dispose();
    _epfBalanceController.dispose();
    _epfEmployeeRateController.dispose();
    _epfEmployerRateController.dispose();
    _epfDividendRateController.dispose();
    _expectedReturnController.dispose();
    _inflationRateController.dispose();
    _desiredIncomeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ArcHeader(title: "MHuat"),

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
                  'Retirement Planner',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3A76),
                  ),
                ),
              ],
            ),
          ),

          // Step Progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(4, (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index <= _currentStep ? navyBlue : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
          ),

          const SizedBox(height: 8),

          // Step Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getStepTitle(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: navyBlue,
                  ),
                ),
                Text(
                  'Step ${_currentStep + 1} of 4',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // PageView for steps
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: [
                  _buildPersonalInfoStep(),
                  _buildIncomeSavingsStep(),
                  _buildAssumptionsStep(),
                  _buildGoalsStep(),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: navyBlue,
                        side: BorderSide(color: navyBlue.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentStep == 3 ? _calculateAndNavigate : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navyBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_currentStep == 3 ? 'CALCULATE' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0: return 'Personal Information';
      case 1: return 'Income & Savings';
      case 2: return 'Assumptions';
      case 3: return 'Retirement Goals';
      default: return '';
    }
  }

  // Step 1: Personal Information
  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _ageController,
            label: 'Current Age',
            icon: Icons.person,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _retirementAgeController,
            label: 'Planned Retirement Age',
            icon: Icons.flag,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _lifeExpectancyController,
            label: 'Life Expectancy',
            icon: Icons.favorite,
            keyboardType: TextInputType.number,
            isRequired: false,
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              value: _gender,
              decoration: InputDecoration(
                labelText: 'Gender (Optional)',
                prefixIcon: Icon(Icons.wc, color: navyBlue),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: _genders.map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              )).toList(),
              onChanged: (value) => setState(() => _gender = value),
            ),
          ),
          const SizedBox(height: 16),

          // Health factors
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: navyBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Smoker'),
                  value: _isSmoker,
                  onChanged: (value) => setState(() => _isSmoker = value),
                  activeTrackColor: navyBlue,
                  activeThumbColor: navyBlue,
                ),
                SwitchListTile(
                  title: const Text('Exercise Regularly'),
                  value: _exercisesRegularly,
                  onChanged: (value) => setState(() => _exercisesRegularly = value),
                  activeTrackColor: navyBlue,
                  activeThumbColor: navyBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Income & Savings
  Widget _buildIncomeSavingsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _currentIncomeController,
            label: 'Current Monthly Income (RM)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
            prefix: 'RM ',
            isRequired: true,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _currentSavingsController,
            label: 'Current Retirement Savings (RM)',
            icon: Icons.account_balance_wallet,
            keyboardType: TextInputType.number,
            prefix: 'RM ',
            isRequired: true,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _monthlyContributionController,
            label: 'Monthly Contribution (RM)',
            icon: Icons.trending_up,
            keyboardType: TextInputType.number,
            prefix: 'RM ',
            isRequired: true,
          ),
          const SizedBox(height: 24),

          // EPF Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: navyBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: navyBlue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance, color: navyBlue),
                    const SizedBox(width: 8),
                    const Text('EPF/KWSP (Optional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Switch(
                      value: _includeEpf,
                      onChanged: (value) => setState(() => _includeEpf = value),
                      activeTrackColor: navyBlue,
                      activeThumbColor: navyBlue,
                    ),
                  ],
                ),
                if (_includeEpf) ...[
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _epfBalanceController,
                    label: 'Current EPF Balance (RM)',
                    icon: Icons.account_balance,
                    keyboardType: TextInputType.number,
                    prefix: 'RM ',
                    isRequired: false,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _epfEmployeeRateController,
                    label: 'Employee Contribution %',
                    icon: Icons.percent,
                    keyboardType: TextInputType.number,
                    suffix: '%',
                    isRequired: false,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _epfEmployerRateController,
                    label: 'Employer Contribution %',
                    icon: Icons.business,
                    keyboardType: TextInputType.number,
                    suffix: '%',
                    isRequired: false,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _epfDividendRateController,
                    label: 'EPF Dividend Rate %',
                    icon: Icons.trending_up,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    suffix: '%',
                    isRequired: false,
                  ),
                ],
              ],
            ),
          ),

          // Savings rate calculator
          if (_currentIncomeController.text.isNotEmpty && _monthlyContributionController.text.isNotEmpty)
            _buildSavingsRateCard(),
        ],
      ),
    );
  }

  // Step 3: Assumptions
  Widget _buildAssumptionsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _expectedReturnController,
            label: 'Expected Return Rate (%)',
            icon: Icons.percent,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            suffix: '%',
            isRequired: true,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _inflationRateController,
            label: 'Expected Inflation Rate (%)',
            icon: Icons.trending_down,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            suffix: '%',
            isRequired: false,
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              value: _riskTolerance,
              decoration: InputDecoration(
                labelText: 'Risk Tolerance (Optional)',
                prefixIcon: Icon(Icons.assessment, color: navyBlue),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: _riskLevels.map((risk) => DropdownMenuItem(
                value: risk,
                child: Text(risk),
              )).toList(),
              onChanged: (value) => setState(() => _riskTolerance = value),
            ),
          ),
        ],
      ),
    );
  }

  // Step 4: Retirement Goals
  Widget _buildGoalsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _desiredIncomeController,
            label: 'Desired Monthly Income in Retirement (RM)',
            icon: Icons.money,
            keyboardType: TextInputType.number,
            prefix: 'RM ',
            isRequired: true,
          ),
          const SizedBox(height: 24),

          const Text('Estimated Monthly Expenses in Retirement (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          _buildExpenseSlider('Housing', _housingExpense, 0, 5000, (val) => _housingExpense = val),
          _buildExpenseSlider('Healthcare', _healthcareExpense, 0, 2000, (val) => _healthcareExpense = val),
          _buildExpenseSlider('Food', _foodExpense, 0, 2000, (val) => _foodExpense = val),
          _buildExpenseSlider('Transport', _transportExpense, 0, 1500, (val) => _transportExpense = val),
          _buildExpenseSlider('Utilities', _utilitiesExpense, 0, 1000, (val) => _utilitiesExpense = val),
          _buildExpenseSlider('Insurance', _insuranceExpense, 0, 1000, (val) => _insuranceExpense = val),
          _buildExpenseSlider('Travel', _travelExpense, 0, 2000, (val) => _travelExpense = val),
          _buildExpenseSlider('Entertainment', _entertainmentExpense, 0, 1000, (val) => _entertainmentExpense = val),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: navyBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Estimated Expenses:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('RM ${_getTotalExpenses().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navyBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text('RM ${value.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 20,
          activeColor: navyBlue,
          onChanged: (val) => setState(() => onChanged(val)),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    String? prefix,
    String? suffix,
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (isRequired) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          final numValue = num.tryParse(value);
          if (numValue == null) {
            return 'Please enter a valid number';
          }
          if (numValue <= 0) {
            return 'Please enter a positive number';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        prefixIcon: Icon(icon, color: navyBlue),
        prefixText: prefix,
        suffixText: suffix,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: navyBlue, width: 2)
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildSavingsRateCard() {
    final income = double.tryParse(_currentIncomeController.text) ?? 0;
    final contribution = double.tryParse(_monthlyContributionController.text) ?? 0;
    if (income <= 0) return const SizedBox.shrink();

    final savingsRate = (contribution / income * 100);
    Color rateColor = savingsRate >= 15 ? Colors.green : Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: navyBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: navyBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Savings Rate:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${savingsRate.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: rateColor)),
          ]),
          const SizedBox(height: 4),
          Text(savingsRate < 15 ? 'Aim for 15-20% for comfortable retirement' : 'Good savings rate!',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  double _getTotalExpenses() {
    return _housingExpense + _healthcareExpense + _foodExpense + _transportExpense +
        _utilitiesExpense + _insuranceExpense + _travelExpense + _entertainmentExpense;
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  int _calculateLifeExpectancy() {
    int lifeExp = int.tryParse(_lifeExpectancyController.text) ?? 85;
    if (_isSmoker) lifeExp -= 8;
    if (_exercisesRegularly) lifeExp += 3;
    if (_gender == 'Female') lifeExp += 3;
    return lifeExp;
  }

  // PROPER NAVIGATION FUNCTION
  void _calculateAndNavigate() {
    // Validate form first
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields correctly'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Parse values
      final currentAge = int.parse(_ageController.text);
      final retirementAge = int.parse(_retirementAgeController.text);
      final currentIncome = double.parse(_currentIncomeController.text);
      final currentSavings = double.parse(_currentSavingsController.text);
      final monthlyContribution = double.parse(_monthlyContributionController.text);
      final expectedReturn = double.parse(_expectedReturnController.text);
      final desiredIncome = double.parse(_desiredIncomeController.text);

      // Validate retirement age > current age
      if (retirementAge <= currentAge) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retirement age must be greater than current age'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Create data object with CORRECT parameter names
      final data = RetirementData(
        currentAge: currentAge,
        retirementAge: retirementAge,
        lifeExpectancy: _calculateLifeExpectancy(),
        currentIncome: currentIncome,
        currentSavings: currentSavings,
        monthlyContribution: monthlyContribution,
        includeEpf: _includeEpf,
        epfBalance: double.tryParse(_epfBalanceController.text) ?? 0,
        epfEmployeeRate: double.tryParse(_epfEmployeeRateController.text) ?? 11,
        epfEmployerRate: double.tryParse(_epfEmployerRateController.text) ?? 13,
        epfDividendRate: double.tryParse(_epfDividendRateController.text) ?? 5.5,
        expectedReturn: expectedReturn / 100, // Convert percentage to decimal
        inflationRate: double.tryParse(_inflationRateController.text) ?? 3.0 / 100,
        riskTolerance: _riskTolerance ?? 'Moderate',
        desiredMonthlyIncome: desiredIncome, // FIXED: was 'desiredIncome'
        monthlyExpenses: _getTotalExpenses(), // FIXED: was 'totalExpenses'
      );

      // Navigate to result page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RetirementResultPage(data: data),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class RetirementData {
  final int currentAge;
  final int retirementAge;
  final int lifeExpectancy;
  final double currentIncome;
  final double currentSavings;
  final double monthlyContribution;
  final bool includeEpf;
  final double epfBalance;
  final double epfEmployeeRate;
  final double epfEmployerRate;
  final double epfDividendRate;
  final double expectedReturn;
  final double inflationRate;
  final String riskTolerance;
  final double desiredMonthlyIncome;
  final double monthlyExpenses;

  RetirementData({
    required this.currentAge,
    required this.retirementAge,
    required this.lifeExpectancy,
    required this.currentIncome,
    required this.currentSavings,
    required this.monthlyContribution,
    required this.includeEpf,
    required this.epfBalance,
    required this.epfEmployeeRate,
    required this.epfEmployerRate,
    required this.epfDividendRate,
    required this.expectedReturn,
    required this.inflationRate,
    required this.riskTolerance,
    required this.desiredMonthlyIncome,
    required this.monthlyExpenses,
  });
}