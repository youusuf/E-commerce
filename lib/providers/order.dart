import 'package:flutter/foundation.dart';
import 'cart.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
class OrderItem {
final String? id;
final double? amount;
final DateTime? dateTime;
final List<CartItem>? products;
OrderItem({
   this.id,
   this.amount,
   this.dateTime,
   this.products,
});
}
class Order with ChangeNotifier{
    List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }
    String? userIds;
    String? authToken;      
  void update(String? token,String? userId){
      authToken = token;
      userIds = userId;
      notifyListeners();
    }

    Future<void> fetchAndSetOrders()async{
     final url = 'https://e-commerce-f4dc3-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userIds.json/auth=$authToken';
      var dio = Dio();
      Response response;
           try{
              response = await dio.get(url);                 
      final List<OrderItem> loadedOrders = [];
      final extractedData = response.data as Map<String,dynamic>; 
           
      if(extractedData == null){
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
           id: orderId,
           amount:orderData['amount'], 
           dateTime: DateTime.parse(orderData['dateTime']),
           products: (orderData['product'] as List<dynamic>).map((item) => CartItem(
                id: item['id'],
                title:item['title'],
                quantity: item['quantity'],
                price: item['price'],
                )).toList()
            )) ;
      });
      _orders = loadedOrders;
      notifyListeners();
           }
           catch(error){
                 //print(error);
            }      
    }
Future<void> addOrders(List<CartItem> cartProduct, double total)async{
  final url = 'https://e-commerce-f4dc3-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userIds.json?auth=$authToken';
  final timeStamp = DateTime.now();
    var dio = Dio();
    final response = await dio.post(url,data:{
      'amount':total,
      'dateTime':timeStamp.toIso8601String(),
      'product':cartProduct.map((cp) => {
        'id':cp.id,
        'title':cp.title,
        'quantity':cp.quantity,
        'price':cp.price,
      }).toList(),
    });
    _orders.insert(0, OrderItem(
      id: response.data['name'],
      amount: total,
      dateTime: timeStamp,
      products: cartProduct
    ));
  notifyListeners();
  }
}