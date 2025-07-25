import 'package:budget_app/constants/assets_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BSmartAvatar extends StatelessWidget {
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

  bool get _isNetworkUrl {
    if (data == null) return false;
    return data!.startsWith('http://') || data!.startsWith('https://');
  }

  String get _effectiveAvatarPath {
    if (data == null || data!.isEmpty) {
      return AssetsConstants.getDefaultAvatar();
    }
    return _isNetworkUrl ? data! : data!;
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = _isNetworkUrl ? _buildNetworkAvatar() : _buildAssetAvatar();

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

  Widget _buildAssetAvatar() {
    return CircleAvatar(
      radius: size,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: Image.asset(
          _effectiveAvatarPath,
          width: size * 2,
          height: size * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              AssetsConstants.getDefaultAvatar(),
              width: size * 2,
              height: size * 2,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Widget _buildNetworkAvatar() {
    if (kIsWeb) {
      return CircleAvatar(
        radius: size,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.network(
            _effectiveAvatarPath,
            width: size * 2,
            height: size * 2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                AssetsConstants.getDefaultAvatar(),
                width: size * 2,
                height: size * 2,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: _effectiveAvatarPath,
      placeholder: (context, url) => CircleAvatar(
        radius: size,
        child: Lottie.asset(
          LottieAssets.loadingImage,
          width: size * 1.5,
          height: size * 1.5,
        ),
      ),
      imageBuilder: (context, image) => CircleAvatar(
        backgroundImage: image,
        radius: size,
        backgroundColor: Colors.transparent,
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: size,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.asset(
            AssetsConstants.getDefaultAvatar(),
            width: size * 2,
            height: size * 2,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
