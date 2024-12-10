import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textual_chat_app/app_assets.dart';
import 'package:textual_chat_app/services/requests/requests_service.dart';

class RequestTile extends StatefulWidget {
  final String text;
  final String senderID;
  const RequestTile({super.key, required this.text, required this.senderID});

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // icon
              SvgPicture.asset(
                AppAssets.userIcon,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),

              const SizedBox(
                width: 20,
              ),
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

          // row for accept and reject buttons
          Row(
            children: [
              // accept button
              Container(
                padding: EdgeInsets.all(0),
                child: ElevatedButton(
                  onPressed: () {
                    RequestsService().acceptRequest(widget.senderID, widget.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.all(0),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.check, color: AppAssets.darkBackgroundColor),
                ),
              ),

              // reject button
              Container(
                padding: EdgeInsets.all(0),
                child: ElevatedButton(
                  onPressed: () {
                    RequestsService().rejectRequest(widget.senderID, widget.text);
                    print("rejected");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    padding: EdgeInsets.all(0),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.close,
                      color: Theme.of(context).colorScheme.secondaryContainer),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
