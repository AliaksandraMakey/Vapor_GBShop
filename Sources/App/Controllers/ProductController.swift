import Vapor
import Fluent

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("product") { product in
            product.post("create", use: createProduct)
            product.get(use: getAllProducts)
            
            product.group(":productID") { productID in
                productID.put(use: updateProduct)
                productID.get(use: getProduct)
                productID.delete(use: deleteProduct)
            }
        }
    }
    func createProduct(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let createProductRequest = try req.content.decode(CreateProductRequest.self)
        return Product.query(on: req.db)
            .filter(\.$idNumber == createProductRequest.idNumber)
            .first()
            .flatMap { existingProduct in
                do {
                    if let _ = existingProduct {
                        throw ProductError.productAlreadyExists
                    } else {
                        let product = try Product(from: createProductRequest, hash: "create_product")
                        return product.create(on: req.db)
                            .transform(to: .created)
                    }
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
            }
    }
    
    private func updateProduct(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw ProductError.invalidIDNumberProduct
        }
        let updateProductRequest = try req.content.decode(UpdateProductRequest.self)
        
        req.products.set(\.$idNumber, to: updateProductRequest.idNumber, for: productID)
        req.products.set(\.$name, to: updateProductRequest.name, for: productID)
        req.products.set(\.$status, to: updateProductRequest.status, for: productID)
        req.products.set(\.$rating, to: updateProductRequest.rating, for: productID)
        req.products.set(\.$price, to: updateProductRequest.price, for: productID)
        req.products.set(\.$image, to: updateProductRequest.image, for: productID)
        req.products.set(\.$shortDescription, to: updateProductRequest.shortDescription, for: productID)
        req.products.set(\.$description, to: updateProductRequest.description, for: productID)
        return req.eventLoop.makeSucceededFuture(.ok)
    }
    
    
    
    private func getAllProducts(_ req: Request) throws -> EventLoopFuture<[ProductDTO]> {
        return req.products.findAll().flatMap { products in
            let unwrappedProducts = products.compactMap { $0 }
            guard !unwrappedProducts.isEmpty else {
                return req.eventLoop.makeFailedFuture(ProductError.productNotFound)
            }
            let productDTOs = unwrappedProducts.map { ProductDTO(from: $0) }
            return req.eventLoop.makeSucceededFuture(productDTOs)
        }
    }
    
    private func deleteProduct(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw ProductError.invalidIDNumberProduct
        }
        
        return req.products
            .delete(id: productID)
            .transform(to: .ok)
    }
    
    private func getProduct(_ req: Request) throws -> EventLoopFuture<ProductDTO> {
        guard let productID = req.parameters.get("productID", as: UUID.self) else {
            throw ProductError.invalidIDNumberProduct
        }
        
        return req.products.find(id: productID)
            .unwrap(or: ProductError.productNotFound)
            .map { product in
                return ProductDTO(from: product)
            }
    }
    
    
}
