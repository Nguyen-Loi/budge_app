import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BAvatarProfile extends StatelessWidget {
  const BAvatarProfile({
    required this.url,
    required this.username,
    super.key,
    this.size = 24,
  });

  final String? url;
  final String username;
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return _defaultAvatar(context);
    }

    return _network();
  }

  Widget _defaultAvatar(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: BText.h3(userNameAvatarInitials),
      ),
    );
  }

  String get userNameAvatarInitials {
    if (username.isEmpty) {
      return 'U';
    }
    final initials = username.split(' ').map((e) => e[0]).take(2).join();
    return initials.toUpperCase();
  }

  Widget _network() {
    if (kIsWeb) {
      return CircleAvatar(
        radius: size,
        backgroundColor: Colors.transparent,
        child: Image.network(
          url!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _defaultAvatar(context);
          },
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url!,
      placeholder: (context, url) => CircleAvatar(
        radius: size,
        child: Lottie.asset(LottieAssets.loadingImage),
      ),
      imageBuilder: (context, image) => CircleAvatar(
        backgroundImage: image,
        radius: size,
        backgroundColor: Colors.transparent,
      ),
      errorWidget: (context, url, error) => _defaultAvatar(context),
    );
  }
}
