import Foundation
import Alamofire
import SwiftyJSON

enum ApiError: Error {
    case badURL
    case noConnection
    case noData
    case serverError(message: String?)
}
class ApiManager {
    static let baseUrl = "https://www.gazetaexpress.com/"
    
    fileprivate static func request(
        withPath path: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        result: @escaping (Result<Data, Error>) -> Void) {
        let urlString = String(format: "%@%@", baseUrl, path)
        guard let url = URL(string: urlString) else {
            assertionFailure("Wrong url")
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let request = AF.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers
        ).cacheResponse(using: ResponseCacher(behavior: .cache)).validate()
        request.responseData { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                guard let data = response.value else {
                    result(.failure(ApiError.noData))
                    return
                }
                result(.success(data))
            case .failure(let error):
                debugPrint(request.request ?? "")
                print(error.localizedDescription)
                if let statusCode = response.response?.statusCode, statusCode >= 400 {
                    if statusCode == 401 {
                        
                    }
                    if let data = response.data, let responseJSON = try? JSON(data: data) {
                        print(responseJSON)
                        result(.failure(ApiError.serverError(message: responseJSON["message"].string)))
                    } else if statusCode >= 500 {
                        result(.failure(error))
                    } else {
                        result(.failure(error))
                    }
                } else {
                    result(.failure(error))
                }
            }
        }
    }
    
    fileprivate static func getRequest(
        withPath path: String,
        parameters: [String: Any]? = nil,
        result: @escaping (Result<Data, Error>) -> Void
    ) {
        request(withPath: path, method: .get, result: result)
    }
    
    func cancelAllRequests(onCompletion: @escaping () -> Void) {
        Alamofire.Session.default.session
            .getTasksWithCompletionHandler { sessionDataTask, uploadData, downloadData in
                sessionDataTask.forEach { $0.cancel() }
                uploadData.forEach { $0.cancel() }
                downloadData.forEach { $0.cancel() }
                onCompletion()
            }
    }
    
}
extension ApiManager {
    static func getHome(result: @escaping (Result<[Ballina], Error>) -> Void) {
        getRequest(withPath: "wp-json/cng/v1/home-position") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                print(json)
                do {
                    let ballina =  try JSONDecoder().decode([Ballina].self, from: data)
                    result(.success(ballina))
                    print(ballina)
                }
                catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    static func getSporte(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/5") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                do {
                    let category = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(category))
                    print(category)
                }
                catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    static func getOPED(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/10") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                do {
                    let category = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(category))
                    print(category)
                }
                catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
        
    }
    static func getRoze(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/6") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                do {
                    let category = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(category))
                    print(category)
                }
                catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    static func getFun(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/12") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                do {
                    let category = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(category))
                    print(category)
                }
                catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    static func getShneta(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/7") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                do {
                    let category = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(category))
                    print(category)
                }
                catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    
    
    
    static func getLajme(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/4") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                print(json)
                do {
                    let categories =  try JSONDecoder().decode(Category.self, from: data)
                    result(.success(categories))
                    print(categories)
                }
                catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
                
            }
        }
    }
    
    static func getEnglish(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/259") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                print(json)
                do {
                    let categories = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(categories))
                } catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    static func getMaqedoni(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/37") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                print(json)
                do {
                    let categories = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(categories))
                } catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
            
        }
    }
    
    static func getShqiperi(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/34") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                print(json)
                do {
                    let categories = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(categories))
                } catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
            
        }
    }
    
    static func getAutoTech(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/14") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                print(json)
                do {
                    let categories = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(categories))
                } catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
            
        }
    }
    static func getArte(result: @escaping (Result<Category, Error>) -> Void) {
        getRequest(withPath: "wp-json/wp/v2/categories/11") { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                print(json)
                do {
                    let categories = try JSONDecoder().decode(Category.self, from: data)
                    result(.success(categories))
                } catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
            }
            
        }
    }
    
    static func getCategoryPostsById(path: String, parameters: [String: Any]?, result: @escaping (Result<[Post], Error>) -> Void) {
        getRequest(withPath: path, parameters: parameters) { (requestResult) in
            switch requestResult {
            case .success(let data):
                let json = JSON(data)
                print(json)
                do {
                    let categoryPosts =  try JSONDecoder().decode([Post].self, from: data)
                    result(.success(categoryPosts))
                    print(categoryPosts)
                }
                catch {
                    result(.failure(error))
                    print(error)
                }
            case .failure(let error):
                result(.failure(error))
                
            }
        }
    }
}
