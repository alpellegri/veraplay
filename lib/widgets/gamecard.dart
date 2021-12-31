import 'package:flutter/material.dart';

class GameCardWidget extends StatelessWidget {
  final String name;
  final String description;

  GameCardWidget(this.name, this.description);

  @override
  Widget build(BuildContext context) {
    return Container(
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColorLight,
        ),
        child: Stack(
          children: <Widget>[
            Container(
              // alignment: Alignment.centerLeft,
              width: 4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                        const Text(
                          '',
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
