import 'package:flutter/material.dart';

import '../../menu/domain/dish.dart';

class DishReviewForm extends StatelessWidget {
  const DishReviewForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.restaurantController,
    required this.descriptionController,
    required this.section,
    required this.onSectionChanged,
    required this.onSubmit,
    this.errorText,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController restaurantController;
  final TextEditingController descriptionController;
  final MealSection section;
  final ValueChanged<MealSection> onSectionChanged;
  final VoidCallback onSubmit;
  final String? errorText;

  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Review your dish',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('dish-name'),
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Dish name'),
          validator: (value) => value == null || value.trim().isEmpty
              ? 'Enter a dish name'
              : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('restaurant-name'),
          controller: restaurantController,
          decoration: const InputDecoration(labelText: 'Restaurant name'),
          validator: (value) => value == null || value.trim().isEmpty
              ? 'Enter a restaurant name'
              : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('dish-description'),
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Short dish description',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<MealSection>(
          initialValue: section,
          decoration: const InputDecoration(labelText: 'Meal section'),
          isExpanded: true,
          items: MealSection.values
              .map(
                (value) =>
                    DropdownMenuItem(value: value, child: Text(value.label)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onSectionChanged(value);
          },
        ),
        if (errorText != null) ...[
          const SizedBox(height: 12),
          Text(errorText!, key: const Key('analysis-error')),
        ],
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('add-to-menu'),
          onPressed: onSubmit,
          child: const Text('Add to menu'),
        ),
      ],
    ),
  );
}
