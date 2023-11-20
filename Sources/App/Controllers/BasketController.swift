
import Vapor
import Fluent

struct BasketController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("basket") { basket in
            
            basket.group(UserAuthenticator()) { baskets in
                baskets.get(use: getAllProductsInBasket)
                baskets.group("order") { order in
                    order.put("create", use: createOrder)
                    order.get("total-price", use: getBasketAmount)
                }
                baskets.group(":productID") { productID in
                    productID.post("add-product", use: addProduct)
                    productID.put("update-product-quantity", use: updateProductQuantity)
                    productID.delete("delete-product", use: deleteProduct)
                }
                
            }
        }
    }
    private func createOrder(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.getPayload()
        
        return try getBasketAmount(req)
            .flatMap { totalPrice in
                return req.baskets
                    .findByUserId(userId: payload.userID)
                    .flatMap { basket in
                        guard let basketID = basket?.id else {
                            return req.eventLoop
                                .makeFailedFuture(BasketError.invalidIDBasket)
                        }
                        
                        return req.cashAccounts
                            .findByUserId(userId: payload.userID)
                            .flatMap { cashAccount in
                                guard let userCashAccount = cashAccount else {
                                    return req.eventLoop
                                        .makeFailedFuture(CashAccountError.cashAccountNotFound)
                                }
                                
                                let userBalance = userCashAccount.balance
                                
                                if userBalance < totalPrice {
                                    return req.eventLoop
                                        .makeFailedFuture(CashAccountError.noMoneyInAccount)
                                } else {
                                    return req.basketProducts
                                        .deleteByBasket(basketId: basketID).flatMap { _ in
                                            userCashAccount.balance = (userBalance - totalPrice)
                                            return req.cashAccounts
                                                .update(userCashAccount)
                                                .transform(to: .ok)
                                        }
                                    
                                    
                                }
                            }
                    }
            }
    }
    
    private func getBasketAmount(_ req: Request) throws -> EventLoopFuture<Double> {
        let payload = try req.getPayload()

        return req.baskets.findByUserId(userId: payload.userID)
            .flatMap { basket in
                guard let basketID = basket?.id else {
                    return req.eventLoop
                        .makeSucceededFuture(0.0)
                }
                return req.basketProducts
                    .findAllByBasketId(basketID)
                    .flatMap { basketProducts in
                        let totalPrices = basketProducts.map { basketProduct in
                            return req.products
                                .find(id: basketProduct.productId)
                                .unwrap(or: BasketError.basketProductNotFound)
                                .map { product in
                                    return product.price * Double(basketProduct.quantity)
                                }
                        }
                        return EventLoopFuture.whenAllSucceed(totalPrices, on: req.eventLoop)
                            .map { totalPrices in
                                let totalSum = totalPrices.reduce(0.0, +)
                                return totalSum
                            }
                    }
            }
    }

    
    private func getAllProductsInBasket(_ req: Request) throws -> EventLoopFuture<[BasketProductDTO]> {
        let payload = try req.getPayload()
        
        return req.baskets.findByUserId(userId: payload.userID)
            .flatMap { basket in
                guard let basketID = basket?.id else {
                    return req.eventLoop
                        .makeSucceededFuture([BasketProductDTO(product: ProductDTO(from: Product()), quantity: 0)])
                }
                return req.basketProducts
                    .findAllByBasketId(basketID)
                    .flatMap { basketProducts in
                        let productFutures = basketProducts
                            .map { basketProduct in
                                return req.products
                                    .find(id: basketProduct.productId)
                                    .unwrap(or: BasketError.basketProductNotFound)
                                    .map { product in
                                        return BasketProductDTO(product: ProductDTO(from: product), quantity: basketProduct.quantity)
                                    }
                            }
                        return EventLoopFuture.whenAllSucceed(productFutures, on: req.eventLoop)
                    }
            }
    }
    
    private func addProduct(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.getPayload()
        let productID = try req.getProductByID()
        let quantity = try req.content.decode(AddProductToBasketRequest.self)
        
        return req.baskets
            .findByUserId(userId: payload.userID).flatMap { basket in
                guard let basketID = basket?.id else {
                    return req.eventLoop
                        .makeFailedFuture(BasketError.invalidIDBasketProduct)
                }
                return req.basketProducts
                    .findByBasketAndProductId(basketId: basketID, productId: productID)
                    .flatMap { basketProduct in
                        if basketProduct != nil {
                            return req.eventLoop
                                .makeSucceededFuture(.badRequest)
                        } else {
                            return BasketProduct(basketID: basketID,
                                                 productID: productID,
                                                 quantity: quantity.quantity)
                            .create(on: req.db)
                            .map { .ok }
                        }
                    }
            }
    }
    
    private func updateProductQuantity(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.getPayload()
        let productID = try req.getProductByID()
        let quantity = try req.content.decode(AddProductToBasketRequest.self)
        
        return req.baskets.findByUserId(userId: payload.userID).flatMap { basket in
            guard let basketID = basket?.id else {
                return req.eventLoop
                    .makeFailedFuture(BasketError.invalidIDBasketProduct)
            }
            
            return req.basketProducts.findByBasketAndProductId(basketId: basketID, productId: productID)
                .flatMap { basketProduct in
                    guard let basketProduct = basketProduct else {
                        return req.eventLoop.makeFailedFuture(BasketError.basketProductNotFound)
                    }
                    
                    basketProduct.quantity = quantity.quantity
                    
                    return req.basketProducts.update(basketProduct).map { _ in
                        return .ok
                    }
                }
        }
    }
    
    private func deleteProduct(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        let payload = try req.getPayload()
        let productID = try req.getProductByID()
        
        return req.baskets.findByUserId(userId: payload.userID).flatMap { basket in
            guard let basketID = basket?.id else {
                return req.eventLoop
                    .makeFailedFuture(BasketError.invalidIDBasketProduct)
            }
            return req.basketProducts
                .deleteByBasketAndProductId(basketId: basketID, productId: productID)
                .transform(to: .ok)
        }
    }
    
    //    func getTotalPriceBasketProduct(_ req: Request) throws -> EventLoopFuture<Double> {
    //        let payload = try req.getPayload()
    //        let order = try req.content.decode(CreateOrderBasketRequest.self)
    //
    //            let idNumbers = order.productsInOrder.map { $0.idNumber }
    //
    //            let idNumberWithPrice = req.products.findAllByIDNumber(idNumbers: idNumbers)
    //                .map { orderProducts in
    //                    orderProducts.compactMap { product in
    //                        if let price = product?.price, let idNumber = product?.idNumber {
    //                            return [price: idNumber]
    //                        }
    //                        return nil
    //                    }
    //                }
    //
    //            let quantities = order.productsInOrder.reduce(into: [String: Int]()) { result, product in
    //                result[product.idNumber] = product.quantity
    //            }
    //
    //            return idNumberWithPrice.map { idNumberPriceDict in
    //                idNumberPriceDict.reduce(0.0) { totalPrice, dict in
    //                    if let idNumber = dict.values.first, let price = dict.keys.first, let quantity = quantities[idNumber] {
    //                        return totalPrice + (price * Double(quantity))
    //                    }
    //                    return totalPrice
    //                }
    //            }
    }


