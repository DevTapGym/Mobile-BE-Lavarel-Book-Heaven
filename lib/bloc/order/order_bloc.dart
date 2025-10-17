import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaven_book_app/bloc/order/order_event.dart';
import 'package:heaven_book_app/bloc/order/order_state.dart';
import 'package:heaven_book_app/services/order_service.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderService _orderService;

  OrderBloc(this._orderService) : super(OrderInitial()) {
    on<LoadAllOrders>(_onLoadCategories);
    on<LoadDetailOrder>(_onLoadDetailOrder);
    on<PlaceOrder>(_onPlaceOrder);
    on<CreateOrder>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final success = await _orderService.createOrder(
        note: event.note,
        paymentMethod: event.paymentMethod,
        phone: event.phone,
        address: event.address,
        name: event.name,
        items: event.items,
      );
      if (success) {
        final orders = await _orderService.loadAllOrder();
        emit(
          OrderLoaded(orders: orders, message: 'Order created successfully'),
        );
      } else {
        emit(OrderError('Failed to create order'));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final success = await _orderService.placeOrder(
        event.note ?? '',
        event.paymentMethod,
        event.cartId,
        event.phone,
        event.address,
        event.name,
      );
      if (success) {
        final orders = await _orderService.loadAllOrder();
        emit(OrderLoaded(orders: orders, message: 'Order placed successfully'));
      } else {
        emit(OrderError('Failed to place order'));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onLoadCategories(
    LoadAllOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await _orderService.loadAllOrder();
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onLoadDetailOrder(
    LoadDetailOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final order = await _orderService.loadDetailOrder(event.orderId);
      emit(OrderDetailLoaded(order: order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
