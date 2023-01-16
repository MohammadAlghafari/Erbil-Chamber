part of 'main_bloc.dart';

@immutable
class MainState extends Equatable {
  const MainState({this.tab = MainTab.Home, });
  

 

  final MainTab tab;

  MainState copyWith({
    MainTab tab,
  }) {
    return MainState(
        tab: (tab) ?? this.tab);
  }

  @override
  List<Object> get props => [tab,  ];
}
