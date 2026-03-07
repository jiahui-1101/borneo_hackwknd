import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';
import 'PurchaseNowPage.dart';
import 'insurance-goalpage/MyGoalsPage.dart'; // Import the MyGoalsPage
import 'ai_compare_coverage.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isInitialized = false;

  // Navy blue color
  final Color navyBlue = const Color(0xFF0D3A6D);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/video/basic_insurance.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        _isInitialized = true;
      });
      _controller.setLooping(false);
      _controller.setVolume(1.0);

      _controller.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    }).catchError((error) {
      print('Error initializing video: $error');
      setState(() {
        _isInitialized = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Method to pause video
  void _pauseVideo() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
  }

  // Modified navigation method to pause video before navigating
  void _navigateToPage(BuildContext context, Widget page) {
    _pauseVideo(); // Pause video before navigating
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF), // Match insurance theme
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with subtitle - matching Savings page format
              const Text(
                'Insurance',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Protect what matters most",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Tutorial Section
              const Text(
                'Tutorial',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              // Local Video Container
              _buildVideoPlayer(),

              const SizedBox(height: 16),

              // Video Control Row - with navy blue play button
              _buildVideoControls(),

              const SizedBox(height: 8),

              // Skip for Now Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _pauseVideo();
                      _showSkipMessage(context);
                    },
                    child: const Text(
                      'Skip for Now',
                      style: TextStyle(
                        color: Color(0xFF0D3A6D),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              ),

              const SizedBox(height: 12),

              // Three Action Buttons - perfectly aligned
              SizedBox(
                height: 130,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.account_balance_wallet,
                        label: 'AI Compare Coverage',
                        circleColor: Colors.purple.shade100,
                        iconColor: Colors.purple.shade800,
                        onTap: () {
                          _navigateToPage(context, const AiCompareCoveragePage());
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.flag,
                        label: 'My Goals',
                        circleColor: Colors.orange.shade100,
                        iconColor: Colors.orange.shade800,
                        onTap: () {
                          _navigateToPage(context, const MyGoalsPage());
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.health_and_safety,
                        label: 'Purchase\nNow',
                        circleColor: Colors.green.shade100,
                        iconColor: Colors.green.shade800,
                        onTap: () {
                          _navigateToPage(context, const PurchaseNowPage());
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Extract video player to separate widget
  Widget _buildVideoPlayer() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && _isInitialized) {
              // Use ValueListenableBuilder to listen to controller changes
              return ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, VideoPlayerValue value, child) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                // No setState needed here
                              },
                            ),
                            Text(
                              '${_formatDuration(value.position)} / ${_formatDuration(value.duration, isTotal: true)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Container(
              color: Colors.grey[300],
              child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text(
              'Error loading video',
              style: TextStyle(color: Colors.grey[700]),
              ),
              ],
              ),
              ),
              );
              } else {
              return Container(
              color: Colors.grey[300],
              child: const Center(
              child: CircularProgressIndicator(),
              ),
              );
              }
              },
        ),
      ),
    );
  }

  // Extract video controls to separate widget
  Widget _buildVideoControls() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, VideoPlayerValue value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                  // No setState needed here
                },
                icon: Icon(
                  value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 18,
                ),
                label: Text(
                  value.isPlaying ? 'Pause' : 'Play',
                  style: const TextStyle(fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navyBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _controller.seekTo(Duration.zero);
                  // No setState needed here
                },
                icon: const Icon(Icons.replay, size: 18),
                label: const Text(
                  'Replay',
                  style: TextStyle(fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method to format duration
  // Helper method to format duration - ALWAYS shows HH:MM:SS format
  // Helper method to format duration - ALWAYS shows HH:MM:SS format with proper padding
  // Helper method to format duration - ALWAYS shows HH:MM:SS for both
  String _formatDuration(Duration duration, {bool isTotal = false}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    // Always return HH:MM:SS format for both position and total
    return "$hours:$minutes:$seconds";
  }

  // Action button builder - matching savings page style
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color circleColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 130,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container with fixed positioning
              Container(
                height: 56,
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: circleColor,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Text with fixed height
              Container(
                height: 36,
                alignment: Alignment.topCenter,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSkipMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Skipped tutorial for now'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String pageName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$pageName coming soon!'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}