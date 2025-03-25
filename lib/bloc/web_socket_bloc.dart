import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  late IO.Socket socket;
  List<Map<String, String>> bookings = [];

  WebSocketBloc() : super(WebSocketInitial()) {
    // 🟢 Listen for WebSocket connection events once
    socket = IO.io('http://192.168.1.36:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      print("✅ WebSocket Connected");
    });

    socket.on("newAppointment", (data) {
      bookings = List.from(bookings); // 🟢 Create a new list (Immutable)

      bookings.add({
        "clientName": data["client_name"],
        "appointmentTime": data["appointment_time"],
      });

      add(UpdateBookings(List.from(bookings)));
    });

    socket.onDisconnect((_) => print("🔴 WebSocket Disconnected"));

    // 🟢 Register event handlers
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<UpdateBookings>(_onUpdateBookings);
  }

  Future<void> _onConnectWebSocket(
    ConnectWebSocket event,
    Emitter<WebSocketState> emit,
  ) async {
    socket.connect();
    socket.emit("joinBarber", event.barberId);
    emit(WebSocketConnected(bookings));
  }

  Future<void> _onUpdateBookings(
    UpdateBookings event,
    Emitter<WebSocketState> emit,
  ) async {
    emit(WebSocketConnected(event.bookings));
  }
}

// 🟢 New Event for Booking Updates
