import ballerina/io;

OnlineShoppingServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    AddProductReq add_productRequest = {product: {name: "ballerina", description: "ballerina", price: 1, stock_quantity: 1, sku: "ballerina", status: "Available"}};
    AddProductResp add_productResponse = check ep->add_product(add_productRequest);
    io:println(add_productResponse);

    UpdateProductReq update_productRequest = {sku: "ballerina", updated_product: {name: "ballerina", description: "ballerina", price: 1, stock_quantity: 1, sku: "ballerina", status: "Available"}};
    UpdateProductResp update_productResponse = check ep->update_product(update_productRequest);
    io:println(update_productResponse);

    RemoveProductReq remove_productRequest = {sku: "ballerina"};
    RemoveProductResp remove_productResponse = check ep->remove_product(remove_productRequest);
    io:println(remove_productResponse);

    ListAvailableProductsReq list_available_productsRequest = {};
    ListAvailableProductsResp list_available_productsResponse = check ep->list_available_products(list_available_productsRequest);
    io:println(list_available_productsResponse);

    SearchProductReq search_productRequest = {sku: "ballerina"};
    Product search_productResponse = check ep->search_product(search_productRequest);
    io:println(search_productResponse);

    AddToCartReq add_to_cartRequest = {sku: "ballerina", user_id: "ballerina"};
    AddToCartResp add_to_cartResponse = check ep->add_to_cart(add_to_cartRequest);
    io:println(add_to_cartResponse);

    PlaceOrderReq place_orderRequest = {user_id: "ballerina"};
    PlaceOrderResp place_orderResponse = check ep->place_order(place_orderRequest);
    io:println(place_orderResponse);

    CreateUsersReq create_usersRequest = {message: "ballerina"};
    Create_usersStreamingClient create_usersStreamingClient = check ep->create_users();
    check create_usersStreamingClient->sendCreateUsersReq(create_usersRequest);
    check create_usersStreamingClient->complete();
    CreateUsersResp? create_usersResponse = check create_usersStreamingClient->receiveCreateUsersResp();
    io:println(create_usersResponse);
}

