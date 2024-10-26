import 'package:apps/src/customColor.dart';
import 'package:flutter/material.dart';

class Bottomnav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Bottomnav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: CustomColors.BiruPrimary,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontFamily: 'NotoSanSemiBold'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'NotoSanSemiBold'),
          items: List.generate(4, (index) => _buildNavItem(index)),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(int index) {
    final List<IconData> icons = [
      Icons.home,
      Icons.description,
      Icons.add_circle_outline,
      Icons.person,
    ];
    final List<String> labels = ['Home', 'Pemantauan', 'Pendataan', 'Akun'];

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(currentIndex == index ? 12 : 8),
        decoration: BoxDecoration(
          color: currentIndex == index
              ? CustomColors.BiruPrimary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icons[index]),
      ),
      label: labels[index],
    );
  }
}
