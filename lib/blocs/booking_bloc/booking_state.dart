part of 'booking_bloc.dart';

class BookingState extends Equatable {
  final List<Service> services;
  final List<Days> days;
  final List<String> slots;
  final bool isLoading;
  final String selectedSlot;
  const BookingState({
    required this.selectedSlot,
    required this.services,
    required this.days,
    required this.slots,
    required this.isLoading,
  });
  @override
  BookingState copyWith({
    String? selectedSlot,
    List<Service>? services,
    List<Days>? days,
    List<String>? slots,
    bool? isLoading,
  }) {
    return BookingState(
      selectedSlot: selectedSlot ?? this.selectedSlot,
      services: services ?? this.services,
      days: days ?? this.days,
      slots: slots ?? this.slots,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [services, days, slots, isLoading, selectedSlot];
}
