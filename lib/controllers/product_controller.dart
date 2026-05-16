import 'package:get/get.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final products = <Product>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await ApiService.getProducts();
      products.value = result;
    } catch (e) {
      errorMessage.value = 'Gagal memuat produk. Periksa koneksi internet.';
    } finally {
      isLoading.value = false;
    }
  }
}
