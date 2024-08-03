import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jpv_flutter/src/ui/sliver_card_animation/widgets/body_sliver.dart';
import 'package:jpv_flutter/src/ui/sliver_card_animation/widgets/button_back.dart';
import 'package:jpv_flutter/src/ui/sliver_card_animation/widgets/cover_photo.dart';
import 'package:jpv_flutter/src/ui/sliver_card_animation/widgets/cut_rectangle.dart';
import 'package:jpv_flutter/src/ui/sliver_card_animation/widgets/data_cut_rectangle.dart';
import 'package:jpv_flutter/src/ui/sliver_card_animation/widgets/favorite_circle.dart';
import 'package:jpv_flutter/src/ui/sliver_with_tab/widgets/widgets.dart';

class HomeSliverChallenge extends StatefulWidget {
  const HomeSliverChallenge({Key? key}) : super(key: key);

  @override
  State<HomeSliverChallenge> createState() => _HomeSliverChallengeState();
}

class _HomeSliverChallengeState extends State<HomeSliverChallenge> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _AppBarNetflix(
              minExtended: kToolbarHeight,
              maxExtended: size.height * 0.35,
              size: size,
            ),
          ),
          SliverToBoxAdapter(
            child: Body(size: size),
          )
        ],
      ),
    );
  }
}

class _AppBarNetflix extends SliverPersistentHeaderDelegate {
  const _AppBarNetflix({
    required this.maxExtended,
    required this.minExtended,
    required this.size,
  });
  final double maxExtended;
  final double minExtended;
  final Size size;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / maxExtended;
    //validate the angle at which the card returns
    const uploadlimit = 13 / 100;
    //return value of the card
    final valueback = (1 - percent - 0.77).clamp(0, uploadlimit);
    final fixrotation = pow(percent, 1.5);

    final card = _CoverCard(
      size: size,
      percent: percent,
      uploadlimit: uploadlimit,
      valueback: valueback,
    );

    final bottomsliverbar = _CustomBottomSliverBar(
      size: size,
      fixrotation: fixrotation,
      percent: percent,
    );

    return Stack(
      children: [
        const BackgroundSliver(),
        if (percent > uploadlimit) ...[
          card,
          bottomsliverbar,
        ] else ...[
          bottomsliverbar,
          card,
        ],
        ButtonBack(
          size: size,
          percent: percent,
          onTap: () => Navigator.pop(context),
        ),
        FavoriteCircle(size: size, percent: percent)
      ],
    );
  }

  @override
  double get maxExtent => maxExtended;

  @override
  double get minExtent => minExtended;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _CoverCard extends StatelessWidget {
  const _CoverCard({
    Key? key,
    required this.size,
    required this.percent,
    required this.uploadlimit,
    required this.valueback,
  }) : super(key: key);
  final Size size;
  final double percent;
  final double uploadlimit;
  final num valueback;

  final double angleForCard = 6.5;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.15,
      left: size.width / 24,
      child: Transform(
        alignment: Alignment.topRight,
        transform: Matrix4.identity()
          ..rotateZ(percent > uploadlimit
              ? (valueback * angleForCard)
              : percent * angleForCard),
        child: CoverPhoto(size: size),
      ),
    );
  }
}

class _CustomBottomSliverBar extends StatelessWidget {
  const _CustomBottomSliverBar({
    Key? key,
    required this.size,
    required this.fixrotation,
    required this.percent,
  }) : super(key: key);
  final Size size;
  final num fixrotation;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: -size.width * fixrotation.clamp(0, 0.35),
        right: 0,
        child: _CustomBottomSliver(
          size: size,
          percent: percent,
        ));
  }
}

class _CustomBottomSliver extends StatelessWidget {
  const _CustomBottomSliver({
    Key? key,
    required this.size,
    required this.percent,
  }) : super(key: key);

  final Size size;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.12,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: CutRectangle(),
          ),
          DataCutRectangle(
            size: size,
            percent: percent,
          )
        ],
      ),
    );
  }
}
