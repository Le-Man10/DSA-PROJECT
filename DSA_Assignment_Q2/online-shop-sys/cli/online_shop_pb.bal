import ballerina/grpc;
import ballerina/protobuf;

public const string ONLINE_SHOP_DESC = "0A116F6E6C696E655F73686F702E70726F746F120B6F6E6C696E655F73686F7022C2010A0750726F6475637412120A046E616D6518012001280952046E616D6512200A0B6465736372697074696F6E180220012809520B6465736372697074696F6E12140A0570726963651803200128015205707269636512250A0E73746F636B5F7175616E74697479180420012805520D73746F636B5175616E7469747912100A03736B751805200128095203736B7512320A0673746174757318062001280E321A2E6F6E6C696E655F73686F702E50726F647563745374617475735206737461747573223F0A0D41646450726F64756374526571122E0A0770726F6475637418012001280B32142E6F6E6C696E655F73686F702E50726F64756374520770726F6475637422330A0E41646450726F647563745265737012210A0C70726F647563745F636F6465180120012809520B70726F64756374436F646522630A1055706461746550726F6475637452657112100A03736B751801200128095203736B75123D0A0F757064617465645F70726F6475637418022001280B32142E6F6E6C696E655F73686F702E50726F64756374520E7570646174656450726F64756374222D0A1155706461746550726F647563745265737012180A076D65737361676518012001280952076D65737361676522240A1052656D6F766550726F6475637452657112100A03736B751801200128095203736B7522540A1152656D6F766550726F6475637452657370123F0A10757064617465645F70726F647563747318012003280B32142E6F6E6C696E655F73686F702E50726F64756374520F7570646174656450726F6475637473221A0A184C697374417661696C61626C6550726F6475637473526571224D0A194C697374417661696C61626C6550726F64756374735265737012300A0870726F647563747318012003280B32142E6F6E6C696E655F73686F702E50726F64756374520870726F647563747322240A1053656172636850726F6475637452657112100A03736B751801200128095203736B75225D0A1153656172636850726F6475637452657370122E0A0770726F6475637418012001280B32142E6F6E6C696E655F73686F702E50726F64756374520770726F6475637412180A076D65737361676518022001280952076D65737361676522390A0C416464546F4361727452657112100A03736B751801200128095203736B7512170A07757365725F6964180220012809520675736572496422290A0D416464546F436172745265737012180A076D65737361676518012001280952076D65737361676522280A0D506C6163654F7264657252657112170A07757365725F6964180120012809520675736572496422450A0E506C6163654F726465725265737012190A086F726465725F696418012001280952076F72646572496412180A076D65737361676518022001280952076D657373616765225A0A0B5573657250726F66696C6512170A07757365725F6964180120012809520675736572496412320A09757365725F7479706518022001280E32152E6F6E6C696E655F73686F702E557365725479706552087573657254797065222B0A0F43726561746555736572735265737012180A076D65737361676518012001280952076D657373616765222A0A0E437265617465557365727352657112180A076D65737361676518012001280952076D6573736167652A230A085573657254797065120C0A08437573746F6D6572100012090A0541646D696E10012A300A0D50726F64756374537461747573120D0A09417661696C61626C65100012100A0C4F75745F4F665F53746F636B1001328D050A154F6E6C696E6553686F7070696E675365727669636512460A0B6164645F70726F64756374121A2E6F6E6C696E655F73686F702E41646450726F647563745265711A1B2E6F6E6C696E655F73686F702E41646450726F6475637452657370124F0A0E7570646174655F70726F64756374121D2E6F6E6C696E655F73686F702E55706461746550726F647563745265711A1E2E6F6E6C696E655F73686F702E55706461746550726F6475637452657370124F0A0E72656D6F76655F70726F64756374121D2E6F6E6C696E655F73686F702E52656D6F766550726F647563745265711A1E2E6F6E6C696E655F73686F702E52656D6F766550726F647563745265737012680A176C6973745F617661696C61626C655F70726F647563747312252E6F6E6C696E655F73686F702E4C697374417661696C61626C6550726F64756374735265711A262E6F6E6C696E655F73686F702E4C697374417661696C61626C6550726F647563747352657370124B0A0C6372656174655F7573657273121B2E6F6E6C696E655F73686F702E43726561746555736572735265711A1C2E6F6E6C696E655F73686F702E437265617465557365727352657370280112450A0E7365617263685F70726F64756374121D2E6F6E6C696E655F73686F702E53656172636850726F647563745265711A142E6F6E6C696E655F73686F702E50726F6475637412440A0B6164645F746F5F6361727412192E6F6E6C696E655F73686F702E416464546F436172745265711A1A2E6F6E6C696E655F73686F702E416464546F436172745265737012460A0B706C6163655F6F72646572121A2E6F6E6C696E655F73686F702E506C6163654F726465725265711A1B2E6F6E6C696E655F73686F702E506C6163654F7264657252657370620670726F746F33";

public isolated client class OnlineShoppingServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ONLINE_SHOP_DESC);
    }

    isolated remote function add_product(AddProductReq|ContextAddProductReq req) returns AddProductResp|grpc:Error {
        map<string|string[]> headers = {};
        AddProductReq message;
        if req is ContextAddProductReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/add_product", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddProductResp>result;
    }

    isolated remote function add_productContext(AddProductReq|ContextAddProductReq req) returns ContextAddProductResp|grpc:Error {
        map<string|string[]> headers = {};
        AddProductReq message;
        if req is ContextAddProductReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/add_product", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddProductResp>result, headers: respHeaders};
    }

    isolated remote function update_product(UpdateProductReq|ContextUpdateProductReq req) returns UpdateProductResp|grpc:Error {
        map<string|string[]> headers = {};
        UpdateProductReq message;
        if req is ContextUpdateProductReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/update_product", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <UpdateProductResp>result;
    }

    isolated remote function update_productContext(UpdateProductReq|ContextUpdateProductReq req) returns ContextUpdateProductResp|grpc:Error {
        map<string|string[]> headers = {};
        UpdateProductReq message;
        if req is ContextUpdateProductReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/update_product", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <UpdateProductResp>result, headers: respHeaders};
    }

    isolated remote function remove_product(RemoveProductReq|ContextRemoveProductReq req) returns RemoveProductResp|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductReq message;
        if req is ContextRemoveProductReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/remove_product", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RemoveProductResp>result;
    }

    isolated remote function remove_productContext(RemoveProductReq|ContextRemoveProductReq req) returns ContextRemoveProductResp|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductReq message;
        if req is ContextRemoveProductReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/remove_product", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RemoveProductResp>result, headers: respHeaders};
    }

    isolated remote function list_available_products(ListAvailableProductsReq|ContextListAvailableProductsReq req) returns ListAvailableProductsResp|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableProductsReq message;
        if req is ContextListAvailableProductsReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/list_available_products", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ListAvailableProductsResp>result;
    }

    isolated remote function list_available_productsContext(ListAvailableProductsReq|ContextListAvailableProductsReq req) returns ContextListAvailableProductsResp|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableProductsReq message;
        if req is ContextListAvailableProductsReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/list_available_products", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ListAvailableProductsResp>result, headers: respHeaders};
    }

    isolated remote function search_product(SearchProductReq|ContextSearchProductReq req) returns Product|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductReq message;
        if req is ContextSearchProductReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/search_product", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Product>result;
    }

    isolated remote function search_productContext(SearchProductReq|ContextSearchProductReq req) returns ContextProduct|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductReq message;
        if req is ContextSearchProductReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/search_product", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Product>result, headers: respHeaders};
    }

    isolated remote function add_to_cart(AddToCartReq|ContextAddToCartReq req) returns AddToCartResp|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartReq message;
        if req is ContextAddToCartReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/add_to_cart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddToCartResp>result;
    }

    isolated remote function add_to_cartContext(AddToCartReq|ContextAddToCartReq req) returns ContextAddToCartResp|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartReq message;
        if req is ContextAddToCartReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/add_to_cart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddToCartResp>result, headers: respHeaders};
    }

    isolated remote function place_order(PlaceOrderReq|ContextPlaceOrderReq req) returns PlaceOrderResp|grpc:Error {
        map<string|string[]> headers = {};
        PlaceOrderReq message;
        if req is ContextPlaceOrderReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/place_order", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PlaceOrderResp>result;
    }

    isolated remote function place_orderContext(PlaceOrderReq|ContextPlaceOrderReq req) returns ContextPlaceOrderResp|grpc:Error {
        map<string|string[]> headers = {};
        PlaceOrderReq message;
        if req is ContextPlaceOrderReq {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("online_shop.OnlineShoppingService/place_order", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PlaceOrderResp>result, headers: respHeaders};
    }

    isolated remote function create_users() returns Create_usersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("online_shop.OnlineShoppingService/create_users");
        return new Create_usersStreamingClient(sClient);
    }
}

public isolated client class Create_usersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendCreateUsersReq(CreateUsersReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextCreateUsersReq(ContextCreateUsersReq message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveCreateUsersResp() returns CreateUsersResp|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <CreateUsersResp>payload;
        }
    }

    isolated remote function receiveContextCreateUsersResp() returns ContextCreateUsersResp|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <CreateUsersResp>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public type ContextCreateUsersReqStream record {|
    stream<CreateUsersReq, error?> content;
    map<string|string[]> headers;
|};

public type ContextRemoveProductReq record {|
    RemoveProductReq content;
    map<string|string[]> headers;
|};

public type ContextUpdateProductReq record {|
    UpdateProductReq content;
    map<string|string[]> headers;
|};

public type ContextProduct record {|
    Product content;
    map<string|string[]> headers;
|};

public type ContextPlaceOrderReq record {|
    PlaceOrderReq content;
    map<string|string[]> headers;
|};

public type ContextListAvailableProductsReq record {|
    ListAvailableProductsReq content;
    map<string|string[]> headers;
|};

public type ContextAddToCartResp record {|
    AddToCartResp content;
    map<string|string[]> headers;
|};

public type ContextListAvailableProductsResp record {|
    ListAvailableProductsResp content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersResp record {|
    CreateUsersResp content;
    map<string|string[]> headers;
|};

public type ContextAddToCartReq record {|
    AddToCartReq content;
    map<string|string[]> headers;
|};

public type ContextUpdateProductResp record {|
    UpdateProductResp content;
    map<string|string[]> headers;
|};

public type ContextRemoveProductResp record {|
    RemoveProductResp content;
    map<string|string[]> headers;
|};

public type ContextAddProductReq record {|
    AddProductReq content;
    map<string|string[]> headers;
|};

public type ContextAddProductResp record {|
    AddProductResp content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersReq record {|
    CreateUsersReq content;
    map<string|string[]> headers;
|};

public type ContextPlaceOrderResp record {|
    PlaceOrderResp content;
    map<string|string[]> headers;
|};

public type ContextSearchProductReq record {|
    SearchProductReq content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type RemoveProductReq record {|
    string sku = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type UserProfile record {|
    string user_id = "";
    UserType user_type = Customer;
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type UpdateProductReq record {|
    string sku = "";
    Product updated_product = {};
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type Product record {|
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string sku = "";
    ProductStatus status = Available;
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type PlaceOrderReq record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type SearchProductResp record {|
    Product product = {};
    string message = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type ListAvailableProductsReq record {|
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type AddToCartResp record {|
    string message = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type ListAvailableProductsResp record {|
    Product[] products = [];
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type AddToCartReq record {|
    string sku = "";
    string user_id = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type CreateUsersResp record {|
    string message = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type UpdateProductResp record {|
    string message = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type RemoveProductResp record {|
    Product[] updated_products = [];
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type AddProductReq record {|
    Product product = {};
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type AddProductResp record {|
    string product_code = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type PlaceOrderResp record {|
    string order_id = "";
    string message = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type CreateUsersReq record {|
    string message = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOP_DESC}
public type SearchProductReq record {|
    string sku = "";
|};

public enum UserType {
    Customer, Admin
}

public enum ProductStatus {
    Available, Out_Of_Stock
}

