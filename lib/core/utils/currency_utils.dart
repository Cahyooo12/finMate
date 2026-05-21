class CurrencyUtils {
  static String formatCurrency(double amount, {String symbol = 'Rp'}) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
    return '$symbol $formatted,-';
  }

  static String formatCurrencyCompact(double amount, {String symbol = 'Rp'}) {
    if (amount >= 1000000) {
      return '$symbol ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$symbol ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '$symbol ${amount.toStringAsFixed(0)}';
  }

  static double parseCurrency(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }
}
