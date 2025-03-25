part of 'web_socket_bloc.dart';

@immutable
sealed class WebSocketEvent extends Equatable {}

class ConnectWebSocket extends WebSocketEvent {
  final int barberId;

  ConnectWebSocket(this.barberId);

  @override
  List<Object> get props => [barberId];
}

class NewBookingReceived extends WebSocketEvent {
  final String clientName;
  final String appointmentTime;

  NewBookingReceived(this.clientName, this.appointmentTime);

  @override
  List<Object> get props => [clientName, appointmentTime];
}

class UpdateBookings extends WebSocketEvent {
  final List<Map<String, String>> bookings;
  UpdateBookings(this.bookings);

  @override
  // TODO: implement props
  List<Object?> get props => [bookings];
}
