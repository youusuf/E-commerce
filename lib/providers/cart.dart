import 'package:flutter/widgets.dart';
class CartItem{
   final String? id;
   final String? title;
   final int? quantity;
   final double? price;
   CartItem(
  {
    required this.id,
    required this.title,
    required this.quantity,
    required this.price
   });
}
class Cart with ChangeNotifier{
 Map<String,CartItem> _items = {};
 Map<String,CartItem> get items{
   return {..._items};
 }



int  get totalItem{
  return _items.length;
}
double get totalAmount{
  double total = 0.0;
  _items.forEach((key, value) {
    total+=value.price! * value.quantity!;
   });

  return total;
}

 void addItem(String? prodId,String? title, double? price){

   if(_items.containsKey(prodId)){
     _items.update(prodId!, (existing) => CartItem(
       id: existing.id,
       title: existing.title,
       quantity:existing.quantity! + 1,
       price: existing.price
     ));

   }
   else{
     _items.putIfAbsent(prodId!, () => CartItem(
       id: DateTime.now().toString(),
       title: title,
       price: price,
       quantity: 1
       )
      

       );
   }
   notifyListeners();

 }


 void removeItem(String prodId){
   _items.remove(prodId);
   notifyListeners();
 }


 void removeSingleItem(String prodId){
            if(!_items.containsKey(prodId)){
              return;
            }
            if(_items[prodId]!.quantity!>1){
                      _items.update(prodId, (existing) => CartItem(
                        id: existing.id,
                       title: existing.title, 
                       quantity: existing.quantity,
                        price: existing.price
                        ));
            }
            else{
              _items.remove(prodId);
            }
            notifyListeners();

 }



void clearCart(){
  _items = {};
  notifyListeners();
}


}