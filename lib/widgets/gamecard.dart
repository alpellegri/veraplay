import 'package:flutter/material.dart';

class GameCardWidget extends StatelessWidget {
  final String name;
  final String description;
  final String count;
  static const double kRound = 8;

  GameCardWidget(this.name, this.description, this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kRound),
          color: Theme.of(context).primaryColorLight,
        ),
        child: Stack(
          children: <Widget>[
            Container(
              // alignment: Alignment.centerLeft,
              width: kRound,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(kRound),
                    bottomLeft: Radius.circular(kRound)),
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: (8.0 + kRound), vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name,
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              description,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )),
                        Text(
                          count,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
