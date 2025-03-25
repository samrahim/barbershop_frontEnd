import 'package:barberfront/bloc/web_socket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => WebSocketBloc())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WebSocketBloc>(context).add(ConnectWebSocket(1));

    return Scaffold(
      appBar: AppBar(),

      body: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          if (state is WebSocketConnected) {
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                print("websocket connected");
                final booking = state.bookings[index];
                if (booking.isEmpty) {
                  return Text("no booking");
                }
                if (booking.isNotEmpty) {
                  return ListTile(
                    title: Text("📅 ${booking["appointmentTime"]}"),
                    subtitle: Text("👤 Client: ${booking["clientName"]}"),
                  );
                }
                return null;
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
