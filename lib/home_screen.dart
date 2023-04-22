import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:recipe_generator/settings_page.dart';
import 'input_screen.dart';

class RecipeGPTApp extends StatelessWidget {
  const RecipeGPTApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/start-background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ),
          Positioned(
            top: 60.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Recipe Wizard',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Din guide till ett kulinariskt mästerverk. Typ.',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (context, animation,
                                    secondaryAnimation) => InputScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation, child: child,);
                                },),);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 48.0,
                                vertical: 16.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5.0,
                              animationDuration: Duration(milliseconds: 200),
                              shadowColor: Colors.black.withOpacity(0.5),
                            ),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0)
                        ],
                      ),
                    ),
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
