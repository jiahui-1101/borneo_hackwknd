import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/widgets/arc_header.dart';

class AiCompareCoveragePage extends StatefulWidget {
  const AiCompareCoveragePage({super.key});

  @override
  State<AiCompareCoveragePage> createState() => _AiCompareCoveragePageState();
}

class _AiCompareCoveragePageState extends State<AiCompareCoveragePage> {
  final ImagePicker _picker = ImagePicker();
  final Color navyBlue = const Color(0xFF0D3A6D);

  // Insurance A
  File? _imageA;
  String _linkA = '';

  // Insurance B
  File? _imageB;
  String _linkB = '';

  // Analysis result
  String? _analysisResult;
  bool _isLoading = false;

  /// Pick image from camera or gallery for the specified insurance (A or B)
  Future<void> _pickImage(ImageSource source, bool isA) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isA) {
          _imageA = File(pickedFile.path);
        } else {
          _imageB = File(pickedFile.path);
        }
      });
    }
  }

  /// Show bottom sheet to choose image source
  void _showOptions(bool isA) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, isA);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('From Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, isA);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Simulate AI comparison (replace with actual Vertex AI call)
  Future<void> _compare() async {
    // Basic validation: at least one input method per insurance
    if ((_imageA == null && _linkA.isEmpty) || (_imageB == null && _linkB.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide an image or link for both insurances.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    // TODO: Replace with actual Firebase Vertex AI integration
    await Future.delayed(const Duration(seconds: 3));

    // Mock structured result (each line: description|advantageTag)
    setState(() {
      _isLoading = false;
      _analysisResult = '''
Coverage Type: A covers inpatient & outpatient; B covers inpatient only|A优势
Annual Limit: A RM1,000,000; B RM500,000|A优势
Critical Illness: A covers 36 conditions; B covers 30|A优势
Dental Benefits: A not covered; B covered|B优势
Waiting Period: A 30 days; B 60 days|A优势
Premium: A RM2,400/yr; B RM1,800/yr|B优势
''';
    });
  }

  /// Build list of comparison items from result string
  List<Widget> _buildResultItems() {
    if (_analysisResult == null) return [];
    final lines = _analysisResult!.split('\n').where((line) => line.trim().isNotEmpty);
    return lines.map((line) {
      final parts = line.split('|');
      final description = parts[0];
      final advantage = parts.length > 1 ? parts[1] : '';

      Color iconColor;
      IconData icon;
      String advantageText = '';

      if (advantage.contains('A优势')) {
        iconColor = Colors.green;
        icon = Icons.check_circle;
        advantageText = 'A better';
      } else if (advantage.contains('B优势')) {
        iconColor = Colors.orange;
        icon = Icons.check_circle;
        advantageText = 'B better';
      } else {
        iconColor = Colors.grey;
        icon = Icons.info;
        advantageText = 'Info';
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                  if (advantageText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        advantageText,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: iconColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ArcHeader(title: 'MHuat'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Compare Coverage',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navyBlue),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Insurance A card
                  _buildInsuranceCard(
                    title: 'Insurance A',
                    image: _imageA,
                    link: _linkA,
                    onTapImage: () => _showOptions(true),
                    onLinkChanged: (value) => _linkA = value,
                  ),
                  const SizedBox(height: 20),

                  // Insurance B card
                  _buildInsuranceCard(
                    title: 'Insurance B',
                    image: _imageB,
                    link: _linkB,
                    onTapImage: () => _showOptions(false),
                    onLinkChanged: (value) => _linkB = value,
                  ),
                  const SizedBox(height: 30),

                  // Compare button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _compare,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navyBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'COMPARE',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Loading indicator with AI thinking message
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: Color(0xFF0D3A6D)),
                          SizedBox(height: 16),
                          Text(
                            'AI is analyzing your documents...',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                  // Analysis result
                  if (_analysisResult != null && !_isLoading)
                    Card(
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.auto_awesome, color: Color(0xFF0D3A6D), size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'Comparison Result',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ..._buildResultItems(),
                          ],
                        ),
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

  /// Reusable insurance card with circular upload area and link input
  Widget _buildInsuranceCard({
    required String title,
    required File? image,
    required String link,
    required VoidCallback onTapImage,
    required ValueChanged<String> onLinkChanged,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D)),
            ),
            const SizedBox(height: 16),

            // Circular image picker
            Center(
              child: GestureDetector(
                onTap: onTapImage,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: image != null ? FileImage(image) : null,
                    child: image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 24, color: navyBlue),
                              const SizedBox(height: 4),
                              const Text("Upload", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Link input field
            TextField(
              decoration: InputDecoration(
                labelText: 'Or paste link (PDF/Image)',
                prefixIcon: Icon(Icons.link, color: navyBlue),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: navyBlue, width: 2),
                ),
              ),
              onChanged: onLinkChanged,
            ),
          ],
        ),
      ),
    );
  }
}