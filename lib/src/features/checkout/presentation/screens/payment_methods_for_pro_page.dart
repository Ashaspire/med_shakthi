import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  String selectedMethodId = "card_1";

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "id": "card_1",
      "type": "MasterCard",
      "details": "**** **** **** 4242",
      "icon": Icons.credit_card,
    },
    {
      "id": "card_2",
      "type": "Visa",
      "details": "**** **** **** 8899",
      "icon": Icons.credit_card,
    },
    {
      "id": "upi_1",
      "type": "UPI",
      "details": "abhishek@upi",
      "icon": Icons.account_balance_wallet,
    },
    {
      "id": "cod",
      "type": "Cash on Delivery",
      "details": "Pay when item arrives",
      "icon": Icons.payments_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Payment Methods",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// 🔹 Saved Methods
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                final isSelected = selectedMethodId == method["id"];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMethodId = method["id"];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4C8077)
                            : Colors.transparent,
                        width: 1.6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          method["icon"],
                          size: 32,
                          color: const Color(0xFF4C8077),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method["type"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                method["details"],
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF4C8077),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// ➕ Add New Method
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Add Payment Method clicked"),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add New Payment Method"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4C8077),
                      side: const BorderSide(color: Color(0xFF4C8077)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                /// ✅ Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedMethodId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C8077),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Use Selected Method",
                      style: TextStyle(fontSize: 16),
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
