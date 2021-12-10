import 'package:e_commerce/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CartWidget extends StatelessWidget {
  final String prodId;
  final String id;
  final double price;
  final int quantity;
  final String title;
  CartWidget(this.prodId,this.id,this.price,this.quantity,this.title);
  @override
  Widget build(BuildContext context) {
    return  Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        child:const Icon(Icons.delete,color: Colors.white,size: 40,),
        alignment: Alignment.centerRight,
         margin:const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss:(direction){
             return showDialog(context: context, builder:(context)=> AlertDialog(
                        title: const Text("Are you Sure?"),
                        content: const Text("Do you want to remove the item from cart?"),
                        actions: [
                          TextButton(onPressed:(){
                                    Navigator.of(context).pop(true);
                          },
                           child:const Text('Yes')),
                           TextButton(onPressed:(){
                              Navigator.of(context).pop(false);

                          },
                           child:const Text('No')),

                        ],
              ));
      },
      onDismissed:(direction){
            Provider.of<Cart>(context,listen: false).removeItem(prodId);

      },
      child: Card(
        margin:const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        child: Padding(
          padding:const EdgeInsetsDirectional.all(10.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(child: Text("\$$price")),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total \$${price * quantity}'),
            trailing: Text("$quantity X"),
          ),
        ),
      ),
    );
  }
}