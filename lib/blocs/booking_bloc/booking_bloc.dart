import 'dart:convert';

import 'package:barberfront/main.dart';
import 'package:barberfront/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc()
    : super(BookingState(services: [], days: [], slots: [], isLoading: false)) {
    on<FetchServices>(_fetchServices);
    on<FetchDays>(_fetchDays);
    on<FetchTimeSlots>(_fetchTimeSlots);
    on<ToggleService>(_toggleService);
    on<MakeBooking>(_makeBooking);
  }

  Future<void> _fetchServices(
    FetchServices event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await http.get(
        Uri.parse("http://localhost:8000/client/1/service"),
      );
      Map<String, dynamic> body2 = json.decode(response.body);
      List body = body2['hairdresser_services'];
      List<Service> services = body.map((e) => Service.fromJson(e)).toList();

      emit(state.copyWith(services: services));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _fetchDays(FetchDays event, Emitter<BookingState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      List<Days> days = [];
      final response = await http.get(
        Uri.parse("http://localhost:8000/hairdresser/1/availability"),
      );

      Map<String, dynamic> body2 = json.decode(response.body);
      List body = body2['dates'];
      days = body.map((e) => Days.fromJson(e)).toList();

      emit(state.copyWith(days: days, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _fetchTimeSlots(
    FetchTimeSlots event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await http.get(
        Uri.parse(
          "http://localhost:8000/hairdresser/1/planing?start_day=${event.selectedDate}",
        ),
      );

      List data = json.decode(response.body);
      if (data.isEmpty) {
        final updatedDays =
            state.days.map((d) {
              return d.copyWith(isSelected: d.day == event.selectedDate);
            }).toList();
        emit(
          state.copyWith(
            slots: List.from([]),
            isLoading: false,
            days: updatedDays,
          ),
        );
        return;
      }
      String startTime = data[0]['start_time'];
      String endTime = data[0]['end_time'];
      int duration = data[0]['duration'];

      List<String> slots = getTimeSlots(startTime, endTime, duration);
      final updatedDays =
          state.days.map((d) {
            return d.copyWith(isSelected: d.day == event.selectedDate);
          }).toList();

      emit(
        state.copyWith(
          slots: List.from(slots),
          isLoading: false,
          days: updatedDays,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _toggleService(ToggleService event, Emitter<BookingState> emit) {
    List<Service> updatedServices =
        state.services.map((e) {
          if (e == event.service) {
            return event.service.copyWith(
              isSelected: !event.service.isSelected,
            );
          }
          return e;
        }).toList();

    emit(state.copyWith(services: updatedServices));
  }

  Future<void> _makeBooking(
    MakeBooking event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      List<String> selectedServices = [];

      for (var selected in state.services) {
        if (selected.isSelected) {
          selectedServices.add(selected.id.toString());
        }
      }
      String selectedDay = '';
      for (var day in state.days) {
        if (day.isSelected) {
          selectedDay = day.day!;
        }
      }
      final bookingData = {
        'services': selectedServices,
        'day': selectedDay,
        'slot': state.slots,
      };
      print(bookingData['day']);

      // Send the booking data to the backend API
      // final response = await http.post(
      //   Uri.parse("http://localhost:8000/bookings"),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(bookingData),
      // );

      // if (response.statusCode == 201) {
      // } else {}
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
