part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {}

class FetchServices extends BookingEvent {
  @override
  List<Object?> get props => [];
}

class FetchDays extends BookingEvent {
  @override
  List<Object?> get props => [];
}

class FetchTimeSlots extends BookingEvent {
  final String selectedDate;

  FetchTimeSlots(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

class ToggleService extends BookingEvent {
  final Service service;
  ToggleService(this.service);

  @override
  List<Object?> get props => [service];
}

class SelectSlot extends BookingEvent {
  final String slot;

  SelectSlot({required this.slot});

  @override
  List<Object?> get props => [slot];
}

class MakeBooking extends BookingEvent {
  final List<Service> selectedServices;
  final String selectedDay;
  final String selectedSlot;

  MakeBooking({
    required this.selectedServices,
    required this.selectedDay,
    required this.selectedSlot,
  });

  @override
  List<Object> get props => [selectedServices, selectedDay, selectedSlot];
}
