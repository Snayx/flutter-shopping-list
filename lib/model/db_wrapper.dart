
import 'package:flutter_todos/model/model.dart';
import 'package:flutter_todos/model/db.dart';
import 'profilemodel.dart';

class DBWrapper {
  static final DBWrapper sharedInstance = DBWrapper._();

  DBWrapper._();

  Future<List<Product>> getProducts() async {
    List list = await DB.sharedInstance.retrieveProducts();
    return list;
  }
  Future<List<Profile>> getCurrentProfile() async {
    List profile = await DB.sharedInstance.getProfile();
    return profile;
  }

  Future<List<Product>> getDones() async {
    List list = await DB.sharedInstance.retrieveProducts(status: ProductStatus.done);
    return list;
  }

  void addProduct(Product product) async {
    await DB.sharedInstance.createProduct(product);
  }

  void addProfile(Profile newProfile) async {
    await DB.sharedInstance.createProfile(newProfile);
  }
  void updateProfile(Profile profile) async {
    await DB.sharedInstance.updateProfile(profile);
  }

  void markProductAsDone(Product product) async {
    product.status = ProductStatus.done.index;
    product.updated = DateTime.now();
    await DB.sharedInstance.updateProduct(product);
  }

  void markDoneAsProduct(Product product) async {
    product.status = ProductStatus.active.index;
    product.updated = DateTime.now();
    await DB.sharedInstance.updateProduct(product);
  }

  void deleteProduct(Product product) async {
    await DB.sharedInstance.deleteProduct(product);
  }

  void deleteAllDoneProduct() async {
    await DB.sharedInstance.deleteAllProducts();
  }
}
