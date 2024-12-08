import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';

class UserTile extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
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
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer,
            ),

            const SizedBox(width: 20,),
            // username
            Text(
              widget.text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryContainer,
                fontFamily: "Hoves",
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
