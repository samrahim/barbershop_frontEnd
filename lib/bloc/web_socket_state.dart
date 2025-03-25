part of 'web_socket_bloc.dart';

@immutable
sealed class WebSocketState extends Equatable {}

class WebSocketInitial extends WebSocketState {
  @override
  List<Object?> get props => [];
}

class WebSocketConnected extends WebSocketState {
  final List<Map<String, String>> bookings;

  WebSocketConnected(this.bookings);

  @override
  List<Object> get props => [bookings];
}
