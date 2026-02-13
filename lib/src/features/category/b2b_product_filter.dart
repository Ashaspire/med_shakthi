class B2BProductFilter {
  String? sortBy; // price_low, price_high, name_az, name_za, expiry_soon
  double? minPrice, maxPrice;
  bool expiry1Month = false;
  bool expiry3Months = false;
  bool expiry6Months = false;
  bool expiry12Months = false;
  bool lowStock = false;
  bool outOfStock = false;
  bool availableOnly = false;
  double? minRating;
  List<String> selectedBrands = [];

  B2BProductFilter();

  B2BProductFilter copyWith({
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    bool? expiry1Month,
    bool? expiry3Months,
    bool? expiry6Months,
    bool? expiry12Months,
    bool? lowStock,
    bool? outOfStock,
    bool? availableOnly,
    double? minRating,
    List<String>? selectedBrands,
  }) {
    return B2BProductFilter()
      ..sortBy = sortBy ?? this.sortBy
      ..minPrice = minPrice ?? this.minPrice
      ..maxPrice = maxPrice ?? this.maxPrice
      ..expiry1Month = expiry1Month ?? this.expiry1Month
      ..expiry3Months = expiry3Months ?? this.expiry3Months
      ..expiry6Months = expiry6Months ?? this.expiry6Months
      ..expiry12Months = expiry12Months ?? this.expiry12Months
      ..lowStock = lowStock ?? this.lowStock
      ..outOfStock = outOfStock ?? this.outOfStock
      ..availableOnly = availableOnly ?? this.availableOnly
      ..minRating = minRating ?? this.minRating
      ..selectedBrands = selectedBrands ?? List.from(this.selectedBrands);
  }

  DateTime? get expiryBefore {
    final now = DateTime.now();
    if (expiry1Month) return DateTime(now.year, now.month + 1, now.day);
    if (expiry3Months) return DateTime(now.year, now.month + 3, now.day);
    if (expiry6Months) return DateTime(now.year, now.month + 6, now.day);
    if (expiry12Months) return DateTime(now.year, now.month + 12, now.day);
    return null;
  }
}
