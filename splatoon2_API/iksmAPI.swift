//API操作
import UIKit

//iksm_sessionの情報
var iksm_session = "iksm_session=xxxx"

class iksmAPI: NSObject {
    var results_list1 = [[Int]]()
    var results_list2 = [[String]]()
    var results_list3 = [[String]]()
    var battle_number = [Int]()
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
                var resultData = try? JSONDecoder().decode(iksmJSON.iksmData.self, from: data)

                for i in 0..<49 {
                    //１戦ごとの戦績を出力
                    if (resultData != nil) {
                        if (resultData!.results[i].estimate_x_power == nil) {
                            resultData!.results[i].estimate_x_power = 0
                            self.results_list1.append([Int(resultData!.results[i].battle_number)!, resultData!.results[i].player_result.kill_count, resultData!.results[i].player_result.assist_count, resultData!.results[i].player_result.death_count, resultData!.results[i].player_result.special_count, Int(resultData!.results[i].estimate_x_power!)])
                            self.results_list2.append([resultData!.results[i].player_result.player.weapon.name, resultData!.results[i].player_result.player.weapon.special.name, "", resultData!.results[i].rule.name,resultData!.results[i].stage.name, resultData!.results[i].my_team_result.name])
                        } else {
                            self.results_list1.append([Int(resultData!.results[i].battle_number)!, resultData!.results[i].player_result.kill_count, resultData!.results[i].player_result.assist_count, resultData!.results[i].player_result.death_count, resultData!.results[i].player_result.special_count, Int(resultData!.results[i].estimate_x_power!)])
                 
                            self.results_list2.append([resultData!.results[i].player_result.player.weapon.name, resultData!.results[i].player_result.player.weapon.special.name, resultData!.results[i].udemae!.name, resultData!.results[i].rule.name,resultData!.results[i].stage.name,resultData!.results[i].my_team_result.name])
                        }
                        self.results_list3.append([resultData!.results[i].player_result.player.head.name, resultData!.results[i].player_result.player.head_skills.main.name, resultData!.results[i].player_result.player.head_skills.subs[0]!.name, resultData!.results[i].player_result.player.head_skills.subs[1]!.name, resultData!.results[i].player_result.player.head_skills.subs[2]!.name, resultData!.results[i].player_result.player.clothes_skills.main.name, resultData!.results[i].player_result.player.clothes_skills.subs[0]!.name, resultData!.results[i].player_result.player.clothes_skills.subs[1]!.name, resultData!.results[i].player_result.player.clothes_skills.subs[2]!.name, resultData!.results[i].player_result.player.shoes.name, resultData!.results[i].player_result.player.shoes_skills.main.name, resultData!.results[i].player_result.player.shoes_skills.subs[0]!.name, resultData!.results[i].player_result.player.shoes_skills.subs[1]!.name, resultData!.results[i].player_result.player.shoes_skills.subs[2]!.name])
                        self.battle_number.append(Int(resultData!.results[i].battle_number)!)
                    }
                }
                //戦績
                iksmDAO().results_update(results_list1: self.results_list1, results_list2: self.results_list2)
                //装備
                iksmDAO().results_gear_update(battele_number: self.battle_number, player_cd: 1, results_list3: self.results_list3)
            }
            catch {
                print(error)
            }
        })
        //タスク開始
        task.resume()
    }
    var schedules_list = [[String]]()
    var start_time = [NSDate]()
    var end_time = [NSDate]()
    //スケジュール
    func schedules() {
        //戦績５０戦分取得
        let schedulesUrl: URL = URL(string: "https://app.splatoon2.nintendo.net/api/schedules")!
        
        //iksm_sessionをcookieに配置
        let cookieHeaderField = ["Set-Cookie": iksm_session]
        let cookie = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: schedulesUrl)
        HTTPCookieStorage.shared.setCookies(cookie, for: schedulesUrl, mainDocumentURL: schedulesUrl)
        
        //https://app.splatoon2.nintendo.net/api/resultsにアクセス　戦績を取得
        let task = URLSession.shared.dataTask(with: schedulesUrl, completionHandler: { (data, response, error) in
            do {
                guard let data = data else {
                    throw MyError.BadJSON("error")
                }
                //iksmにフォーマット
                let schedulesData = try? JSONDecoder().decode(iksmJSON.schedule.self, from: data)
                //UNIX時間　変換
                
                for i in 0..<12 {
                    self.schedules_list.append([schedulesData!.gachi![i].rule.name, schedulesData!.gachi![i].stage_a.name, schedulesData!.gachi![i].stage_b.name])
                    self.start_time.append(NSDate(timeIntervalSince1970: schedulesData!.gachi![i].start_time))
                    self.end_time.append(NSDate(timeIntervalSince1970: schedulesData!.gachi![i].end_time))
                }
                iksmDAO().schedules_delete()
                iksmDAO().schedules_insert(schedules_list: self.schedules_list, start_time: self.start_time, end_time: self.end_time)
            } catch {
                print(error)
            }
            
        })
        
        task.resume()
        
        //バトル詳細
        
    }
    
    //各バトル_敵味方詳細保存処理
    func results_information(battle_number:Int) {
        //API ５０回分の戦績を取得
        let resultsUrl: URL = URL(string: "https://app.splatoon2.nintendo.net/api/results/" + String(battle_number))!
        
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
                let resultData = try? JSONDecoder().decode(iksmJSON.my_team.self, from: data)
                //print(resultData)

                for i in 0..<3 {
                    //１戦ごとの戦績を出力
                    var head_skills_subs = [String]()
                    var clothes_skills_subs = [String]()
                    var shoes_skills_subs = [String]()
                    for x in 0..<3 {
                        
                        if (resultData!.my_team_members[i].player.head_skills.subs[x] != nil) {
                            head_skills_subs.append(resultData!.my_team_members[i].player.head_skills.subs[x]!.name)
                        } else {
                            head_skills_subs.append("はてな")
                        }
                        
                        if (resultData!.my_team_members[i].player.clothes_skills.subs[x] != nil) {
                            clothes_skills_subs.append(resultData!.my_team_members[i].player.clothes_skills.subs[x]!.name)
                        } else {
                            clothes_skills_subs.append("はてな")
                        }
                        if resultData!.my_team_members[i].player.shoes_skills.subs[x] != nil {
                            shoes_skills_subs.append(resultData!.my_team_members[i].player.shoes_skills.subs[x]!.name)
                        } else {
                            shoes_skills_subs.append("はてな")
                        }
                    }
                    iksmDAO().my_team_insert(results_list1: [resultData!.my_team_members[i].kill_count, resultData!.my_team_members[i].assist_count, resultData!.my_team_members[i].death_count, resultData!.my_team_members[i].special_count], results_list2: [resultData!.my_team_members[i].player.nickname, resultData!.my_team_members[i].player.weapon.name, resultData!.my_team_members[i].player.weapon.sub.name, resultData!.my_team_members[i].player.weapon.special.name, resultData!.my_team_members[i].player.head.name, resultData!.my_team_members[i].player.head_skills.main.name, head_skills_subs[0], head_skills_subs[1], head_skills_subs[2], resultData!.my_team_members[i].player.clothes.name, resultData!.my_team_members[i].player.clothes_skills.main.name, clothes_skills_subs[0], clothes_skills_subs[1], clothes_skills_subs[2], resultData!.my_team_members[i].player.shoes.name, resultData!.my_team_members[i].player.shoes_skills.main.name, shoes_skills_subs[0], shoes_skills_subs[1], shoes_skills_subs[2]], i:i, battle_number:battle_number)

                }
                for i in 0..<4 {
                    var head_skills_subs = [String]()
                    var clothes_skills_subs = [String]()
                    var shoes_skills_subs = [String]()
                    for x in 0..<3 {
                        if (resultData!.other_team_members[i].player.head_skills.subs[x] != nil) {
                            head_skills_subs.append(resultData!.other_team_members[i].player.head_skills.subs[x]!.name)
                        } else {
                            head_skills_subs.append("はてな")
                        }
                    
                        if (resultData!.other_team_members[i].player.clothes_skills.subs[x] != nil) {
                            clothes_skills_subs.append(resultData!.other_team_members[i].player.clothes_skills.subs[x]!.name)
                        } else {
                            clothes_skills_subs.append("はてな")
                        }
                        if resultData!.other_team_members[i].player.shoes_skills.subs[x] != nil {
                            shoes_skills_subs.append(resultData!.other_team_members    [i].player.shoes_skills.subs[x]!.name)
                        } else {
                            shoes_skills_subs.append("はてな")
                        }
                    }
                    iksmDAO().other_team_insert(results_list1: [resultData!.other_team_members[i].kill_count, resultData!.other_team_members[i].assist_count, resultData!.other_team_members[i].death_count, resultData!.other_team_members[i].special_count], results_list2: [resultData!.other_team_members[i].player.nickname, resultData!.other_team_members[i].player.weapon.name, resultData!.other_team_members[i].player.weapon.sub.name, resultData!.other_team_members[i].player.weapon.special.name, resultData!.other_team_members[i].player.head.name, resultData!.other_team_members[i].player.head_skills.main.name, head_skills_subs[0], head_skills_subs[1], head_skills_subs[2], resultData!.other_team_members[i].player.clothes.name, resultData!.other_team_members[i].player.clothes_skills.main.name, clothes_skills_subs[0], clothes_skills_subs[1], clothes_skills_subs[2], resultData!.other_team_members[i].player.shoes.name, resultData!.other_team_members[i].player.shoes_skills.main.name, shoes_skills_subs[0], shoes_skills_subs[1], shoes_skills_subs[2]], i:i, battle_number:battle_number)
                }
                
                
                //
            }
            catch {
                print(error)
            }
        })
        //タスク開始
        task.resume()
    }
    
}
enum MyError: Error {
    case BadJSON(String)
}




