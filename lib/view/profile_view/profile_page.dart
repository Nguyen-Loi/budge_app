import 'package:budget_app/common/widget/b_avatar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/ad_helper.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/pakage_info_base_controller.dart';
import 'package:budget_app/view/base_controller/remote_config_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/profile_view/controller/profile_controller.dart';
import 'package:budget_app/view/profile_view/profile_detail/profile_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    bool isAds =
        ref.read(remoteConfigBaseControllerProvider.notifier).isUserAds;
    if (isAds) {
      BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, err) {
            ad.dispose();
          },
        ),
      ).load();
    }

    super.initState();
  }

  bool _validateLogin(bool isLogin) {
    if (!isLogin) {
      BDialogInfo(
              message: context.loc.loginToUse,
              dialogInfoType: BDialogInfoType.warning)
          .present(context);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        title: context.loc.profile,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _info()),
            gapH24,
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: _body(context)),
            )
          ],
        ));
  }

  Widget _info() {
    return Consumer(builder: (_, ref, __) {
      final user = ref.watch(userBaseControllerProvider);
      return ListTile(
        title: BText.b1(user.name),
        leading: BAvatar.network(user.profileUrl, size: 20),
        subtitle: BText.caption(user.email),
      );
    });
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Consumer(builder: (_, ref, __) {
        final isLogin = ref.watch(userBaseControllerProvider.notifier).isLogin;
        return ColumnWithSpacing(
          children: [
            _item(
                icon: IconManager.account,
                text: context.loc.myAccount,
                onPressed: () {
                  if (_validateLogin(isLogin) == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileDetailView(),
                      ),
                    );
                  }
                }),
            _item(
                icon: IconManager.botChat,
                text: context.loc.chatWithViBot,
                onPressed: () {
                  if (_validateLogin(isLogin) == true) {
                    Navigator.pushNamed(context, RoutePath.chat);
                  }
                }),
            _item(
                icon: IconManager.setting,
                text: context.loc.settings,
                onPressed: () {
                  Navigator.pushNamed(context, RoutePath.settings);
                }),
            _item(
                icon: IconManager.contact,
                text: context.loc.contact,
                onPressed: () {
                  BDialogInfo(
                          message: context.loc.developingFreatures,
                          dialogInfoType: BDialogInfoType.warning)
                      .present(context);
                }),
            if (isLogin)
              _item(
                  icon: IconManager.signOut,
                  text: context.loc.signOut,
                  onPressed: () {
                    ref.read(profileController.notifier).signOut(context);
                  }),
            if (!isLogin)
              _item(
                  icon: IconManager.signIn,
                  text: context.loc.signIn,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RoutePath.login);
                  }),
            Expanded(child: _content()),
            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _content() {
    DateTime userJoinDate = ref.watch(userBaseControllerProvider).createdDate;
    final monthUserAvailable = DateTime.now().month - userJoinDate.month;
    final appVersion = ref.watch(packageInfoBaseControllerProvider).version;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BText.caption(
              context.loc.pUserJoinDescriptions(
                  userJoinDate.toYM(), monthUserAvailable),
              textAlign: TextAlign.center),
          gapH8,
          BText.caption(context.loc.pAppVersion(appVersion),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _item(
      {required IconData icon,
      required String text,
      required Function() onPressed}) {
    return ListTile(
      title: BText(text, fontWeight: FontWeight.w700),
      onTap: onPressed,
      trailing: Icon(
        IconManager.arrowNext,
        size: 15,
      ),
      leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primaryContainer,
          )),
    );
  }
}
