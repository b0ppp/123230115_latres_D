import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90D9),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        final items = cartController.cartItems;

        if (items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Keranjang masih kosong',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tambahkan produk dari halaman detail',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Info user
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Cart milik: ${authController.currentUsername.value}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${items.length} item',
                    style: const TextStyle(
                      color: Color(0xFF4A90D9),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // List item cart
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item.productThumbnail,
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 75,
                                height: 75,
                                color: Colors.grey[100],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF4A90D9),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 75,
                                height: 75,
                                color: Colors.grey[100],
                                child: const Icon(Icons.broken_image,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Info item
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${item.productPrice.toStringAsFixed(2)} x ${item.quantity}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Subtotal: \$${(item.productPrice * item.quantity).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Color(0xFF4A90D9),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Tombol hapus
                          IconButton(
                            onPressed: () async {
                              final confirm = await Get.dialog<bool>(
                                AlertDialog(
                                  title: const Text('Hapus Item'),
                                  content: Text(
                                      'Hapus "${item.productTitle}" dari keranjang?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () => Get.back(result: true),
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.red),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await cartController.removeFromCart(
                                  item,
                                  authController.currentUsername.value,
                                );
                              }
                            },
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Total harga
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() => Text(
                        '\$${cartController.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A90D9),
                        ),
                      )),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
