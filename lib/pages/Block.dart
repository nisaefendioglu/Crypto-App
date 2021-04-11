import 'package:crypto_app/blocs/crypto/crypto_bloc.dart';
import 'package:crypto_app/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_screen.dart';

class BlockPage extends StatefulWidget {
  @override
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<CryptoBloc>(
        create: (_) => CryptoBloc(
          cryptoRepository: CryptoRepository(),
        )..add(AppStarted()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.blue,
          ),
          home: HomeScreen(),
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//       <<  child: BlocProvider<CryptoBloc>(
//           create: (_) => CryptoBloc(
//             cryptoRepository: CryptoRepository(),
//           )..add(AppStarted()),
//           child: MaterialApp(
//             title: 'Crypto App',
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               primaryColor: Colors.black,
//               accentColor: Colors.blue,
//             ),
//             home: HomeScreen(),
//           ),
//        ),
//       ),
//     );
//   }
// }
