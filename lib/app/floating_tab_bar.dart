import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../core/design/app_colors.dart';

class FloatingTabBar extends StatelessWidget {
  const FloatingTabBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.hasNewMenuItem = false,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool hasNewMenuItem;

  static const double height = 72;
  static const double width = 236;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xEBF2F2F0),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: const Color(0xBFFFFFFF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 28,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SizedBox(
            height: height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final segmentWidth = constraints.maxWidth / 2;
                final reduceMotion = MediaQuery.disableAnimationsOf(context);
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      left: selectedIndex * segmentWidth + 5,
                      top: 5,
                      width: segmentWidth - 10,
                      height: height - 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0x1A1F4D3A),
                          borderRadius: BorderRadius.circular(31),
                          border: Border.all(color: const Color(0xA6FFFFFF)),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _Destination(
                            label: 'Add Dish',
                            icon: CupertinoIcons.camera,
                            selected: selectedIndex == 0,
                            onTap: () => onSelected(0),
                          ),
                        ),
                        Expanded(
                          child: _Destination(
                            label: 'My Menu',
                            icon: CupertinoIcons.doc_text,
                            selected: selectedIndex == 1,
                            showDot: hasNewMenuItem,
                            onTap: () => onSelected(1),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

class _Destination extends StatelessWidget {
  const _Destination({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.showDot = false,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.forestGreen : const Color(0xFF5F6068);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 25, color: color),
                if (showDot)
                  const Positioned(
                    right: -5,
                    top: -3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemRed,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(width: 8, height: 8),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
