import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller di sini agar bisa diakses oleh child pages
    Get.put(ProductController());
    Get.put(CartController());

    final currentIndex = 0.obs;

    final pages = [
      const HomePage(),
      const ProfilePage(),
    ];

    return Obx(() => Scaffold(
          body: pages[currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex.value,
            selectedItemColor: const Color(0xFF4A90D9),
            unselectedItemColor: Colors.grey,
            onTap: (index) => currentIndex.value = index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
