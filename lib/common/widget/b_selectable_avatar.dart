import 'package:budget_app/common/widget/b_smart_avatar.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

/// A tappable avatar widget that shows a picker dialog when tapped
class BSelectableAvatar extends StatefulWidget {
  const BSelectableAvatar({
    super.key,
    this.initialAvatar,
    this.onAvatarChanged,
    this.size = 40,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 2.0,
    this.enabled = true,
  });

  /// Initial avatar data (can be network URL or asset path)
  /// If null, defaults to AssetsConstants.avatar1
  final String? initialAvatar;

  /// Callback when avatar is changed
  final ValueChanged<String>? onAvatarChanged;

  /// Size of the avatar
  final double size;

  /// Whether to show border around avatar
  final bool showBorder;

  /// Border color (defaults to theme primary color)
  final Color? borderColor;

  /// Border width
  final double borderWidth;

  /// Whether the avatar picker is enabled
  final bool enabled;

  @override
  State<BSelectableAvatar> createState() => _BSelectableAvatarState();
}

class _BSelectableAvatarState extends State<BSelectableAvatar> {
  late String _currentAvatar;

  @override
  void initState() {
    super.initState();
    _currentAvatar = widget.initialAvatar ?? AssetsConstants.getDefaultAvatar();
  }

  @override
  void didUpdateWidget(BSelectableAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialAvatar != oldWidget.initialAvatar) {
      _currentAvatar =
          widget.initialAvatar ?? AssetsConstants.getDefaultAvatar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BSmartAvatar(
          data: _currentAvatar,
          size: widget.size,
          onTap: widget.enabled ? _showAvatarPicker : null,
          showBorder: widget.showBorder,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
        ),
        if (widget.enabled)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onPrimary,
                size: widget.size * 0.4,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showAvatarPicker() async {
    // For network URLs, we don't pre-select any avatar in the picker
    // For asset paths, we pre-select the current avatar
    final bool isCurrentNetwork = _currentAvatar.startsWith('http://') ||
        _currentAvatar.startsWith('https://');

    final String? selectedAvatar = await showAvatarPicker(
      context,
      currentAvatar: isCurrentNetwork ? null : _currentAvatar,
    );

    if (selectedAvatar != null && selectedAvatar != _currentAvatar) {
      setState(() {
        _currentAvatar = selectedAvatar;
      });
      widget.onAvatarChanged?.call(selectedAvatar);
    }
  }

  Future<String?> showAvatarPicker(
    BuildContext context, {
    String? currentAvatar,
    String title = 'Choose Avatar',
  }) {
    return showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => _AvatarPickerDialog(
        selectedAvatar: currentAvatar,
      ),
    );
  }
}

class _AvatarPickerDialog extends StatefulWidget {
  const _AvatarPickerDialog({
    this.selectedAvatar,
  });

  final String? selectedAvatar;

  @override
  State<_AvatarPickerDialog> createState() => _AvatarPickerDialogState();
}

class _AvatarPickerDialogState extends State<_AvatarPickerDialog>
    with TickerProviderStateMixin {
  String? _selectedAvatar;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.selectedAvatar;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              gapH24,
              Flexible(
                child: _buildAvatarGrid(),
              ),
              gapH24,
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(50),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        gapW16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BText.h3(
                context.loc.chooseAvatar,
                fontWeight: FontWeight.bold,
              ),
              gapH4,
              BText.caption(
                context.loc.selectYourFavoriteAvatar,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(170),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: AssetsConstants.allAvatars.length,
      itemBuilder: (context, index) {
        final avatarPath = AssetsConstants.allAvatars[index];
        final isSelected = _selectedAvatar == avatarPath;

        return _buildAvatarItem(
          avatarPath: avatarPath,
          isSelected: isSelected,
          onTap: () => _selectAvatar(avatarPath),
        );
      },
    );
  }

  Widget _buildAvatarItem({
    required String avatarPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withAlpha(100),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: ClipOval(
            child: Image.asset(
              avatarPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BButton.outlined(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            size: ButtonSize.small,
            title: context.loc.cancel),
        gapW16,
        BButton(
            onPressed: () {
              if (_selectedAvatar != null) {
                Navigator.of(context).pop(_selectedAvatar);
              }
            },
            size: ButtonSize.small,
            title: context.loc.select)
      ],
    );
  }

  void _selectAvatar(String avatarPath) {
    setState(() {
      _selectedAvatar = avatarPath;
    });
  }
}
