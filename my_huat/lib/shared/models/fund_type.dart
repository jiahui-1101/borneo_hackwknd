enum FundType { insurance, saving, investment }

extension FundTypeExtension on FundType {
  String get displayName {
    switch (this) {
      case FundType.insurance:
        return 'Insurance';
      case FundType.saving:
        return 'Saving';
      case FundType.investment:
        return 'Investment';
    }
  }

  // Example current balances – replace with real data later
  double get currentBalance {
    switch (this) {
      case FundType.insurance:
        return 1250.0;
      case FundType.saving:
        return 3400.0;
      case FundType.investment:
        return 500.0;
    }
  }
}