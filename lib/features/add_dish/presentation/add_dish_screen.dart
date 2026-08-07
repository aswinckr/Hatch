import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/design/app_colors.dart';
import '../../menu/domain/dish.dart';
import '../domain/dish_analysis.dart';
import 'dish_review_form.dart';

enum AddDishStage { choosePhoto, analyzing, review, complete }

class AddDishScreen extends StatefulWidget {
  AddDishScreen({
    super.key,
    required this.analyzer,
    required this.onDishFinalized,
    ImagePicker? imagePicker,
  }) : imagePicker = imagePicker ?? ImagePicker();
  final DishAnalyzer analyzer;
  final Future<void> Function(Dish dish) onDishFinalized;
  final ImagePicker imagePicker;
  @override
  State<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  AddDishStage stage = AddDishStage.choosePhoto;
  String? imagePath, errorText;
  MealSection section = MealSection.breakfast;
  final name = TextEditingController();
  final restaurant = TextEditingController();
  final description = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    restaurant.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final selected = await widget.imagePicker.pickImage(
        source: source,
        imageQuality: 88,
      );
      if (selected != null) await _analyze(selected.path);
    } on PlatformException {
      if (!mounted) return;
      await showCupertinoDialog<void>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Photo access needed'),
          content: const Text(
            'Allow access in Settings, or try a sample dish instead.',
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _analyze(String path) async {
    setState(() {
      imagePath = path;
      stage = AddDishStage.analyzing;
      errorText = null;
    });
    try {
      final result = await widget.analyzer.analyze(path);
      name.text = result.name;
      restaurant.text = result.restaurant;
      description.text = result.description;
      section = result.mealSection;
    } catch (_) {
      name.clear();
      restaurant.clear();
      description.clear();
      errorText = 'We couldn’t identify it. Add the details yourself.';
    }
    if (mounted) setState(() => stage = AddDishStage.review);
  }

  Future<void> _submit() async {
    if (name.text.trim().isEmpty || restaurant.text.trim().isEmpty) {
      setState(() => errorText = 'Add a dish name and restaurant.');
      return;
    }
    final now = DateTime.now();
    await widget.onDishFinalized(
      Dish(
        id: '${now.microsecondsSinceEpoch}-${imagePath.hashCode.abs()}',
        imagePath: imagePath!,
        name: name.text.trim(),
        restaurant: restaurant.text.trim(),
        description: description.text.trim(),
        mealSection: section,
        createdAt: now,
        updatedAt: now,
      ),
    );
    if (mounted) setState(() => stage = AddDishStage.complete);
  }

  void _reset() {
    setState(() {
      stage = AddDishStage.choosePhoto;
      imagePath = null;
      errorText = null;
      name.clear();
      restaurant.clear();
      description.clear();
      section = MealSection.breakfast;
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = switch (stage) {
      AddDishStage.choosePhoto => _ChoosePhoto(
        onCamera: () => _pick(ImageSource.camera),
        onLibrary: () => _pick(ImageSource.gallery),
        onSample: () => _analyze('assets/demo/truffle_eggs.png'),
      ),
      AddDishStage.analyzing => const SizedBox(
        height: 520,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoActivityIndicator(radius: 16),
              SizedBox(height: 14),
              Text('Finding the story of this dish…'),
            ],
          ),
        ),
      ),
      AddDishStage.review => Column(
        children: [
          _FoodPreview(path: imagePath!),
          const SizedBox(height: 18),
          DishReviewForm(
            nameController: name,
            restaurantController: restaurant,
            descriptionController: description,
            section: section,
            errorText: errorText,
            onSectionChanged: (value) => setState(() => section = value),
            onSubmit: _submit,
          ),
        ],
      ),
      AddDishStage.complete => SizedBox(
        height: 520,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.check_mark_circled_solid,
                size: 64,
                color: AppColors.terracotta,
              ),
              const SizedBox(height: 18),
              const Text(
                'Added to your menu',
                style: TextStyle(fontFamily: 'NotoSerif', fontSize: 26),
              ),
              const SizedBox(height: 12),
              const Text('Open My Menu to see it in place.'),
              const SizedBox(height: 20),
              CupertinoButton(
                onPressed: _reset,
                child: const Text('Add another dish'),
              ),
            ],
          ),
        ),
      ),
    };
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Add Dish')),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
          child: content,
        ),
      ),
    );
  }
}

class _ChoosePhoto extends StatelessWidget {
  const _ChoosePhoto({
    required this.onCamera,
    required this.onLibrary,
    required this.onSample,
  });
  final VoidCallback onCamera, onLibrary, onSample;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 38),
      const Text(
        'A menu made of\nyour best meals.',
        style: TextStyle(
          fontFamily: 'NotoSerif',
          fontSize: 36,
          height: 1.1,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Photograph a favourite dish. We’ll shape the menu copy, and you stay in control.',
      ),
      const SizedBox(height: 34),
      CupertinoButton.filled(
        onPressed: onCamera,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.camera),
            SizedBox(width: 8),
            Text('Take a photo'),
          ],
        ),
      ),
      const SizedBox(height: 10),
      CupertinoButton(
        color: CupertinoColors.systemGrey5,
        onPressed: onLibrary,
        child: const Text('Choose from library'),
      ),
      const SizedBox(height: 12),
      CupertinoButton(
        onPressed: onSample,
        child: const Text('Try a sample dish'),
      ),
    ],
  );
}

class _FoodPreview extends StatelessWidget {
  const _FoodPreview({required this.path});
  final String path;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: AspectRatio(
      aspectRatio: 1.5,
      child: path.startsWith('assets/')
          ? Image.asset(path, fit: BoxFit.cover)
          : Image.file(File(path), fit: BoxFit.cover),
    ),
  );
}
