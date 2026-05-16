import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/detail_controller.dart';

class DetailPage extends StatelessWidget {
  final int productId;
  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailController());
    final authController = Get.find<AuthController>();
    final cartController = Get.find<CartController>();

    // Fetch detail saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDetail(productId);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4A90D9)),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF4A90D9),
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text('Detail Produk',
                  style: TextStyle(color: Colors.white)),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(controller.errorMessage.value,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchDetail(productId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                    ),
                    child: const Text('Coba Lagi',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        }

        final product = controller.product.value;
        if (product == null) return const SizedBox();

        return CustomScrollView(
          slivers: [
            // App Bar dengan gambar produk
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: const Color(0xFF4A90D9),
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                'Detail Produk',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF4A90D9)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image,
                            size: 64, color: Colors.grey),
                      ),
                    ),
                    // Gradient overlay
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black38],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama produk
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Brand & Kategori
                    Row(
                      children: [
                        _buildBadge(Icons.business_outlined, product.brand),
                        const SizedBox(width: 8),
                        _buildBadge(Icons.category_outlined,
                            product.category.capitalizeFirst ?? ''),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Harga, Rating, Stock
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90D9),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.inventory_2_outlined,
                            color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Stok: ${product.stock}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.green),
                        ),
                      ],
                    ),
                    if (product.discountPercentage > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Diskon ${product.discountPercentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const Divider(height: 32),

                    // Deskripsi
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(
                          fontSize: 14, height: 1.5, color: Colors.black87),
                    ),
                    const Divider(height: 32),

                    // Pilih Quantity
                    const Text(
                      'Jumlah',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Row(
                          children: [
                            // Tombol kurangi
                            _buildQtyButton(
                              icon: Icons.remove,
                              onTap: controller.decrement,
                              enabled: controller.qty.value > 1,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${controller.qty.value}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Tombol tambah
                            _buildQtyButton(
                              icon: Icons.add,
                              onTap: controller.increment,
                              enabled: controller.qty.value < product.stock,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '/ ${product.stock} tersedia',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        )),
                    const SizedBox(height: 24),

                    // Tombol Add to Cart
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => ElevatedButton.icon(
                            onPressed: product.stock == 0
                                ? null
                                : () async {
                                    await cartController.addToCart(
                                      product: product,
                                      qty: controller.qty.value,
                                      username:
                                          authController.currentUsername.value,
                                    );
                                    Get.snackbar(
                                      'Berhasil',
                                      '${product.title} ditambahkan ke keranjang',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          Colors.green.shade100,
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                            icon: const Icon(Icons.shopping_cart),
                            label: Text(
                              product.stock == 0
                                  ? 'Stok Habis'
                                  : 'Add to Cart (${controller.qty.value})',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: product.stock == 0
                                  ? Colors.grey
                                  : const Color(0xFF4A90D9),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          )),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4A90D9).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF4A90D9)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF4A90D9)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
