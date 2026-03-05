// lib/services/points_service.dart
class PointsService {
  // Private constructor
  PointsService._privateConstructor();

  // Singleton instance
  static final PointsService _instance = PointsService._privateConstructor();

  // Factory constructor to return the same instance
  factory PointsService() {
    return _instance;
  }

  // Points variable
  int _points = 0;

  int get points => _points;

  void addPoints(int pointsToAdd) {
    if (pointsToAdd > 0) {
      _points += pointsToAdd;
    }
  }

  void resetPoints() {
    _points = 0;
  }
}