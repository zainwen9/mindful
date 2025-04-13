import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/nav_bloc.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/nav_event.dart';
import 'package:mental_health/resources/app_colors.dart';

class Bottomnavbar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;

  const Bottomnavbar({
    super.key,
    required this.items,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            ColorManager.backgroundColor.withOpacity(0.9),
            ColorManager.bubbleColor.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Color(0xFF6C72CB).withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          items: items.map((item) {
            final index = items.indexOf(item);
            final isSelected = currentIndex == index;
            return BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.green.withOpacity(0.15)
                      : Colors.transparent,
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                      : null,
                ),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: isSelected
                          ? [Colors.white, Color(0xFFF0E6FA)]
                          : [Colors.white70, Colors.white70],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: item.icon,
                ),
              ),
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [Colors.white, Color(0xFFF0E6FA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: item.icon,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 3,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              label: item.label,
              tooltip: item.label,
            );
          }).toList(),
          currentIndex: currentIndex,
          onTap: (index) {
            context.read<NavBloc>().add(NavigateTo(index: index));
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            letterSpacing: 0.3,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            letterSpacing: 0.2,
          ),
          elevation: 0,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}