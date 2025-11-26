import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/promotion_controller.dart';
import '../models/promotion_model.dart';
import 'promotion_form.dart';

class PromotionScreen extends StatefulWidget {
  final String spaId;

  const PromotionScreen({super.key, required this.spaId});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PromotionController>().loadPromotions(widget.spaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PromotionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Promotions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PromotionForm(
                    spaId: widget.spaId,
                    promotion: null,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: controller.promotions.length,
              itemBuilder: (context, index) {
                final item = controller.promotions[index];
                return Card(
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text("Discount: ${item.discountPercent}%"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PromotionForm(
                                  spaId: widget.spaId,
                                  promotion: item,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final ok = await controller.deletePromotion(item.id!);
                            if (ok && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Deleted successfully"),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

