//API操作
import UIKit

var iksm_session = "iksm_session=25b32f7358b80a7b932261d21cc875a8d32e5e90"

class iksm_API: NSObject {
    //戦績取得
    func results() {
        //API ５０回分の戦績を取得
        let resultsUrl: URL = URL(string: "https://app.splatoon2.nintendo.net/api/results")!
        
        //cookieにiksm_sessionを配置
        let cookieHeaderField = ["Set-Cookie": iksm_session]
        let cookie = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: resultsUrl)
        HTTPCookieStorage.shared.setCookies(cookie, for: resultsUrl, mainDocumentURL: resultsUrl)
        
        //https://app.splatoon2.nintendo.net/api/resultsにアクセス　戦績を取得
        let task = URLSession.shared.dataTask(with: resultsUrl, completionHandler: { (data, response, error) in
            do {
                guard let data = data else {
                    throw MyError.BadJSON("error")
                }
                //iksmにフォーマット
                let resultData = try? JSONDecoder().decode(iksmData.self, from: data)
                for i in 0..<50 {
                    //１戦ごとの戦績を出力
                    print("Kill：\(resultData!.results[i].player_result.kill_count + resultData!.results[i].player_result.assist_count)(\(resultData!.results[i].player_result.assist_count)) Death：\(resultData!.results[i].player_result.death_count) Special：\(resultData!.results[i].player_result.special_count)")
                    print("ウデマエ：\(resultData!.results[i].udemae.name) Xパワー：\(resultData!.results[i].estimate_x_power)")
                    print("ルール：\(resultData!.results[i].rule.name) ステージ：\(resultData!.results[i].stage.name)\n")
                }
            }
            catch {
                print(error)
            }
        })
        //タスク開始
        task.resume()
    }
    
    //スケジュール
    func schedules() {
        //URLSessionConfigurationを使用
        //let config: URLSessionConfiguration = URLSessionConfiguration.default
        //戦績５０戦分取得
        let schedulesUrl: URL = URL(string: "https://app.splatoon2.nintendo.net/api/schedules")!
        
        //iksm_sessionをcookieに配置
        let cookieHeaderField = ["Set-Cookie": iksm_session]
        let cookie = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: schedulesUrl)
        HTTPCookieStorage.shared.setCookies(cookie, for: schedulesUrl, mainDocumentURL: schedulesUrl)
        
        //var req: URLRequest = URLRequest(url: schedulesUrl)
        //GET
        //req.httpMethod = "GET"
        
        //https://app.splatoon2.nintendo.net/api/resultsにアクセス　戦績を取得
        let task = URLSession.shared.dataTask(with: schedulesUrl, completionHandler: { (data, response, error) in
            do {
                guard let data = data else {
                    throw MyError.BadJSON("error")
                }
                //iksmにフォーマット
                let schedulesData = try? JSONDecoder().decode(schedule.self, from: data)
                //UNIX時間　変換
                
                for i in 0..<12 {
                    print("開始：\(NSDate(timeIntervalSince1970: schedulesData!.gachi[i].start_time)) 終了：\(NSDate(timeIntervalSince1970: schedulesData!.gachi[i].end_time))")
                    print("ルール：\(schedulesData!.gachi[i].rule.name)")
                    print("ステージ：\(schedulesData!.gachi[i].stage_a.name) \(schedulesData!.gachi[i].stage_a.name)\n")
                    
                }
            } catch {
                print(error)
            }
            
        })
        
        task.resume()
    }
    
}
enum MyError: Error {
    case BadJSON(String)
}


struct  iksmData : Codable {
    //let unique_id: Double
    let summary: summary
    
    let results: [results]
    
}
struct  summary : Codable {
    //５０戦の集計？
    let assist_count_average: Double
    let death_count_average: Double
    let special_count_average: Double
    let kill_count_average: Double
    //勝敗？
    let victory_rate: Double
    
}

//戦績
struct  results : Codable {
    
    let estimate_x_power: Double
    let my_team_result: my_team_result
    let player_result: player_result
    let rule: rule
    let stage: stage
    let udemae: udemae
}

//プレイヤー情報
struct  player_result : Codable {
    let assist_count: Int
    let death_count: Int
    let kill_count: Int
    let special_count: Int
    
}
//ルール
struct  rule : Codable {
    let name:String
}
//勝敗
struct  my_team_result : Codable {
    let name: String
}

//ステージ
struct  stage : Codable {
    let name: String
}
//ウデマエ
struct  udemae : Codable {
    let name: String
}

////スケジュール
struct  schedule : Codable {
    
    let gachi: [gachi]
}
//ガチマッチのステージ情報
struct  gachi : Codable {
    let stage_a: stage_a
    let stage_b: stage_b
    let rule: rule
    let start_time: Double
    let end_time: Double
}
//１つ目のステージ
struct  stage_a : Codable {
    let name: String
}
//２つ目のステージ
struct  stage_b : Codable {
    let name: String
    
}

