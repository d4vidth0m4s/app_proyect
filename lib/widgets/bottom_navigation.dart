import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/programs_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/config_screen.dart';
import 'dart:math' as Math;

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProgramsScreen(),
    const AlertScreen(),
    const ConfigScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 30, 30, 30), // fondo gris oscuro
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 6),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Aquí vendrán los botones de navegación.
            _buildNavItem(icon: Icons.home_outlined, label: 'Inicio', index: 0),
            _buildNavItem(icon: Icons.list_alt_outlined, label: 'Programas', index: 1),
            _buildNavItem(icon: Icons.warning_amber_outlined, label: 'Alertas', index: 2),
            _buildNavItem(icon: Icons.settings_outlined, label: 'Configuración', index: 3),

            

              ],
          ),
        ),
      ),
    );
  }



  Widget _buildNavItem({
  required IconData icon,
  required String label,
  required int index,
}) {
  final bool isSelected = _currentIndex == index;

  return SizedBox(
    width: 80,
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isSelected) CustomPaint(
                  size: const Size(28, 28),
                  painter: ShapePainter(shape: MyShape(offsetX: 15.0)),
                ),
              
              if (isSelected) Transform.translate(
                offset: isSelected ? const Offset(0, -12) : Offset.zero,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(79, 112, 112, 112), // o cualquier color que combine
                  ),
                ),
              ),

               
            Transform.translate(
              offset: isSelected ? const Offset(0, -12) : Offset.zero,
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white70,
                size: 30,
              ),
            ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

}


class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const int points = 5;
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final Path path = Path();
    for (int i = 0; i <= points * 2; i++) {
      final isEven = i % 2 == 0;
      final r = isEven ? radius : radius / 2.5;
      final angle = (i * 360 / (points * 2)) * 3.14159 / 180;
      final x = centerX + r * Math.cos(angle);
      final y = centerY + r * Math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MyShape extends NotchedShape {
  final double offsetX;

  MyShape({required this.offsetX});

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null) return Path()..addRect(host);

    final double notchRadius = guest.width / 2.0;
    const double s1 = 11.0;
    const double s2 = 30.0;

    final double r = notchRadius;
    final double a = -r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = Math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = Math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = Math.sqrt(r * r - p2xB * p2xB);

    final List<Offset> p = List.filled(6, Offset.zero);

    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, -p2yA) : Offset(p2xB, -p2yB);
    p[3] = Offset(-p[2].dx, p[2].dy);
    p[4] = Offset(-p[1].dx, p[1].dy);
    p[5] = Offset(-p[0].dx, p[0].dy);

    for (int i = 0; i < p.length; i++) {
      p[i] += Offset(offsetX, guest.center.dy);
    }

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(
        p[3],
        radius: Radius.circular(notchRadius),
        clockwise: true,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
class ShapePainter extends CustomPainter {
  final NotchedShape shape;

  ShapePainter({required this.shape});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect host = Rect.fromLTWH(0, 0, size.width, size.height);
    final Rect guest = Rect.fromCircle(center: Offset(size.width / 2, 10), radius: 41);
    final Path path = shape.getOuterPath(host, guest);
    final paint = Paint()..color = const Color.fromARGB(255, 30, 30, 30);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}