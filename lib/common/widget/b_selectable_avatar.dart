import 'package:budget_app/common/widget/b_smart_avatar.dart';
import 'package:budget_app/common/widget/button/b_button.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/asset_type_enum.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/asset_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A tappable avatar widget that shows a picker dialog when tapped
class BSelectableAvatar extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BSelectableAvatarState();
}

class _BSelectableAvatarState extends ConsumerState<BSelectableAvatar> {
  late String _currentAvatar;

  @override
  void initState() {
    super.initState();
    _currentAvatar = widget.initialAvatar ?? _defaultAvatar;
  }

  String get _defaultAvatar {
    return ref
        .read(assetControllerProvider.notifier)
        .getAssetsByType(AssetTypeEnum.avatarImage)
        .first
        .url;
  }

  @override
  void didUpdateWidget(BSelectableAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialAvatar != oldWidget.initialAvatar) {
      _currentAvatar = widget.initialAvatar ?? _defaultAvatar;
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
            borderWidth: widget.borderWidth),
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
    final String? selectedAvatar = await showAvatarPicker(
      context,
      currentAvatar: _currentAvatar,
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
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 460),
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
    return Consumer(builder: (_, ref, __) {
      final avatars = ref
          .watch(assetControllerProvider.notifier)
          .getAssetsByType(AssetTypeEnum.avatarImage);
      if (avatars.isEmpty) {
        return Center(
          child: BText.caption(context.loc.noData),
        );
      }

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          final avatarModel = avatars[index];
          final isSelected = _selectedAvatar == avatarModel.url;

          return _buildAvatarItem(
            avatarPath: avatarModel.url,
            isSelected: isSelected,
            onTap: () => _selectAvatar(avatarModel.url),
          );
        },
      );
    });
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
            child: _buildImageWidget(avatarPath),
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

  Widget _buildImageWidget(String imagePath) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: const CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
          shape: BoxShape.circle,
        ),
        child: Icon(
          IconManager.avatar,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
