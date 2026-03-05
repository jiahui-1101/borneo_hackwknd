// features/investing/pages/invest_page.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'goals page/goals.dart';
import 'portfolio_setup.dart';
import 'investnow.dart';

class InvestPage extends StatefulWidget {
  const InvestPage({super.key});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/basic_investing.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(false);
    _controller.setVolume(1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Rising Chart Icon
                Row(
                  children: [
                    const Text(
                      'Invest',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.trending_up,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tutorial Section
                const Text(
                  'Tutorial',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Local Video Container
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
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
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
                                      Colors.black.withValues(alpha: 0.5),
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        _controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _controller.value.isPlaying
                                              ? _controller.pause()
                                              : _controller.play();
                                        });
                                      },
                                    ),
                                    Text(
                                      '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
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
                ),

                // Video Control Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        label: Text(
                          _controller.value.isPlaying ? 'Pause' : 'Play',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          _controller.seekTo(Duration.zero);
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
                ),

                // Skip for Now Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _showSkipMessage(context);
                      },
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Skip for Now'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Action Buttons Section
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // Three Buttons with Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.account_balance_wallet,
                      label: 'Set Up\nPortfolio',
                      color: Colors.purple,
                      onTap: () {
                        _navigateToPage(context, const PortfolioSetupPage());
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.flag,
                      label: 'My Goals',
                      color: Colors.orange,
                      onTap: () {
                        _navigateToPage(context, const MyGoalsPage());
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.trending_up,
                      label: 'Invest\nNow',
                      color: Colors.green,
                      onTap: () {
                        _navigateToPage(context, const InvestNowPage());
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  // Custom widget for action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 25,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 85,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ],
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}