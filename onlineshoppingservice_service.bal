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
table<User> key(username) UserTable = table[{username: "alice_walker", email: "alice.walker@example.com", password: "alice123", user: Customer},
    {username: "brian_james", email: "brian.james@example.com", password: "brianPass", user: Customer},
    {username: "carla_fern", email: "carla.fern@example.com", password: "carlaPass", user: Admin},
    {username: "david_johnson", email: "david.johnson@example.com", password: "david123", user: Customer},
    {username: "eve_luna", email: "eve.luna@example.com", password: "evePass", user: Admin}
];

table<Products> key(sku) productTable = table[{name: "Tablet", description: "10-inch Android tablet", price: 3000.00, stock_quantity: 12, sku: "PROD005", status: Available},
    {name: "Smartwatch", description: "Water-resistant fitness smartwatch", price: 2000.00, stock_quantity: 7, sku: "PROD006", status: Available},
    {name: "Wireless Charger", description: "Fast wireless charging pad", price: 500.00, stock_quantity: 20, sku: "PROD007", status: Available},
    {name: "Bluetooth Speaker", description: "Portable Bluetooth speaker with deep bass", price: 1000.00, stock_quantity: 18, sku: "PROD008", status: Out_Of_Stock},
    {name: "External Hard Drive", description: "1TB external USB hard drive", price: 800.00, stock_quantity: 25, sku: "PROD009", status: Available}];

@grpc:Descriptor {value: ONLINE_SHOP_DESC}
service "OnlineShoppingService" on ep {

    //remote function add_product(UpdateProductReq value) returns UpdateProductResp|error {
    //}
    remote function add_product(AddProductReq value) returns AddProductResp|error {
        Product payload ;
        Products product;
        payload = value.product;
        product = {...payload};
        if productTable.hasKey(product.sku){
            return error("Product already exists");
        }else {
            productTable.add(product);
            AddProductResp resp = {product_code: "Product has been successfully added"};
            return resp;
        }
    }

    //remote function update_product(UpdateProductReq value) returns UpdateProductResp|error {
    //}

    remote function update_product(UpdateProductReq value) returns UpdateProductResp|error {
        if productTable.hasKey(value.sku) {
            Products updatedProduct = check value.updated_product.fromJsonWithType(Products);
            productTable.put(updatedProduct);
            UpdateProductResp resp = {message: "Product has been successfully updated"};
            return resp;
        } else {
            return error("Product not found");
        }
    }


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
            where product.status == Available 
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

