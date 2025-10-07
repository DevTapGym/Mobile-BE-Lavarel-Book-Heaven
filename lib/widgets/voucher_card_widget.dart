import 'package:flutter/material.dart';
import 'package:heaven_book_app/themes/app_colors.dart';

class VoucherCardWidget extends StatelessWidget {
  final String title;
  final String minimumOrder;
  final int points;
  final String validUntil;
  final String type;
  final bool showRedeemButton;
  final VoidCallback? onTap;
  final bool hasMargin;
  final bool showPerforation;

  const VoucherCardWidget({
    super.key,
    required this.title,
    required this.minimumOrder,
    required this.points,
    required this.validUntil,
    required this.type,
    this.showRedeemButton = true,
    this.onTap,
    this.hasMargin = true,
    this.showPerforation = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      height: 140,
      margin:
          hasMargin
              ? EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0)
              : EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipPath(
            clipper: showPerforation ? LeftPerforationClipper() : null,
            child: Container(
              width: 120,
              height: 140,
              color: AppColors.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    type,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 4.0,
                          color: Colors.black26,
                        ),
                      ],
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Minimum order: $minimumOrder'),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            color: AppColors.primaryDark,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            points.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Valid until: $validUntil'),
                      if (showRedeemButton) ...[
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            minimumSize: const Size(0, 28),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Redeem',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: cardContent);
    } else {
      return cardContent;
    }
  }
}

class LeftPerforationClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path rectPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    const double circleRadius = 5.0;
    const int numCircles = 8;
    final double step = size.height / (numCircles + 1);

    Path circlesPath = Path();
    for (int i = 0; i < numCircles; i++) {
      final double centerY = step * (i + 1);
      circlesPath.addOval(
        Rect.fromCircle(center: Offset(0, centerY), radius: circleRadius),
      );
    }

    final Path result = Path.combine(
      PathOperation.difference,
      rectPath,
      circlesPath,
    );
    return result;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
