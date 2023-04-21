import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'InputScreen.dart';

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
          ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Image.asset(
                          'assets/recipe-wizard.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Recipe Wizard',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InputScreen()),
                          );
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
                      SizedBox(height: 40.0)
                    ],
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
