import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_shapes.dart';
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
    this.capturedDishes = const [],
    this.showEmbeddedCameraAction = true,
    this.onHomeStageChanged,
  }) : imagePicker = imagePicker ?? ImagePicker();
  final DishAnalyzer analyzer;
  final Future<void> Function(Dish dish) onDishFinalized;
  final ImagePicker imagePicker;
  final List<Dish> capturedDishes;
  final bool showEmbeddedCameraAction;
  final ValueChanged<bool>? onHomeStageChanged;
  @override
  State<AddDishScreen> createState() => AddDishScreenState();
}

class AddDishScreenState extends State<AddDishScreen> {
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

  Future<void> takePhoto() => _pick(ImageSource.camera);

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
  Widget build(BuildContext context) {
    final content = switch (stage) {
      AddDishStage.choosePhoto => _HomeGallery(
        dishes: widget.capturedDishes,
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
                color: AppColors.forestGreen,
              ),
              const SizedBox(height: 18),
              const Text(
                'Added to your menu',
                style: TextStyle(fontFamily: 'Outfit', fontSize: 26),
              ),
              const SizedBox(height: 12),
              const Text('Open My Menu to see it in place.'),
              const SizedBox(height: 20),
              CupertinoButton(
                borderRadius: AppShapes.pill,
                onPressed: _reset,
                child: const Text('Add another dish'),
              ),
            ],
          ),
        ),
      ),
    };
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text('Home'),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 156),
              child: content,
            ),
            if (stage == AddDishStage.choosePhoto &&
                widget.showEmbeddedCameraAction)
              Positioned(
                right: 20,
                bottom: 12,
                child: FloatingCameraButton(onPressed: takePhoto),
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeGallery extends StatelessWidget {
  const _HomeGallery({
    required this.dishes,
    required this.onLibrary,
    required this.onSample,
  });
  final List<Dish> dishes;
  final VoidCallback onLibrary, onSample;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your dishes',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text('A gallery of meals worth remembering.'),
              ],
            ),
          ),
          CupertinoButton(
            borderRadius: AppShapes.pill,
            padding: const EdgeInsets.all(10),
            onPressed: onLibrary,
            child: const Icon(CupertinoIcons.photo_on_rectangle),
          ),
        ],
      ),
      const SizedBox(height: 24),
      if (dishes.isEmpty)
        _EmptyGallery(onSample: onSample)
      else
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 18,
            childAspectRatio: .72,
          ),
          itemCount: dishes.length,
          itemBuilder: (_, index) => _DishTile(dish: dishes[index]),
        ),
    ],
  );
}

class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery({required this.onSample});
  final VoidCallback onSample;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
    decoration: BoxDecoration(
      color: CupertinoColors.systemGrey6,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      children: [
        const Icon(
          CupertinoIcons.photo,
          size: 38,
          color: AppColors.forestGreen,
        ),
        const SizedBox(height: 14),
        const Text(
          'Your gallery is waiting',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 22),
        ),
        const SizedBox(height: 8),
        const Text('Capture your first favourite dish.'),
        const SizedBox(height: 14),
        CupertinoButton(
          borderRadius: AppShapes.pill,
          onPressed: onSample,
          child: const Text('Try a sample dish'),
        ),
      ],
    ),
  );
}

class _DishTile extends StatelessWidget {
  const _DishTile({required this.dish});
  final Dish dish;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: double.infinity,
            child: _DishImage(path: dish.imagePath),
          ),
        ),
      ),
      const SizedBox(height: 9),
      Text(
        dish.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        dish.restaurant,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
      ),
    ],
  );
}

class FloatingCameraButton extends StatelessWidget {
  const FloatingCameraButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Take a photo',
    child: CupertinoButton(
      key: key ?? const Key('floating-camera-button'),
      borderRadius: AppShapes.pill,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: AppColors.forestGreen,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          CupertinoIcons.camera_fill,
          color: CupertinoColors.white,
          size: 27,
        ),
      ),
    ),
  );
}

class _DishImage extends StatelessWidget {
  const _DishImage({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) => path.startsWith('assets/')
      ? Image.asset(path, fit: BoxFit.cover)
      : Image.file(File(path), fit: BoxFit.cover);
}

class _FoodPreview extends StatelessWidget {
  const _FoodPreview({required this.path});
  final String path;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: AspectRatio(aspectRatio: 1.5, child: _DishImage(path: path)),
  );
}
