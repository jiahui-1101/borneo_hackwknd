import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._privateConstructor();
  factory SoundService() => _instance;
  SoundService._privateConstructor();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Play points earned sound
  Future<void> playPointsEarnedSound() async {
    try {
      await _audioPlayer.play(AssetSource('sound/sound5.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Play success sound
  Future<void> playSuccessSound() async {
    try {
      await _audioPlayer.play(AssetSource('sound/sound5.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Play coin sound
  Future<void> playCoinSound() async {
    try {
      await _audioPlayer.play(AssetSource('sound/sound5.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Dispose audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}