import 'package:flutter/material.dart';
import 'package:textual_chat_app/app_assets.dart';

ScaffoldFeatureController mySnackbar(BuildContext context, String text, Color color){
  return ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            text,
                            style: TextStyle(
                              fontFamily: "Hoves",
                              fontSize: 16,
                              color: color == Colors.red ? AppAssets.lightBackgroundColor : AppAssets.darkBackgroundColor,
                            ),
                          ),
                          backgroundColor: color,

                          // Margin from the top and sides
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)), 
                          ),
                          duration: const Duration(seconds: 2),
                          
                        ),
                      );
}