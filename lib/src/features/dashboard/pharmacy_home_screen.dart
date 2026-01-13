import 'package:flutter/material.dart';
import 'package:med_shakthi/src/features/cart/presentation/screens/cart_page.dart';
import 'package:med_shakthi/src/features/orders/orders_page.dart';
import 'package:med_shakthi/src/features/products/presentation/screens/product_page.dart';
import 'package:med_shakthi/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import '../cart/data/cart_data.dart';
import '../cart/data/cart_item.dart';
import '../orders/order_screen.dart';
import '../products/data/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// This screen implements the "med Shakti home page "
class PharmacyHomeScreen extends StatefulWidget {
  const PharmacyHomeScreen({super.key});

  @override
  State<PharmacyHomeScreen> createState() => _PharmacyHomeScreenState();
}

class _PharmacyHomeScreenState extends State<PharmacyHomeScreen> {
  // State allows us to track dynamic changes, like the selected tab in the navigation bar.
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildTopBar(), // Top Bar
              const SizedBox(height: 24),
              _buildPromoBanner(), // Promo Banner
              const SizedBox(height: 24),
              _buildSectionTitle(
                "Categories",
                "See All",
                    () {},
              ), // categories Title
              const SizedBox(height: 16),
              _buildCategoriesList(), // Categories List
              const SizedBox(height: 24),
              _buildSectionTitle(
                "Bestseller Products",
                "See All",
                    () {},
              ), // Bestseller Products Title
              const SizedBox(height: 16),
              _buildBestsellersList(), // Bestsellers List
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(), // Bottom Navigation Bar
    );
  }

  // --- Widget code block ---

  /// Builds the top bar containing the Scan button, Search bar, and Cart button.
  Widget _buildTopBar() {
    return Row(
      children: [
        _buildIconBox(Icons.crop_free, () {}), // Scan Button
        const SizedBox(width: 12),
        // Search  Bar
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                30,
              ), // Fully rounded pills are trendy
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.1),
              ), // Subtle border
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Search medicine",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                Icon(Icons.camera_alt_outlined, color: Colors.black),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Cart Button with Badge
        Stack(
          clipBehavior:
          Clip.none, // Allows elements to go outside the stack bounds
          children: [
            _buildIconBox(Icons.shopping_cart_outlined, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            }),
            // Notification Badge
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E88E5), // Blue accent color
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '0', // Example count
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Helper to build a square icon button with shadow
  Widget _buildIconBox(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14), // Squircle shape
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4), // Shadow position
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: 24),
      ),
    );
  }

  /// Builds the promo banner with gradient background and image.
  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      height: 170, // Fixed height for consistency
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        // A complex gradient gives a polished, high-end feel compared to a flat color.
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5A9CA0), // Teal-ish color from image
            Color(0xFF3A6B6E), // Darker teal
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5A9CA0).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Decor (Circles) creating that subtle overlay effect
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),

          // Text Content
          Positioned(
            left: 24,
            top: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pharmacy Made Easy",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Delivery of your discussion", // Copy from image
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Text(
                  "15% OFF",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                // 'Shop Now' Button
                IntrinsicWidth(
                  // Wraps content tightly
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Shop Now",
                        style: TextStyle(
                          color: Color(0xFF3A6B6E), // Text matches banner bg
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Doctor Image
          // Ideally you'd use an asset image. Here we use a transparent PNG from network.
          Positioned(
            right: 10,
            bottom: 0,
            child: Image.network(
              // Placeholder doctor image
              'http://pngimg.com/uploads/doctor/doctor_PNG16001.png',
              height: 160,
              fit: BoxFit.fitHeight,
              // Fallback if image fails to load
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white24,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable section title with "See All" button
  Widget _buildSectionTitle(
      String title,
      String actionText,
      VoidCallback onAction,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, // e.g., "Categories"
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText, // e.g., "See All"
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5A9CA0), // Brand color
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the horizontal list of circular categories
  Widget _buildCategoriesList() {
    // Data list representing the categories
    final categories = [
      {
        'name': 'Medicines',
        'icon': Icons.medication,
        'color': Colors.blue[100],
      },
      {
        'name': 'Health',
        'icon': Icons.favorite,
        'color': Colors.red[100],
      }, // Shortened 'Health Devices'
      {
        'name': 'Vitamins',
        'icon': Icons.wb_sunny,
        'color': Colors.orange[100],
      }, // 'Supplements'
      {
        'name': 'Care',
        'icon': Icons.spa,
        'color': Colors.green[100],
      }, // 'Personal Care'
      {
        'name': 'Medicines',
        'icon': Icons.medication,
        'color': Colors.blue[100],
      },
      {
        'name': 'Health',
        'icon': Icons.favorite,
        'color': Colors.red[100],
      }, // Shortened 'Health Devices'
      {
        'name': 'Vitamins',
        'icon': Icons.wb_sunny,
        'color': Colors.orange[100],
      }, // 'Supplements'
      {'name': 'Care', 'icon': Icons.spa, 'color': Colors.green[100]},
    ];

    return SizedBox(
      height: 100, // Constrained height for row
      child: ListView.separated(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        itemCount: categories.length,
        separatorBuilder: (_, _) =>
        const SizedBox(width: 20), // Spacing between items
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Column(
            children: [
              // Circle Background
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white, // White bg for the circle
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  // We display dynamic icons here. In a real app these might be images.
                  child: Icon(
                    cat['icon'] as IconData,
                    color:
                    (cat['color'] as Color?)?.withValues(alpha: 1.0) ??
                        Colors.blue, // Using the color for the icon
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat['name'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Product>> _fetchProducts() async {
    final res = await supabase
        .from('products')
        .select()
        .order('created_at', ascending: false);

    return (res as List)
        .map((e) => Product.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// Builds the horizontal list of product cards
  Widget _buildBestsellersList() {
    return FutureBuilder<List<Product>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 260,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 260,
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return const SizedBox(
            height: 260,
            child: Center(child: Text("No products available")),
          );
        }

        return SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return GestureDetector(
                //  Product details page open (same as before)
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductPage(product: product),
                  ),
                ),
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  Image
                      Expanded(
                        child: Center(
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      //  Title
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 4),

                      //  Category
                      Text(
                        product.category,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),

                      const SizedBox(height: 8),

                      //  Rating Row (dynamic)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "${product.rating.toStringAsFixed(1)}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      //  Price and Add Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${product.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),

                          //  Add Button (+) -> cart add + open CartPage
                          InkWell(
                            onTap: () {
                              //  stop GestureDetector tap (details page)
                              // otherwise both tap trigger ho jayega
                              // so we do: onTapDown trick not needed, just use InkWell here

                              final cartItem = CartItem(
                                id: product.id, //  UUID from Supabase
                                name: product.name,
                                title: product.name,
                                brand: product.category,
                                size: "Standard",
                                price: product.price,
                                imagePath: product.image,
                                imageUrl: product.image,
                              );

                              context.read<CartData>().addItem(cartItem);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CartPage()),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Item added to cart ")),
                              );
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF5A9CA0),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }


  /// Custom Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.grid_view, "Category", 1),
              _buildNavItem(Icons.favorite_border, "Wishlist", 2),
              _buildNavItem(Icons.receipt_long, "Order", 3),
              _buildNavItem(Icons.person_outline, "Profile", 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountPage(), // Ensure this widget name matches your class
            ),
          );
        } else if (index == 3) {
          // --- NAVIGATION TO ORDER SCREEN ---
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdersPage(),
            ),
          );
        } else {
          // For other buttons, just update the UI selection
          setState(() => _selectedIndex = index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF5A9CA0) : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF5A9CA0) : Colors.grey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}