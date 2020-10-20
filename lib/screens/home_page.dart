import 'dart:convert';
import 'package:coinzo_homepage/model/parity.dart';
import 'package:coinzo_homepage/model/parity_value.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'coin_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  
  IOWebSocketChannel channel;

  double usdTRY = 7.92;


  Map<String, ParityValue> parityValues = {};
  List<Parity> parities = [
    Parity("ti1", "BTC-TRY", "assets/btc.png", "TRY", "BTC"),
    Parity("ti2", "ETH-TRY", "assets/eth.png", "TRY", "ETH"),
    Parity("ti6", "XRP-TRY", "assets/xrp.png", "TRY", "XRP"),
    Parity("ti4", "EOS-TRY", "assets/eos.png", "TRY", "EOS"),
    Parity("ti3", "NEO-TRY", "assets/neo.png", "TRY", "NEO"),
    Parity("ti5", "HOT-TRY", "assets/hot.png", "TRY", "HOT"),
    Parity("ti7", "ETH-BTC", "assets/eth.png", "BTC", "ETH"),
    Parity("ti8", "XRP-BTC", "assets/xrp.png", "BTC", "XRP"),
    Parity("ti10", "EOS-BTC", "assets/eos.png", "BTC", "EOS"),
    Parity("ti9", "NEO-BTC", "assets/neo.png", "BTC", "NEO"),
    Parity("ti12", "XRP-ETH", "assets/xrp.png", "ETH", "XRP"),
    Parity("ti14", "EOS-ETH", "assets/eos.png", "ETH", "EOS"),
    Parity("ti13", "NEO-ETH", "assets/neo.png", "ETH", "NEO"),
    Parity("ti15", "HOT-ETH", "assets/hot.png", "ETH", "HOT"),
    Parity("ti11", "CNZ-TRY", "assets/cnz.png", "TRY", "CNZ"),
  ];

  initConnection() {
    channel = IOWebSocketChannel.connect('wss://www.coinzo.com/ws');

    parities.forEach((element) {
      var name = element.name;
      channel.sink
          .add('{"event":"subscribe","channel":"ticker","pair":"$name"}');
    });

    channel.stream.listen((event) {
      // print(event);
      if (event.startsWith('["ti')) {
        var map = jsonDecode(event);
        var id = map[0];
        var dailyChange = double.parse(map[1][0]);
        var dailyPer = double.parse(map[1][1]);
        var lastPrice = double.parse(map[1][2]);
        var volume = double.parse(map[1][3]);
        var high = double.parse(map[1][4]);
        var low = double.parse(map[1][5]);

        ParityValue parityValue = ParityValue(
          id,
          dailyChange,
          dailyPer,
          lastPrice,
          volume,
          high,
          low,
        );

        setState(() {
          parityValues[id] = parityValue;
        });
      }
    }, onError: (err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    initConnection();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildHeader(),
            Expanded(child: _buildTabBarView())
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Image.asset(
                    'assets/coinzo.png',
                    height: 22,
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'TRY',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Tab(
                  child: Text(
                    'BTC',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Tab(
                  child: Text(
                    'ETH',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[400],
          ),
        ),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Coin',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Fiyat',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    'Değişim',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTRY(),
        _buildBTC(),
        _buildETH(),
      ],
    );
  }

  Widget _buildTRY() {
    return ListView(
        children: parities
            .where((element) => element.base == "TRY")
            .map(
              (e) => CoinTile(
                coinIcon: Image.asset(
                  e.iconAsset,
                  width: 32,
                ),
                coinName: e.target,
                price1: parityValues[e.id] == null
                    ? 0
                    : parityValues[e.id].lastPrice,
                priceType: e.base,
                price2: parityValues[e.id] == null
                    ? 0
                    : parityValues[e.id].lastPrice / usdTRY.round(), //dolar
                change: parityValues[e.id] == null
                    ? 0
                    : parityValues[e.id].dailyPer,
                changeColor: parityValues[e.id] == null
                    ? Colors.black
                    : parityValues[e.id].dailyPer <= 0
                        ? Colors.red
                        : Colors.green,
              ),
            )
            .toList());
  }

  Widget _buildBTC() {
    return ListView(
        children: parities
            .where((element) => element.base == "BTC")
            .map(
              (e) => CoinTile(
                coinIcon: Image.asset(
                  e.iconAsset,
                  width: 32,
                ),
                coinName: e.target,
                price1: parityValues[e.id] == null
                    ? 0
                    : parityValues[e.id].lastPrice,
                priceType: e.base,
                price2: parityValues[e.id] == null
                    ? 0
                    : parityValues[e.id].lastPrice *
                        parityValues['ti1'].lastPrice /
                        usdTRY, //dolar
                change: parityValues[e.id] == null
                    ? 0
                    : parityValues[e.id].dailyPer,
                changeColor: parityValues[e.id] == null
                    ? Colors.black
                    : parityValues[e.id].dailyPer <= 0
                        ? Colors.red
                        : Colors.green,
              ),
            )
            .toList());
  }

  Widget _buildETH() {
    return ListView(
        children: parities
            .where((element) => element.base == "ETH")
            .map(
              (e) => CoinTile(
                coinIcon: Image.asset(
                  e.iconAsset,
                  width: 32,
                ),
                coinName: e.target,
                price1: parityValues[e.id] == null
                    ? 0
                    : parityValues[e.id].lastPrice,
                priceType: e.base,
                price2: parityValues[e.id] == null
                    ? 0
                    : parityValues[e.id].lastPrice *
                        parityValues['ti2'].lastPrice /
                        usdTRY, //dolar
                change: parityValues[e.id] == null
                    ? 0
                    : parityValues[e.id].dailyPer,
                changeColor: parityValues[e.id] == null
                    ? Colors.black
                    : parityValues[e.id].dailyPer <= 0
                        ? Colors.red
                        : Colors.green,
              ),
            )
            .toList());
  }
}
