import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final SoundService _instance = SoundService._privateConstructor();
  factory SoundService() => _instance;
  SoundService._privateConstructor();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  // Initialize the audio player with proper settings
  Future<void> _initAudioPlayer() async {
    if (!_isInitialized) {
      try {
        // Set release mode to stop when playback completes
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);

        // Set player mode (important for iOS)
        await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);

        _isInitialized = true;
        print('Audio player initialized successfully');
      } catch (e) {
        print('Error initializing audio player: $e');
      }
    }
  }

  // Play points earned sound
  Future<void> playPointsEarnedSound() async {
    await _initAudioPlayer();

    try {
      print('Attempting to play sound from assets...');

      // Play the sound - don't assign result if it's void
      await _audioPlayer.play(AssetSource('sound/sound5.mp3'));

      print('Sound play attempted successfully');

    } on PlatformException catch (e) {
      print('Platform error playing sound: $e');

      // Try alternative approach
      try {
        await _playWithDeviceFileAlternative();
      } catch (e2) {
        print('Alternative method also failed: $e2');
      }

    } catch (e) {
      print('Unexpected error playing sound: $e');
    }
  }

  // Alternative method using device file
  Future<void> _playWithDeviceFileAlternative() async {
    try {
      final player = AudioPlayer();
      await player.setSource(AssetSource('sound/sound5.mp3'));
      await player.resume();
      print('Alternative playback attempted');
    } catch (e) {
      print('Alternative playback failed: $e');
    }
  }

  // Play success sound
  Future<void> playSuccessSound() async {
    await playPointsEarnedSound();
  }

  // Play coin sound
  Future<void> playCoinSound() async {
    await playPointsEarnedSound();
  }

  // Test method to verify sound is working
  Future<void> testSound() async {
    print('Running sound test...');
    await playPointsEarnedSound();
  }

  // Check if sound file exists in assets
  Future<bool> checkSoundFileExists() async {
    try {
      await rootBundle.load('assets/sound/sound5.mp3');
      print('Sound file found in assets');
      return true;
    } catch (e) {
      print('Sound file NOT found in assets: $e');
      return false;
    }
  }

  // Dispose audio player
  void dispose() {
    _audioPlayer.dispose();
    print('Audio player disposed');
  }
}