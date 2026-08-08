import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/presentation/wireframe_image_placeholder.dart';
import '../../menu/domain/dish.dart';
import '../data/image_picker_photo_picker.dart';
import '../domain/dish_analysis.dart';
import '../domain/photo_picker.dart';
import 'dish_feed.dart';
import 'dish_review_form.dart';

enum AddDishStage { choosePhoto, analyzing, review, complete }

class AddDishScreen extends StatefulWidget {
  AddDishScreen({
    super.key,
    required this.analyzer,
    required this.onDishFinalized,
    PhotoPicker? photoPicker,
    this.capturedDishes = const [],
    this.showEmbeddedCameraAction = true,
    this.onHomeStageChanged,
  }) : photoPicker = photoPicker ?? ImagePickerPhotoPicker();

  final DishAnalyzer analyzer;
  final Future<void> Function(Dish dish) onDishFinalized;
  final PhotoPicker photoPicker;
  final List<Dish> capturedDishes;
  final bool showEmbeddedCameraAction;
  final ValueChanged<bool>? onHomeStageChanged;

  @override
  State<AddDishScreen> createState() => AddDishScreenState();
}

class AddDishScreenState extends State<AddDishScreen> {
  AddDishStage stage = AddDishStage.choosePhoto;
  String? imagePath;
  String? errorText;
  MealSection section = MealSection.breakfast;
  final name = TextEditingController();
  final restaurant = TextEditingController();
  final description = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    restaurant.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> choosePhotoSource() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Photo library'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) await _pick(source);
  }

  Future<void> takePhoto() => _pick(ImageSource.camera);

  Future<void> _pick(ImageSource source) async {
    try {
      final selectedPath = await widget.photoPicker.pick(source);
      if (selectedPath != null) await _analyze(selectedPath);
    } on PlatformException {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Photo access needed'),
          content: const Text(
            'Allow camera or photo access in system settings and try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _analyze(String path) async {
    widget.onHomeStageChanged?.call(false);
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
      errorText = "We couldn't analyze this photo. Enter the details manually.";
    }

    if (mounted) setState(() => stage = AddDishStage.review);
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate() || imagePath == null) return;

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
    widget.onHomeStageChanged?.call(true);
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
  Widget build(BuildContext context) => switch (stage) {
    AddDishStage.choosePhoto => Stack(
      children: [
        DishFeed(dishes: widget.capturedDishes),
        if (widget.showEmbeddedCameraAction)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              tooltip: 'Choose a photo source',
              onPressed: choosePhotoSource,
              child: const Icon(Icons.add_a_photo_outlined),
            ),
          ),
      ],
    ),
    AddDishStage.analyzing => const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Analyzing photo'),
        ],
      ),
    ),
    AddDishStage.review => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AspectRatio(
            aspectRatio: 1,
            child: WireframeImagePlaceholder(
              key: Key('selected-image-placeholder'),
              semanticLabel: 'Selected dish image placeholder',
            ),
          ),
          const SizedBox(height: 16),
          DishReviewForm(
            formKey: formKey,
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
    ),
    AddDishStage.complete => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              'Added to your menu',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('The new entry is now available in both tabs.'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _reset,
              child: const Text('Add another dish'),
            ),
          ],
        ),
      ),
    ),
  };
}
