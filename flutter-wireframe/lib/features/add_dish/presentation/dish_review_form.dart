import 'package:flutter/cupertino.dart';
import '../../../core/design/app_shapes.dart';
import '../../menu/domain/dish.dart';

class DishReviewForm extends StatelessWidget {
  const DishReviewForm({
    super.key,
    required this.nameController,
    required this.restaurantController,
    required this.descriptionController,
    required this.section,
    required this.onSectionChanged,
    required this.onSubmit,
    this.submitLabel = 'Add to menu',
    this.errorText,
  });

  final TextEditingController nameController,
      restaurantController,
      descriptionController;
  final MealSection section;
  final ValueChanged<MealSection> onSectionChanged;
  final VoidCallback onSubmit;
  final String submitLabel;
  final String? errorText;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Review your dish',
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 18),
      _Field(
        key: const Key('dish-name'),
        controller: nameController,
        placeholder: 'Dish name',
      ),
      const SizedBox(height: 10),
      _Field(
        key: const Key('restaurant-name'),
        controller: restaurantController,
        placeholder: 'Restaurant',
      ),
      const SizedBox(height: 10),
      _Field(
        key: const Key('dish-description'),
        controller: descriptionController,
        placeholder: 'Menu description',
        maxLines: 3,
      ),
      const SizedBox(height: 16),
      CupertinoSlidingSegmentedControl<MealSection>(
        groupValue: section,
        children: {
          for (final value in MealSection.values)
            value: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(value.label),
            ),
        },
        onValueChanged: (value) {
          if (value != null) onSectionChanged(value);
        },
      ),
      if (errorText != null)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            errorText!,
            style: const TextStyle(color: CupertinoColors.systemRed),
          ),
        ),
      const SizedBox(height: 18),
      CupertinoButton.filled(
        borderRadius: AppShapes.pill,
        onPressed: onSubmit,
        child: Text(submitLabel),
      ),
    ],
  );
}

class _Field extends StatelessWidget {
  const _Field({
    super.key,
    required this.controller,
    required this.placeholder,
    this.maxLines = 1,
  });
  final TextEditingController controller;
  final String placeholder;
  final int maxLines;
  @override
  Widget build(BuildContext context) => CupertinoTextField(
    controller: controller,
    placeholder: placeholder,
    maxLines: maxLines,
    padding: const EdgeInsets.all(14),
  );
}
