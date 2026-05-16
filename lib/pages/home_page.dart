import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import 'detail_page.dart';
import 'cart_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final productController = Get.find<ProductController>();
    final cartController = Get.find<CartController>();

    // Muat cart untuk user yang sedang login
    ever(authController.currentUsername, (username) {
      cartController.loadCartForUser(username);
    });

    // Panggil sekali saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.loadCartForUser(authController.currentUsername.value);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90D9),
        title: Obx(() => Text(
              'Hi, ${authController.currentUsername.value}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )),
        actions: [
          // Tombol Cart
          Obx(() {
            final count = cartController.cartItems.length;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white),
                  onPressed: () => Get.to(() => const CartPage()),
                ),
                if (count > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4A90D9)),
          );
        }

        if (productController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  productController.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: productController.fetchProducts,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        final products = productController.products;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF0F4FF),
              child: Text(
                '${products.length} Produk Tersedia',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
            // List produk
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF4A90D9),
                onRefresh: productController.fetchProducts,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () => Get.to(() => DetailPage(productId: product.id)),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Row(
                          children: [
                            // Thumbnail
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: product.thumbnail,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[100],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF4A90D9),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[100],
                                  child: const Icon(Icons.broken_image,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            // Info produk
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.category.capitalizeFirst ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF4A90D9),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                size: 14,
                                                color: Colors.amber),
                                            const SizedBox(width: 2),
                                            Text(
                                              product.rating
                                                  .toStringAsFixed(1),
                                              style: const TextStyle(
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.chevron_right,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
