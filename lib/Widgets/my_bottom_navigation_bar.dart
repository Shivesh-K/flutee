import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final setScreen;
  const CustomBottomNavigationBar({Key key, @required this.setScreen})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  List<Widget> navBarItems;
  int selected;

  Widget buildItem({
    @required icon,
    @required selectedIcon,
    @required String title,
    @required int i,
  }) =>
      GestureDetector(
        onTap: () {
          setState(() {
            navBarItems = navBarItems;
            selected = i;
          });
          widget.setScreen(i);
        },
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          curve: Curves.decelerate,
          vsync: this,
          child: Container(
            decoration: BoxDecoration(
              color: (i == selected) ? Colors.tealAccent : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  // scrollDirection: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconTheme(
                      data: IconThemeData(
                        color: (i == selected)
                            ? Colors.black87
                            : Colors.tealAccent,
                        size: 24,
                      ),
                      child: (((i == selected)) ? selectedIcon : icon),
                    ),
                    SizedBox(width: (i == selected) ? 8 : 0),
                    Text(
                      (i == selected) ? title : "",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void initState() {
    selected = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    navBarItems = [
      buildItem(
        title: "Home",
        icon: FaIcon(FontAwesomeIcons.home),
        selectedIcon: FaIcon(FontAwesomeIcons.home),
        i: 0,
      ),
      buildItem(
        title: "Profile",
        icon: FaIcon(FontAwesomeIcons.user),
        selectedIcon: FaIcon(FontAwesomeIcons.solidUser),
        i: 1,
      )
    ];

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(width: 0.35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: navBarItems,
      ),
    );
  }
}
