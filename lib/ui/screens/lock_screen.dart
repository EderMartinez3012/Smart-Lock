import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home/widget/background_design.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLock() {
    HapticFeedback.heavyImpact();
    setState(() {
      isUnlocked = !isUnlocked;
      if (isUnlocked) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeader(),
                _buildLockSlider(),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Text(
          'SMART LOCK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            // TODO: Implement settings navigation
          },
        ),
      ],
    );
  }

  Widget _buildLockSlider() {
    final screenWidth = MediaQuery.of(context).size.width;
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        customWidths: CustomSliderWidths(
          trackWidth: 12,
          progressBarWidth: 12,
          shadowWidth: 24,
        ),
        customColors: CustomSliderColors(
          trackColor: Colors.white.withOpacity(0.1),
          progressBarColors: [lightBlue, accentBlue],
          shadowColor: primaryBlue.withOpacity(0.5),
          shadowMaxOpacity: 0.05,
        ),
        infoProperties: InfoProperties(
          mainLabelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 28,
          ),
          modifier: (double value) {
            return isUnlocked ? 'Open' : 'Closed';
          },
        ),
        startAngle: 180,
        angleRange: 360,
        size: screenWidth * 0.7,
      ),
      min: 0,
      max: 100,
      initialValue: isUnlocked ? 100 : 0,
      onChange: (double value) {
        if (value > 95 && !isUnlocked) {
          _toggleLock();
        } else if (value < 5 && isUnlocked) {
          _toggleLock();
        }
      },
      innerWidget: (double value) {
        return Center(
          child: GestureDetector(
            onTap: _toggleLock,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + _animation.value * 0.1,
                  child: Container(
                    width: screenWidth * 0.45,
                    height: screenWidth * 0.45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isUnlocked
                          ? lightBlue.withOpacity(0.8)
                          : primaryBlue.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: isUnlocked
                              ? lightBlue.withOpacity(0.5)
                              : primaryBlue.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        isUnlocked ? Icons.lock_open_rounded : Icons.lock_rounded,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFooterButton(Icons.vpn_key, 'Guest Pass'),
        _buildFooterButton(Icons.history, 'History'),
        _buildFooterButton(Icons.person_add_alt_1, 'Users'),
      ],
    );
  }

  Widget _buildFooterButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
