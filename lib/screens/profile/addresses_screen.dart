import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/mock_data.dart';
import '../../models/address_model.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  late List<AddressModel> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = [...MockData.addresses];
  }

  void _addAddress() {
    final labelController = TextEditingController();
    final addressController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Address', style: AppTextStyles.h2),
            const SizedBox(height: 16),
            TextField(controller: labelController, decoration: const InputDecoration(labelText: 'Label (e.g. Home, Work)')),
            const SizedBox(height: 12),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Full Address')),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Save Address',
              onPressed: () {
                if (labelController.text.isEmpty || addressController.text.isEmpty) return;
                setState(() {
                  _addresses.add(AddressModel(
                    id: 'a${_addresses.length + 1}',
                    label: labelController.text,
                    fullAddress: addressController.text,
                    latitude: -1.2921,
                    longitude: 36.8219,
                  ));
                });
                Navigator.of(sheetContext).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      floatingActionButton: FloatingActionButton(onPressed: _addAddress, backgroundColor: AppColors.primaryGreen, child: const Icon(Icons.add)),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _addresses.length,
        itemBuilder: (context, i) {
          final address = _addresses[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: context.surfaceColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.surfaceColors.divider)),
            child: Row(
              children: [
                Icon(address.label == 'Home' ? Icons.home_outlined : Icons.location_on_outlined, color: AppColors.primaryGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.label, style: AppTextStyles.h3),
                      Text(address.fullAddress, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') setState(() => _addresses.removeAt(i));
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'delete', child: Text('Remove')),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
