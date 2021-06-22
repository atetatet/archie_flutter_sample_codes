import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CardController controller; //Use this to trigger swap.

  List<String> welcomeImages = [
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
    "assets/images/test.jpeg",
  ];

  _divCardBody(int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Text(
            "Why do bees have sticky hair? Because they use honeycombs",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        Image.asset(
          '${welcomeImages[index]}',
        ),
      ],
    );
  }

  _bottomSheetButtons(IconData icons, Color colors) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
          )
        ],
      ),
      child: Center(
        child: Icon(
          icons,
          color: colors,
          size: 30,
        ),
      ),
    );
  }

  _appbarButtons(IconData icons, Color colors, int index) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icons,
        color: colors,
      ),
    );
  }

  Widget getAppBar() {
    var items = 5;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _appbarButtons(Icons.category, Colors.red, 0),
          _appbarButtons(Icons.favorite_border, Colors.blue, 1),
          _appbarButtons(Icons.reply_all_outlined, Colors.green, 2),
        ],
      ),
    );
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 120,
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bottomSheetButtons(Icons.replay_outlined, Colors.orange),
            _bottomSheetButtons(Icons.close, Colors.red),
            _bottomSheetButtons(Icons.favorite, Colors.blue),
            _bottomSheetButtons(Icons.star, Colors.green),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Ttem 1"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("Item 2"),
              trailing: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
      appBar: getAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
            )
          ],
        ),
        child: new TinderSwapCard(
          allowVerticalMovement: false,
          swipeUp: false,
          swipeDown: false,
          orientation: AmassOrientation.BOTTOM,
          totalNum: welcomeImages.length,
          stackNum: 3,
          swipeEdge: 4.0,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          minWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: MediaQuery.of(context).size.height * 0.8,
          cardBuilder: (context, index) => Card(
            child: _divCardBody(index),
          ),
          cardController: controller = CardController(),
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            /// Get swiping card's alignment
            if (align.x < 0) {
            } else if (align.x > 0) {}
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            print(orientation);
          },
        ),
      ),
      bottomSheet: getFooter(),
    );
  }
}
