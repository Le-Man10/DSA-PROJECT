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
table<Products> key(sku) productTable = table[];

@grpc:Descriptor {value: ONLINE_SHOP_DESC}
service "OnlineShoppingService" on ep {

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

    //remote function list_available_products(ListAvailableProductsReq value) returns ListAvailableProductsResp|error {
    //}

    //remote function search_product(SearchProductReq value) returns SearchProductResp|error {
    //}

    //remote function add_to_cart(AddToCartReq value) returns AddToCartResp|error {
    //}

    //remote function place_order(PlaceOrderReq value) returns PlaceOrderResp|error {
    //}

    //remote function create_users(stream<CreateUsersReq, grpc:Error?> clientStream) returns CreateUsersResp|error {
    //}
}

