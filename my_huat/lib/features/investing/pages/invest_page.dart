import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InvestPage extends StatefulWidget {
  const InvestPage({super.key});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    // Extract video ID from the YouTube link
    // https://www.youtube.com/watch?v=qIw-yFC-HNU
    String videoId = 'qIw-yFC-HNU';

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );

    _controller.addListener(() {
      if (_controller.value.isReady && !_isPlayerReady) {
        setState(() {
          _isPlayerReady = true;
        });
      }
    });
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

                // YouTube Video Container
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
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blue,
                      progressColors: ProgressBarColors(
                        playedColor: Colors.blue,
                        handleColor: Colors.blueAccent,
                      ),
                      onReady: () {
                        print('Player is ready');
                      },
                      bottomActions: [
                        CurrentPosition(),
                        ProgressBar(
                          isExpanded: true,
                          colors: ProgressBarColors(
                            playedColor: Colors.blue,
                            handleColor: Colors.blue,
                          ),
                        ),
                        RemainingDuration(),
                        FullScreenButton(),
                      ],
                    ),
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

                // Three Identical Buttons with Icons and Text at Same Height
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.account_balance_wallet,
                      label: 'Set Up\nPortfolio',
                      color: Colors.purple,
                      onTap: () {
                        _showActionMessage(context, 'Set Up Portfolio');
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.flag,
                      label: 'My Goals',
                      color: Colors.orange,
                      onTap: () {
                        _showActionMessage(context, 'My Goals');
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.trending_up,
                      label: 'Invest\nNow',
                      color: Colors.green,
                      onTap: () {
                        _showActionMessage(context, 'Invest Now');
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

  // Custom widget for action buttons with icons and text at SAME HEIGHT
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
            // Icon at exact same position for all buttons (25px from top)
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

            // Text at exact same position for all buttons (85px from top)
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

  void _showActionMessage(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action tapped'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}