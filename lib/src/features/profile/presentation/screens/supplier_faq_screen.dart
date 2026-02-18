import 'package:flutter/material.dart';

class SupplierFaqScreen extends StatefulWidget {
  const SupplierFaqScreen({super.key});

  @override
  State<SupplierFaqScreen> createState() => _SupplierFaqScreenState();
}

class _SupplierFaqScreenState extends State<SupplierFaqScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I process a new order?',
      'answer': 'When a new order arrives, it appears in your "Orders" tab. Open the order details, verify the items, and change the status to "Confirmed" to start fulfillment.',
      'category': 'Orders',
    },
    {
      'question': 'How do I add a new product to my inventory?',
      'answer': 'Go to the "Inventory" section or use the "+" button on your dashboard. Fill in the medicine details, price, and upload a clear image to list it.',
      'category': 'Inventory',
    },
    {
      'question': 'When will I receive my payouts?',
      'answer': 'Payouts are processed weekly. You can track your earnings and upcoming payments in the "Payouts" section of your dashboard.',
      'category': 'Payouts',
    },
    {
      'question': 'What are the platform fees?',
      'answer': 'We charge a standard 8% platform fee on successful deliveries. This covers logistics support, secure payments, and platform maintenance.',
      'category': 'Payouts',
    },
    {
      'question': 'How do I track my sales performance?',
      'answer': 'Visit the "Sales Analytics" tab to view real-time reports on your revenue, top-selling products, and monthly growth metrics.',
      'category': 'Analytics',
    },
    {
      'question': 'How long does the verification process take?',
      'answer': 'Verification typically takes 24-48 business hours. Our team reviews your drug license and tax documents to ensure compliance.',
      'category': 'Verification',
    },
    {
      'question': 'Can I update my business address after registration?',
      'answer': 'Yes, go to your Profile settings, click "Edit", and update your address. Note that major changes may require a re-verification of documents.',
      'category': 'Profile',
    },
    {
      'question': 'How do low-stock alerts work?',
      'answer': 'When your product stock falls below 10 units, it will be highlighted in yellow in your inventory. This helps you restock before running out.',
      'category': 'Inventory',
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _faqs.where((faq) {
      final query = _searchQuery.toLowerCase();
      return faq['question']!.toLowerCase().contains(query) ||
             faq['answer']!.toLowerCase().contains(query) ||
             faq['category']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Help & FAQs'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
      ),
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(
            child: filteredFaqs.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: filteredFaqs.length,
                    itemBuilder: (context, index) {
                      return _buildFaqCard(filteredFaqs[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search for questions...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF4C8077)),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFaqCard(Map<String, String> faq) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ExpansionTile(
          title: Text(
            faq['question']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4C8077).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIconForCategory(faq['category']!),
              color: const Color(0xFF4C8077),
              size: 20,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq['answer']!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Orders': return Icons.shopping_bag_outlined;
      case 'Inventory': return Icons.inventory_2_outlined;
      case 'Payouts': return Icons.payments_outlined;
      case 'Analytics': return Icons.analytics_outlined;
      case 'Verification': return Icons.verified_user_outlined;
      case 'Profile': return Icons.person_outline;
      default: return Icons.help_outline;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
