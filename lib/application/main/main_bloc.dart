import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../common/enums.dart';
import '../../infrastructure/catalog_facade_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(MainState());

  final CatalogFacadeService catalogService;
  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is MainTabUpdated) {
      yield state.copyWith(tab: event.tab);
    } 
  }
}
