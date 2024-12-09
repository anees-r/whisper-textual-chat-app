import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';

class RequestTile extends StatefulWidget {
  final String text;
  const RequestTile({super.key, required this.text,});

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // icon
            SvgPicture.asset(
              AppAssets.userIcon,
              color:Theme.of(context).colorScheme.secondaryContainer,
            ),

            const SizedBox(width: 20,),
            // username
            Text(
              widget.text,
              style: TextStyle(
                color:Theme.of(context).colorScheme.secondaryContainer,
                fontFamily: "Hoves",
                fontSize: 16,
              ),
            )
          ],
        ),
      
    );
  }
}
