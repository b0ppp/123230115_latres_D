import 'package:get/get.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class DetailController extends GetxController {
  final product = Rxn<Product>();
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final qty = 1.obs;

  Future<void> fetchDetail(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    qty.value = 1;
    try {
      final result = await ApiService.getProductDetail(id);
      product.value = result;
    } catch (e) {
      errorMessage.value = 'Gagal memuat detail produk. Periksa koneksi.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Tambah qty, maksimal = stock produk
  void increment() {
    final stock = product.value?.stock ?? 1;
    if (qty.value < stock) qty.value++;
  }

  /// Kurangi qty, minimal = 1
  void decrement() {
    if (qty.value > 1) qty.value--;
  }
}
