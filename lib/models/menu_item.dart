class MenuItem {
  final int itemId;
  final String itemName;
  final int catId;
  final int menuId;

  MenuItem({
    required this.itemId,
    required this.itemName,
    required this.catId,
    required this.menuId,
  });

  factory MenuItem.fromMap(Map<String, dynamic> m) => MenuItem(
    itemId: m['itemId'] as int,
    itemName: m['itemName'] as String,
    catId: m['catId'] as int,
    menuId: m['menuId'] as int,
  );

  Map<String, dynamic> toMap() => {
    'itemId': itemId,
    'itemName': itemName,
    'catId': catId,
    'menuId': menuId,
  };
}
