import 'package:flutter/material.dart';
import '../controllers/promotion_controller.dart';
import '../models/promotion_model.dart';
import '../widgets/promotion_form.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  final PromotionController controller = PromotionController();

  @override
  void initState() {
    super.initState();
    controller.loadPromotions("spa_1"); // Tạm thời hardcode, sau sẽ thay bằng spa thật
  }

  void openForm({PromotionModel? data}) {
    showDialog(
      context: context,
      builder: (_) => PromotionForm(
        existing: data,
        onSaved: () {
          Navigator.pop(context);
          controller.loadPromotions("spa_1");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => openForm(),
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: controller.promotionList.isEmpty
                ? const Center(child: Text("No promotions found"))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Type")),
                        DataColumn(label: Text("Value")),
                        DataColumn(label: Text("Start Date")),
                        DataColumn(label: Text("End Date")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: controller.promotionList.map((promo) {
                        return DataRow(cells: [
                          DataCell(Text(promo.name)),
                          DataCell(Text(promo.type)),
                          DataCell(Text(promo.value.toString())),
                          DataCell(Text(promo.startDate.toString().split(" ")[0])),
                          DataCell(Text(promo.endDate.toString().split(" ")[0])),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => openForm(data: promo),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await controller.deletePromotion(promo.id, promo.spaId);
                                },
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
