import 'package:flutter/material.dart';

class SupplierCategoryPage extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const SupplierCategoryPage({super.key, this.onBackToHome});

  @override
  State<SupplierCategoryPage> createState() => _SupplierCategoryPageState();
}

class _SupplierCategoryPageState extends State<SupplierCategoryPage> {
  final Color themeColor = const Color(0xFF6AA39B);
  int selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {
      "name": "Medicines",
      "icon": Icons.medication_outlined,
      "items": ["Tablets", "Syrups", "Capsules", "Injections", "Pain Relief"]
    },
    {
      "name": "Supplements",
      "icon": Icons.local_pharmacy_outlined,
      "items": ["Protein", "Vitamins", "Omega 3", "Weight Gain", "Immunity"]
    },
    {
      "name": "Personal Care",
      "icon": Icons.spa_outlined,
      "items": ["Skin Care", "Hair Care", "Body Care", "Cosmetics"]
    },
    {
      "name": "Baby Care",
      "icon": Icons.child_friendly_outlined,
      "items": ["Diapers", "Baby Food", "Baby Lotion", "Baby Soap"]
    },
    {
      "name": "Devices",
      "icon": Icons.monitor_heart_outlined,
      "items": ["BP Monitor", "Thermometer", "Glucometer", "Nebulizer"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCategory = categories[selectedCategoryIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search categories...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Container(
                  width: 110,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final bool isSelected = index == selectedCategoryIndex;

                      return InkWell(
                        onTap: () {
                          setState(() => selectedCategoryIndex = index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? themeColor.withOpacity(0.12)
                                : Colors.white,
                            border: Border(
                              left: BorderSide(
                                color: isSelected ? themeColor : Colors.white,
                                width: 4,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                cat["icon"],
                                color: isSelected ? themeColor : Colors.grey,
                                size: 26,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat["name"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected
                                      ? themeColor
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCategory["name"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Expanded(
                          child: GridView.builder(
                            itemCount: (selectedCategory["items"] as List).length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 1.2,
                            ),
                            itemBuilder: (context, i) {
                              final itemName =
                              (selectedCategory["items"] as List)[i];

                              return InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Open: ${selectedCategory["name"]} → $itemName",
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.category_outlined,
                                          size: 30, color: themeColor),
                                      const SizedBox(height: 8),
                                      Text(
                                        itemName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
