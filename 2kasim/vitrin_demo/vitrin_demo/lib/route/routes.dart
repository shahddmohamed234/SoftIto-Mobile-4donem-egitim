import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../screens/anaKasaEkrani.dart';
import '../screens/profile.dart';
import '../screens/vitrin.dart';

final GoRouter uygulamaRotalari = GoRouter(
    initialLocation:'/vitrin',
    routes:[
      ShellRoute(
        builder:(BuildContext context, GoRouterState state, Widget child){
          return AnaKasaEkrani(ekranGovdesi:child);
        },
        routes:[
          GoRoute(
            path:'/profil',
            builder:(context,state) => const VitrinEkrani(),
          ),
           GoRoute(
            path:'/profil',
            builder:(context,state) => const ProfilEkrani(),
          ),
        ],
      ),
    ],
);