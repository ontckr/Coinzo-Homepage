import 'package:flutter/material.dart';

class CoinTile extends StatelessWidget {
  final Image coinIcon;
  final String coinName;
  final double price1;
  final double price2;
  final String priceType;
  final double change;
  final Color changeColor;

  CoinTile({
    Key key,
    @required this.coinIcon,
    @required this.coinName,
    @required this.price1,
    @required this.price2,
    @required this.priceType,
    @required this.change,
    @required this.changeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[400],
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 10,
                    ),
                    child: coinIcon,
                  ),
                  Text(
                    coinName,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$price1',
                        style: TextStyle(
                          // color: Colors.black,
                          fontSize: 21,
                        ),
                      ),
                      Text(
                        ' ' + priceType,
                        style: TextStyle(
                          // color: Colors.black,
                          fontSize: 21,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '≈ ' + '$price2',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ' USD',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    change.toString() + '%',
                    style: TextStyle(
                      color: changeColor,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
