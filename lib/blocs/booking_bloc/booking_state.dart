part of 'booking_bloc.dart';

class BookingState extends Equatable {
  final List<Service> services;
  final List<Days> days;
  final List<String> slots;
  final bool isLoading;

  const BookingState({
    required this.services,
    required this.days,
    required this.slots,
    required this.isLoading,
  });
  @override
  List<Object> get props => [services, days, slots, isLoading];
  BookingState copyWith({
    List<Service>? services,
    List<Days>? days,
    List<String>? slots,
    bool? isLoading,
    int? selectedDate,
  }) {
    return BookingState(
      services: services ?? this.services,
      days: days ?? this.days,
      slots: slots ?? this.slots,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
