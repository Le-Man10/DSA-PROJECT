import ballerina/grpc;

listener grpc:Listener ep = new (9090);
enum ProductStatuss {
    Available ,
    Out_Of_Stock 
}
type Products record {
    string name ;
    string description;
    float price ;
    int stock_quantity;

    // sku = product code
    readonly string sku;
    ProductStatus status;
};

enum userType {
    Customer ,
    Admin 
}

type User record{
    readonly string username;
    string email ;
    string password;
    UserType user ;
};
table<User> key(username) UserTable = table[];

table<Products> key(sku) productTable = table[];

@grpc:Descriptor {value: ONLINE_SHOP_DESC}
service "OnlineShoppingService" on ep {

    //remote function add_product(UpdateProductReq value) returns UpdateProductResp|error {
    //}
    remote function add_product(AddProductReq value) returns AddProductResp|error {
        Products payload = check value.fromJsonWithType(Products);
        if productTable.hasKey(payload.sku){
            return error("Product already exists");
        }else {
            productTable.add(payload);
            AddProductResp resp = {product_code: "Product has been successfully added"};
            return resp;
        }
    }

    //remote function update_product(UpdateProductReq value) returns UpdateProductResp|error {
    //}

    //remote function remove_product(RemoveProductReq value) returns RemoveProductResp|error {
    //}

    remote function remove_product (RemoveProductReq value) returns ListAvailableProductsResp|error {
        string sku = value.sku;

        if productTable.hasKey(sku) {
            Products removedProduct = productTable.remove(sku);

            // Prepare the response with the updated list of products
            ListAvailableProductsResp response = {
                products: from Products product in productTable 
            select {
                name: product.name,
                description: product.description,
                stock_quantity: product.stock_quantity,
                sku: product.sku,
                status: product.status
            }
        };
            return response;
        }
        else {
            return error("Product not found for SKU: " + sku);
        }
    }

    //remote function list_available_products(ListAvailableProductsReq value) returns ListAvailableProductsResp|error {
    //}

    remote function list_available_products(ListAvailableProductsReq listReq) returns ListAvailableProductsResp {
        ListAvailableProductsResp response = {
            products: from Products product in productTable 
            select {
                name: product.name,
                description: product.description,
                stock_quantity: product.stock_quantity,
                sku: product.sku,
                status: product.status
            }
        };
        return response;
    }


    //remote function search_product(SearchProductReq value) returns SearchProductResp|error {
    //}

    remote function search_product(SearchProductReq value) returns Product|error {
        foreach var product in productTable {

           if (product.sku == value.sku) {
               Product response={name: product.name, description:product.description, price:product.price, stock_quantity:product.stock_quantity, sku:product.sku,status:product.status};
                return response;    
            }
        }
        return error("Product not found.");     
    }

    //remote function add_to_cart(AddToCartReq value) returns AddToCartResp|error {
    //}

    //remote function place_order(PlaceOrderReq value) returns PlaceOrderResp|error {
    //}

    remote function create_users(stream<CreateUsersReq, grpc:Error?> clientStream) returns CreateUsersResp|error {
        int totalCount = 0;
        int fcount = 0;
        string []usernameExistsError=[];
        CreateUsersResp resp = {message: ""};
        CreateUsersResp|grpc:Error? r = check clientStream.forEach(function(CreateUsersReq req){
            totalCount = totalCount+1;
            var user = req.fromJsonWithType(User);
            if(user is User){
                if (user.username == ""){
                    fcount = fcount+1;
                }
                else {
                    if UserTable.hasKey(user.username){
                        fcount = fcount+1;
                        usernameExistsError.push(user.username);
                    }
                    else {
                        UserTable.add(user);
                    }
                }
            }
            else {
                resp = {message: "Please enter in json format"};
                return;
            }
        
        });

        if(r is grpc:Error){
            return r;
        }
        else if (r is CreateUsersResp) {
            resp = r;
        }
        else {
            resp = {message: fcount.toString() + " out of " + totalCount.toString() + " Users have been created. The following users already exist in the system "+usernameExistsError.toString()};
        }
        return resp; 
    }
}

