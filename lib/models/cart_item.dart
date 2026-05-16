import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  int productId;

  @HiveField(2)
  String productTitle;

  @HiveField(3)
  double productPrice;

  @HiveField(4)
  String productThumbnail;

  @HiveField(5)
  int quantity;

  @HiveField(6)
  int productStock;

  CartItem({
    required this.username,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productThumbnail,
    required this.quantity,
    required this.productStock,
  });
}
