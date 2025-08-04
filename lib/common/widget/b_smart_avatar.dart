import 'package:budget_app/common/widget/b_lottie.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/view/base_controller/asset_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BSmartAvatar extends ConsumerWidget {
  const BSmartAvatar({
    this.data,
    super.key,
    this.size = 20,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2.0,
  });

  final String? data;
  final double size;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  String _effectiveAvatarPath(WidgetRef ref) {
    if (data != null) {
      return data!;
    }
    return ref.read(assetControllerProvider.notifier).defaultAvatar;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget avatar = _buildNetworkAvatar(ref);

    if (showBorder) {
      avatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? Theme.of(context).colorScheme.primary,
            width: borderWidth,
          ),
        ),
        child: avatar,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _errorImage(BuildContext context) {
    return Container(
      width: size * 2,
      height: size * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withAlpha(50),
      ),
      child: Icon(
        IconManager.avatar,
        size: size * 1.5,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildNetworkAvatar(WidgetRef ref) {
    if (kIsWeb) {
      return CircleAvatar(
        radius: size,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.network(
            _effectiveAvatarPath(ref),
            width: size * 2,
            height: size * 2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _errorImage(context);
            },
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: _effectiveAvatarPath(ref),
      placeholder: (context, url) => CircleAvatar(
        radius: size,
        child: BLottie(
          LottieUrl.loadingImage,
          width: size * 1.5,
          height: size * 1.5,
        ),
      ),
      imageBuilder: (context, image) => CircleAvatar(
        backgroundImage: image,
        radius: size,
        backgroundColor: Colors.transparent,
      ),
      errorWidget: (context, url, error) => _errorImage(context),
    );
  }
}
