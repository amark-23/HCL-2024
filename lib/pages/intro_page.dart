import 'package:flutter/material.dart';
import 'sign_up.dart';

// IntroPage - the first screen when the app is launched
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StaringPage(
        onGetStarted: () {
          // Navigate to user selection screen when user clicks "Continue with Concurro Account"
          Navigator.pushReplacementNamed(context, '/user-selection');
        },
      ),
    );
  }
}

// StaringPage - the content of the first screen with the button and text
class StaringPage extends StatelessWidget {
  final VoidCallback onGetStarted; // Callback for navigation

  const StaringPage({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: screenWidth * 0.27, // 27% of screen width
                top: screenHeight * 0.16, // 16% of screen height
                child: Container(
                  width: screenWidth * 0.46, // 46% of screen width
                  height: screenWidth * 0.46, // 46% of screen width (square)
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/concurro.png"),
                      fit: BoxFit.fill,
                    ),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: screenHeight * 0.42, // Adjusted for proper placement
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.6, // 60% of screen height
                  decoration: ShapeDecoration(
                    color: Color(0xFF4749B5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.25, // 23% of screen width for centering
                top: screenHeight * 0.94, // 94% of screen height
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    clipBehavior: Clip.none,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Don’t have one? Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            //decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.05, // 5% of screen width for padding
                top: screenHeight *
                    0.53, // 55% of screen height for proper spacing
                child: InkWell(
                  onTap: onGetStarted, // Navigate to user selection page
                  child: Container(
                    width: screenWidth * 0.9, // 83% of screen width
                    height: screenHeight * 0.07, // 7% of screen height
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Continue with Concurro Account',
                        style: TextStyle(
                          color: Color(0xFF944FC3),
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
