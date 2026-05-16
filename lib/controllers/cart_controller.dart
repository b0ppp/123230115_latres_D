import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;

  Box<CartItem> get _box => Hive.box<CartItem>('cart');

  /// Muat item cart khusus untuk username yang sedang login
  void loadCartForUser(String username) {
    cartItems.value = _box.values
        .where((item) => item.username == username)
        .toList();
  }

  /// Tambah produk ke cart. Jika sudah ada, update qty-nya.
  Future<void> addToCart({
    required Product product,
    required int qty,
    required String username,
  }) async {
    // Cari entry yang sudah ada untuk produk & user ini
    CartItem? existing;
    for (final item in _box.values) {
      if (item.username == username && item.productId == product.id) {
        existing = item;
        break;
      }
    }

    if (existing != null) {
      // Jumlahkan qty, pastikan tidak melebihi stok
      final newQty = (existing.quantity + qty).clamp(1, product.stock);
      existing.quantity = newQty;
      await existing.save();
    } else {
      await _box.add(CartItem(
        username: username,
        productId: product.id,
        productTitle: product.title,
        productPrice: product.price,
        productThumbnail: product.thumbnail,
        quantity: qty,
        productStock: product.stock,
      ));
    }
    loadCartForUser(username);
  }

  /// Hapus item dari cart
  Future<void> removeFromCart(CartItem item, String username) async {
    await item.delete();
    loadCartForUser(username);
  }

  /// Total harga semua item di cart
  double get totalPrice {
    return cartItems.fold(
        0.0, (sum, item) => sum + (item.productPrice * item.quantity));
  }
}
