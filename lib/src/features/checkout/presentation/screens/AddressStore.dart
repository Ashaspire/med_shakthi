import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'AddressModel.dart';

class AddressStore extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<AddressModel> addresses = [];
  bool loading = false;

  AddressModel? get selectedAddress {
    if (addresses.isEmpty) return null;
    return addresses.firstWhere(
          (a) => a.isSelected,
      orElse: () => addresses.first,
    );
  }

  Future<void> fetchAddresses() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    loading = true;
    notifyListeners();

    try {
      final data = await supabase
          .from('addresses')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      addresses = (data as List)
          .map((e) => AddressModel.fromMap(e))
          .toList();

      if (addresses.isNotEmpty) {
        addresses = addresses
            .asMap()
            .entries
            .map((entry) => entry.value.copyWith(isSelected: entry.key == 0))
            .toList();
      }
    } catch (e) {
      debugPrint("fetchAddresses error: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<void> addAddress(AddressModel address) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    loading = true;
    notifyListeners();

    try {
      await supabase.from('addresses').insert(address.toMap());

      await fetchAddresses(); //  refresh from DB
    } catch (e) {
      debugPrint("addAddress error: $e");
    }

    loading = false;
    notifyListeners();
  }

  void selectAddressLocal(String id) {
    addresses =
        addresses.map((a) => a.copyWith(isSelected: a.id == id)).toList();
    notifyListeners();
  }
}

