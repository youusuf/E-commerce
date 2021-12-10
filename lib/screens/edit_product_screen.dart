import 'package:e_commerce/providers/product.dart';
import 'package:e_commerce/providers/products.dart';

import 'package:e_commerce/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}
class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final imageUrlFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var isInit = true;
  var isLoading = false;
  var edittedProduct = Product(
    id: null,
    title: "",
    description: "",
    price: 0,
    imageUrl: ""
  );

  var initValue ={
    'title':'',
    'description':'',
    'price':'',
    'imageUrl': '',
  };
  Future<void> saveForm()async{
   var validate =  formKey.currentState!.validate();
   if(!validate){
     return;    
   }
    setState(() {
      isLoading = true;
    });
      formKey.currentState!.save();
      if(edittedProduct.id!=null){
        try{
          await Provider.of<Products>(context,listen: false).updateProduct(edittedProduct.id!, edittedProduct);
        }catch(error){
          await showDialog(context: context, builder:(context){
              return AlertDialog(
                title:const Text('An error occurred'),
                content:const Text("Update is not working"),
                actions: [
                  TextButton(onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>UserProductScreen()));
                  }, 
                  child:const Text("Okay")
                  )
                ],
              );
            }      
            );

        }
         
      }else{
        try{
          await Provider.of<Products>(context,listen: false).addProduct(edittedProduct);
        }catch(error){
          await showDialog(context: context, builder:(context){
              return AlertDialog(
                title:const Text('An error occurred'),
                content:const Text("Something went wrong"),
                actions: [
                  TextButton(onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>UserProductScreen()));
                  }, 
                  child:const Text("Okay")
                  )
                ],
              );
            }      
            );
        }         
      }  
      setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();        
  }
  @override
  void didChangeDependencies() {
    if(isInit){
      var prodId = ModalRoute.of(context)!.settings.arguments as String;
      if(prodId!=null){
        edittedProduct = Provider.of<Products>(context,listen: false).findById(prodId);
      initValue = {
         'title':edittedProduct.title!,
         'description':edittedProduct.description!,
         'price':edittedProduct.price!.toString(),
         'imageUrl':'',
      };     
       imageUrlController.text = edittedProduct.imageUrl!;
      }
    }
    isInit = false;
    
    super.didChangeDependencies();
  }

 
    
  @override
  void dispose() {
  priceFocusNode.dispose();
  descriptionFocusNode.dispose();
  imageUrlFocusNode.removeListener(updateImage);
  imageUrlFocusNode.dispose();
  imageUrlController.dispose();
 
    super.dispose();
  }
  @override
  void initState() {
    imageUrlFocusNode.addListener(updateImage);
    super.initState();
  }
  void updateImage(){
    if(!imageUrlFocusNode.hasFocus){
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(
        title:const Text("Edit Product"),
        actions: [
          IconButton(
          onPressed:saveForm, 
          icon: const Icon(Icons.save)
          )
        ],
      ),
      body: isLoading?
      const Center(
        child: CircularProgressIndicator()
      ):
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(children: [
            TextFormField(
              initialValue: initValue['title'],
              decoration: InputDecoration(
                labelText: "Title",
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.purple,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:  BorderSide(
                    color: Colors.grey.withOpacity(0.8),
                    width: 2.0,
                  ),
                ),
              ),
              validator:(value){

                        if(value!.isEmpty){
                          return 'Please enter Title';
                        }
                        return null;

              },
             
              textInputAction: TextInputAction.next,
              onFieldSubmitted:(_){
                FocusScope.of(context).requestFocus(priceFocusNode);
              },
              onSaved:(value){
                edittedProduct = Product(
                  id: edittedProduct.id,
                  isFavorite: edittedProduct.isFavorite,
                  title: value,
                  description: edittedProduct.description,
                  price:edittedProduct.price,
                  imageUrl: edittedProduct.imageUrl
                );
              },
            ),
           const SizedBox(height: 15,),
            TextFormField(
              initialValue: initValue['price'],
               textInputAction: TextInputAction.next,             
              decoration: InputDecoration(
                labelText: "Price",
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.purple,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:  BorderSide(
                    color: Colors.grey.withOpacity(0.8),
                    width: 2.0,
                  ),
                ),
              ),
              validator:(value){
                if(value!.isEmpty){
                  return "Please Enter Something";
                }
                if(double.tryParse(value)==null){
                  return "Please Enter a Valid number";
                }
                if(double.parse(value)<=0){
                  return "Please Enter valid price";
                }
                return null;
              },
              
             keyboardType: TextInputType.number,
             onFieldSubmitted:(_){
               FocusScope.of(context).requestFocus(descriptionFocusNode);
             },
             onSaved:(value){
               edittedProduct = Product(
                  id: edittedProduct.id,
                  isFavorite: edittedProduct.isFavorite,
                  title: edittedProduct.title,
                  description: edittedProduct.description,
                  price:double.parse(value!),
                  imageUrl: edittedProduct.imageUrl
                );
              },
             focusNode: priceFocusNode,
            ),
           const SizedBox(height: 15,),
            TextFormField(
              maxLines: 3,
              initialValue: initValue['description'],
              decoration: InputDecoration(
                labelText: "Description",
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.purple,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:  BorderSide(
                    color: Colors.grey.withOpacity(0.8),
                    width: 2.0,
                  ),
                ),
              ),
              validator: (value){
                if(value!.isEmpty){
                  return 'Please Enter Description';
                }
                if(value.length<10){
                  return 'Please Describe properly';
                }
                return null;
              },
              onSaved:(value){
                edittedProduct= Product(
                   id: edittedProduct.id,
                  isFavorite: edittedProduct.isFavorite,
                  title: edittedProduct.title,
                  description: value,
                  price:edittedProduct.price,
                  imageUrl: edittedProduct.imageUrl
                );
              },
             
             keyboardType: TextInputType.number,
             focusNode:descriptionFocusNode,
            ),
             const SizedBox(height: 15,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 10,right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                                  width: 2,
                                  color: Colors.grey
                      ),

                    ),
                    child: imageUrlController.text.isEmpty?const Center(
                      child: Text(
                        "Enter URl",
                        ),
                    ):FittedBox(
                      child: Image.network(
                        imageUrlController.text,
                        fit: BoxFit.cover,
                        ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      
                      focusNode: imageUrlFocusNode,
                      // initialValue: initValue['imageUrl'],
                      decoration:const InputDecoration(
                        label: Text("Image Url"),                     
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageUrlController,
                      onFieldSubmitted:(_){
                        saveForm();
                           
                      },   
                      validator:(value){
                        if(value!.isEmpty){
                          return "Please Enter URl";
                        }
                        if(!value.startsWith('hhtp')&&!value.startsWith('https')){
                          return 'Please enter a valid URL';
                        }
                        if(!value.endsWith('jpg') &&!value.endsWith('jpeg')&& !value.endsWith('png')){
                          return "Please enter a valid URL";
                        }
                        return null;

                      },
                      onSaved:(value){
                  edittedProduct = Product(
                  id: edittedProduct.id,
                  isFavorite: edittedProduct.isFavorite,
                  title: edittedProduct.title,
                  description: edittedProduct.description,
                  price:edittedProduct.price,
                  imageUrl: value
                );
              },
                                   
                    ),
                  )
              ],
              )
          ],),
        ),
      ),
    );
  }
}