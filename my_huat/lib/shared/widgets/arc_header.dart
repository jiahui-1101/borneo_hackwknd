// lib/shared/widgets/arc_header.dart
import 'package:flutter/material.dart';
import '../../features/homepage/notifications/notifications_page.dart';

class ArcHeader extends StatelessWidget {
  final String title;
  const ArcHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipPath(
      clipper: ArcClipper(), 
      child: Container(
        width: double.infinity,
        
        padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 36),
        decoration: const BoxDecoration(color: Color(0xFF0D3A6D)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'CaveatFont',
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.4,
                height: 1.0,
              ),
            ),

            const SizedBox(width: 0),

            
            Transform.translate(
              offset: const Offset(5, 2), 
              child: Transform.scale(
                scale: 4.0, 
                alignment: Alignment.centerLeft, 
                child: Image.asset(
                  'assets/homepagecat.png',
                  height: 34, 
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const Spacer(),
            
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
              icon: const Icon(Icons.notifications_none),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}


class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 40);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}