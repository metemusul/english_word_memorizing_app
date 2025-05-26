import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<IconData> icons;
  final ValueChanged<int> onTap;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.icons,
    required this.onTap,
    this.backgroundColor = Colors.black87,
    this.activeColor = const Color.fromARGB(255, 233, 132, 16),
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final isSelected = selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    alignment: Alignment.center,
                    height: 70,
                    child: isSelected
                        ? SizedBox(height: 60) // Boşluk bırak seçili simge için
                        : Icon(
                            icons[index],
                            color: inactiveColor,
                            size: 28,
                          ),
                  ),
                ),
              );
            }),
          ),
          // Seçili simgeyi yukarıda, daire içinde ve animasyonlu göster
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            left: (MediaQuery.of(context).size.width / icons.length) * selectedIndex +
                (MediaQuery.of(context).size.width / icons.length) / 2 - 30,
            bottom: 10,
            child: Material(
              elevation: 8,
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withOpacity(0.3),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    icons[selectedIndex],
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 