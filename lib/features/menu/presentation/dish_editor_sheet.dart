import 'package:flutter/cupertino.dart';
import '../../../core/design/app_shapes.dart';
import '../../add_dish/presentation/dish_review_form.dart';
import '../domain/dish.dart';

class DishEditorSheet extends StatefulWidget {
  const DishEditorSheet({
    super.key,
    required this.dish,
    required this.onSave,
    required this.onDelete,
  });
  final Dish dish;
  final Future<void> Function(Dish dish) onSave;
  final Future<void> Function() onDelete;
  @override
  State<DishEditorSheet> createState() => _DishEditorSheetState();
}

class _DishEditorSheetState extends State<DishEditorSheet> {
  late final name = TextEditingController(text: widget.dish.name);
  late final restaurant = TextEditingController(text: widget.dish.restaurant);
  late final description = TextEditingController(text: widget.dish.description);
  late MealSection section = widget.dish.mealSection;
  String? error;
  @override
  void dispose() {
    name.dispose();
    restaurant.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (name.text.trim().isEmpty || restaurant.text.trim().isEmpty) {
      setState(() => error = 'Add a dish name and restaurant.');
      return;
    }
    await widget.onSave(
      widget.dish.copyWith(
        name: name.text.trim(),
        restaurant: restaurant.text.trim(),
        description: description.text.trim(),
        mealSection: section,
        updatedAt: DateTime.now(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Remove this dish?'),
        content: const Text('It will disappear from your menu.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep it'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.onDelete();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    height: 620,
    decoration: const BoxDecoration(
      color: CupertinoColors.systemBackground,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 5,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey4,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 18),
            DishReviewForm(
              nameController: name,
              restaurantController: restaurant,
              descriptionController: description,
              section: section,
              errorText: error,
              submitLabel: 'Save changes',
              onSectionChanged: (value) => setState(() => section = value),
              onSubmit: _save,
            ),
            const SizedBox(height: 8),
            CupertinoButton(
              borderRadius: AppShapes.pill,
              onPressed: _delete,
              child: const Text(
                'Delete dish',
                style: TextStyle(color: CupertinoColors.systemRed),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
