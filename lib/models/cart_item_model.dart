class CartItem {
  final int id;
  final String title;
  final String size;
  final double unitPriceInclTax;
  int qty;

  CartItem({
    required this.id,
    required this.title,
    required this.unitPriceInclTax,
    this.size = '',
    this.qty = 1,
  });

  String get fullTitle => size.isEmpty ? title : '$title ($size)';
  String get key => '$id-$size';
}
