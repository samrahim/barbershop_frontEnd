part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class FetchServices extends BookingEvent {}

class FetchDays extends BookingEvent {}

class FetchTimeSlots extends BookingEvent {
  final String selectedDate;

  const FetchTimeSlots(this.selectedDate);
}

class ToggleService extends BookingEvent {
  final Service service;
  const ToggleService(this.service);
}
