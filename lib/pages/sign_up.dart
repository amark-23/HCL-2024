import 'package:flutter/material.dart';

// SignupPage - Sign up screen with input fields
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: ShapeDecoration(
                  color: Color(0xFF4749B5),
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1)),
                ),
              ),
            ),
            // Back arrow and Create your Account text
            Positioned(
              left: screenWidth * 0.01,
              top: screenHeight * 0.05,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous page
                    },
                  ),
                  SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        'Create your Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: screenWidth * 0.52, // Divider length
                        height: 2, // Divider thickness
                        color: Colors.white, // Divider color
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Grouped input fields (Username, Email, Password, Verify Password)
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.15,
              child: Column(
                children: [
                  // Username Input Field
                  Container(
                    margin: EdgeInsets.only(
                        right: screenWidth * 0.6,
                        bottom: 10), // Space between label and input field
                    child: Text(
                      'Username',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.3,
              child: Column(
                children: [
                  // Email Input Field
                  Container(
                    margin:
                        EdgeInsets.only(right: screenWidth * 0.7, bottom: 10),
                    child: Text(
                      'E-mail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth *
                        0.9, // Make this the same as the username input box width
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.45,
              child: Column(
                children: [
                  // Password Input Field
                  Container(
                    margin:
                        EdgeInsets.only(right: screenWidth * 0.6, bottom: 10),
                    child: Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width:
                        screenWidth * 0.9, // Consistent width with other fields
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.6,
              child: Column(
                children: [
                  // Verify Password Input Field
                  Container(
                    margin:
                        EdgeInsets.only(right: screenWidth * 0.45, bottom: 10),
                    child: Text(
                      'Verify Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width:
                        screenWidth * 0.9, // Consistent width with other fields
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Re-enter your password',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Sign Up Button
            Positioned(
              left: screenWidth * 0.25,
              top: screenHeight * 0.78,
              child: InkWell(
                onTap: () {
                  // Handle sign-up logic here
                },
                child: Container(
                  width: screenWidth * 0.5, // Same width as input fields
                  height: screenHeight * 0.07,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Sign Up',
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
    );
  }
}
