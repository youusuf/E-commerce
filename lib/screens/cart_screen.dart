import 'package:e_commerce/providers/cart.dart';
import 'package:e_commerce/providers/order.dart';
import 'package:e_commerce/widgets/cart_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class CartScreen extends StatelessWidget {
  static const routeName = '/cart'; 

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title:const Text("My Cart"),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 const  Text(
                    "Total ",
                    style: TextStyle(
                      fontSize: 25.0
                    ),
                  ),
               const Spacer(),
                  Chip(
                    backgroundColor: Colors.purple,
                    label:Text(
                      '\$${cart.totalAmount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15
                      )
                    ),
                    
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder:(context,index){
              return CartWidget(
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].id!,
                cart.items.values.toList()[index].price!,
                cart.items.values.toList()[index].quantity!,
                cart.items.values.toList()[index].title!
              );
            },
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
 var isLoading = false;


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount<=0 || isLoading) ? null : ()async{
        setState(() {
          isLoading = true;
        });
       await Provider.of<Order>(context,listen: false).addOrders(
          widget.cart.items.values.toList(), 
          widget.cart.totalAmount  
          );
          setState(() {
            isLoading = false;
          });
          widget.cart.clearCart();

      }, 
    child:isLoading?const CircularProgressIndicator(): 
     const  Text(
        "ORDER NOW",
        style: TextStyle(
        fontSize: 16.0
        ),
        )
    );
  }
}