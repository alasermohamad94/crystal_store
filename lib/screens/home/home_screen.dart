import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/optimized_image.dart';
import '../products/products_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/balance_history_screen.dart';
import '../payment/send_money_screen.dart';
import '../pages/about_screen.dart';
import '../pages/terms_screen.dart';
import '../notifications/notifications_screen.dart';
import '../../models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CategoriesScreen(), // 0: الرئيسية
    const ProductsScreen(), // 1: المنتجات
    const OrdersScreen(), // 2: طلباتي
    const BalanceHistoryScreen(), // 3: رصيدي
    const SendMoneyScreen(), // 4: إرسال دفعة
    const SizedBox.shrink(), // 5: (فارغ - محجوز)
    const AboutScreen(), // 6: عن الموقع
    const TermsScreen(), // 7: الشروط
    const ProfileScreen(), // 8: ملفي الشخصي
    const NotificationsScreen(), // 9: الإشعارات
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .loadCategories(parentOnly: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // تحديد index للـ Bottom Navigation Bar
    // 0 = الرئيسية (CategoriesScreen - index 0)
    // 1 = طلباتي (OrdersScreen - index 2)
    // 2 = إرسال دفعة (SendMoneyScreen - index 4)
    int _bottomNavIndex = 0;
    if (_selectedIndex == 0) {
      _bottomNavIndex = 0; // الرئيسية
    } else if (_selectedIndex == 2) {
      _bottomNavIndex = 1; // طلباتي
    } else if (_selectedIndex == 4) {
      _bottomNavIndex = 2; // إرسال دفعة
    }

    return Scaffold(
      endDrawer: AppDrawer(
        // Changed from drawer to endDrawer (right side)
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Builder(
        builder:
            (context) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF7C3AED), // Purple
                    Color(0xFF8B5CF6), // Light Purple
                    Color(0xFFA78BFA), // Lighter Purple
                  ],
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _bottomNavIndex,
                onTap: (index) {
                  if (index == 0) {
                    setState(() {
                      _selectedIndex = 0; // الرئيسية
                    });
                  } else if (index == 1) {
                    setState(() {
                      _selectedIndex = 2; // طلباتي
                    });
                  } else if (index == 2) {
                    setState(() {
                      _selectedIndex = 4; // إرسال دفعة
                    });
                  } else if (index == 3) {
                    // فتح الدراور
                    Scaffold.of(context).openEndDrawer();
                  }
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white70,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 11),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    activeIcon: Icon(Icons.home_rounded),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_rounded),
                    activeIcon: Icon(Icons.receipt_long_rounded),
                    label: 'طلباتي',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.send_rounded),
                    activeIcon: Icon(Icons.send_rounded),
                    label: 'إرسال دفعة',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_rounded),
                    activeIcon: Icon(Icons.menu_rounded),
                    label: 'القائمة',
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        if (productProvider.isLoadingCategories &&
            productProvider.categories.isEmpty) {
          return Builder(
            builder:
                (context) => Scaffold(
                  endDrawer: const AppDrawer(),
                  appBar: AppBar(
                    leading: const SizedBox.shrink(),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    ],
                    title: const Text('الفئات'),
                  ),
                  body: const Center(child: CircularProgressIndicator()),
                ),
          );
        }

        if (productProvider.categoriesError != null) {
          return Builder(
            builder:
                (context) => Scaffold(
                  endDrawer: const AppDrawer(),
                  appBar: AppBar(
                    leading: const SizedBox.shrink(),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    ],
                    title: const Text('الفئات'),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('خطأ: ${productProvider.categoriesError}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => productProvider.loadCategories(parentOnly: true),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                ),
          );
        }

        if (productProvider.categories.isEmpty) {
          return Builder(
            builder:
                (context) => Scaffold(
                  endDrawer: const AppDrawer(),
                  appBar: AppBar(
                    leading: const SizedBox.shrink(),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    ],
                    title: const Text('الفئات'),
                  ),
                  body: const Center(child: Text('لا توجد فئات')),
                ),
          );
        }

        return Builder(
          builder:
              (context) => Scaffold(
                endDrawer: const AppDrawer(),
                appBar: AppBar(
                  leading: const SizedBox.shrink(),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ],
                  title: const Text('الفئات'),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    await productProvider.loadCategories();
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: productProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = productProvider.categories[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            // إذا كانت الفئة لديها فئات فرعية، اعرضها
                            if (category.subcategories != null && category.subcategories!.isNotEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SubcategoriesScreen(
                                    parentCategory: category,
                                  ),
                                ),
                              );
                            } else {
                              // إذا لم تكن لديها فئات فرعية، اعرض المنتجات مباشرة
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductsScreen(categoryId: category.id),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF7C3AED), // Purple
                                  Color(0xFF8B5CF6), // Light Purple
                                  Color(0xFFA78BFA), // Lighter Purple
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child:
                                      category.imageUrl != null
                                          ? OptimizedImage(
                                            imageUrl: category.imageUrl!,
                                            fit: BoxFit.cover,
                                            placeholderColor: Colors.white
                                                .withOpacity(0.1),
                                            errorWidget: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.category_rounded,
                                                size: 60,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                          : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.1,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.category_rounded,
                                              size: 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
        );
      },
    );
  }
}

class SubcategoriesScreen extends StatelessWidget {
  final CategoryModel parentCategory;

  const SubcategoriesScreen({super.key, required this.parentCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parentCategory.name),
      ),
      body: parentCategory.subcategories == null || parentCategory.subcategories!.isEmpty
          ? const Center(child: Text('لا توجد فئات فرعية'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: parentCategory.subcategories!.length,
              itemBuilder: (context, index) {
                final subcategory = parentCategory.subcategories![index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductsScreen(categoryId: subcategory.id),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF7C3AED), // Purple
                            Color(0xFF8B5CF6), // Light Purple
                            Color(0xFFA78BFA), // Lighter Purple
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: subcategory.imageUrl != null
                                  ? OptimizedImage(
                                      imageUrl: subcategory.imageUrl!,
                                      fit: BoxFit.cover,
                                      placeholderColor: Colors.white.withOpacity(0.1),
                                      errorWidget: const Icon(
                                        Icons.category_rounded,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.category_rounded,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              border: Border(
                                top: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subcategory.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
