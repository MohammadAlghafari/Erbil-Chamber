import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/main/main_bloc.dart';
import '../../../common/enums.dart';
import '../../../injections.dart';
import '../favorite/favorite_screen.dart';
import '../home/homee_screen.dart';
import '../near_by/near_by_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);
  static const routeName = '/main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainBloc mainBloc;

  final List<Widget> screens = [
    HomeScreen(),
    FavoriteScreen(),
    NearByScreen(),
    //ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    mainBloc = serviceLocator<MainBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => mainBloc,
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {},
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 69),
                    child: IndexedStack(
                      index: state.tab == MainTab.Home
                          ? 0
                          : state.tab == MainTab.Favorite
                              ? 1
                              : 2,
                      children: screens,
                    ),
                  ),
                  _buildBottomNavigationBar(state, context),
                ],
              ),

              /* TabSelector(
                activeTab: state.tab,
                onTabSelected: (tab) =>
                    BlocProvider.of<MainBloc>(context).add(MainTabUpdated(tab)),
              ), */
            );
          },
        ),
      ),
    );
  }

  Align _buildBottomNavigationBar(MainState state, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            // to make elevation
            BoxShadow(
              color: Theme.of(context).primaryColor,
              offset: Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.only(right: 24, left: 24, bottom: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomTab(
                text: AppLocalizations.of(context).home,
                icon: Icons.home,
                selected: state.tab == MainTab.Home ? true : false,
                onPressed: () {
                  BlocProvider.of<MainBloc>(context)
                      .add(MainTabUpdated(MainTab.Home));
                }),
            BottomTab(
                text: AppLocalizations.of(context).favorite,
                icon: Icons.favorite,
                selected: state.tab == MainTab.Favorite ? true : false,
                onPressed: () {
                  BlocProvider.of<MainBloc>(context)
                      .add(MainTabUpdated(MainTab.Favorite));
                }),
            BottomTab(
                text: AppLocalizations.of(context).near_by,
                icon: Icons.location_on,
                selected: state.tab == MainTab.NearBy ? true : false,
                onPressed: () {
                  BlocProvider.of<MainBloc>(context)
                      .add(MainTabUpdated(MainTab.NearBy));
                }),
          ],
        ),
      ),
    );
  }
}

class BottomTab extends StatelessWidget {
  const BottomTab(
      {Key key,
      @required this.text,
      @required this.icon,
      @required this.selected,
      @required this.onPressed})
      : super(key: key);

  final String text;
  final IconData icon;
  final bool selected;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return selected
        ? Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade100.withOpacity(0.6),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ],
            ),
          )
        : Material(
          color: Colors.transparent,
                  child: IconButton(
              icon: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: onPressed),
        );
  }
}

class TabSelector extends StatelessWidget {
  final MainTab activeTab;
  final Function(MainTab) onTabSelected;

  TabSelector({
    @required this.activeTab,
    @required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex:
          MainTab.values.indexOf(activeTab != null ? activeTab : MainTab.Home),
      onTap: (index) => onTabSelected(MainTab.values[index]),
      items: MainTab.values.map((tab) {
        return BottomNavigationBarItem(
            icon: Icon(tab == MainTab.Home
                ? Icons.home
                : tab == MainTab.Favorite
                    ? Icons.favorite
                    : tab == MainTab.NearBy
                        ? Icons.location_on
                        : Icons.person),
            label: tab == MainTab.Home
                ? AppLocalizations.of(context).home
                : tab == MainTab.Favorite
                    ? AppLocalizations.of(context).favorite
                    : AppLocalizations.of(context).near_by);
      }).toList(),
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).accentColor,
    );
  }
}
