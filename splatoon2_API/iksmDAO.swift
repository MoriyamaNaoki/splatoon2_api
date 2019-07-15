//DB操作
import UIKit
import FMDB

//dbのパス
var db = FMDatabase(path: Bundle.main.path(forResource: "splatoon2_db", ofType: "db"))

var document_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

var db_select = FMDatabase(path: copy_path)

var copy_path = document_path! + "/splatoon2_db.db"


var max_battle_number = 0
class iksmDAO: NSObject {
    //スケジュール　挿入
    func schedules_insert(schedules_list: [[String]], start_time: [NSDate], end_time: [NSDate]) {
        
        let uodateSQL = "INSERT INTO schedule_table VALUES (?, ?, ?, ?, ?);"
        db_select.open()
        
        for i in 1..<12 {
            db_select.executeUpdate(uodateSQL, withArgumentsIn: [start_time[i], end_time[i], schedules_list[i][0], schedules_list[i][1], schedules_list[i][2]])
        }
        
        db_select.close()
    }
    
    //削除
    func schedules_delete() {
        
        //db = FMDatabase(path: copy_path)
        create_table()

        let now_time = NSDate().timeIntervalSince1970
        let uodateSQL = "DELETE FROM schedule_table WHERE end_time < \(now_time) OR start_time > \(now_time);"
        db_select.open()
        db_select.executeUpdate(uodateSQL, withArgumentsIn:[])
        db_select.close()
    }
    
    var battle_number_check = Int()
    //戦績　追加
    func results_update(results_list1: [[Int]], results_list2: [[String]]) {


        let uodateSQL = "INSERT INTO result_table VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        battle_number_check = max_battle_number()
        
        for i in 0..<49 {
            if (results_list1.count != 0 && results_list1[i][0] > battle_number_check) {
                db.open()
                db.executeUpdate(uodateSQL, withArgumentsIn: [results_list1[i][0], results_list2[i][5], results_list2[i][0], results_list2[i][1], results_list1[i][1], results_list1[i][2], results_list1[i][3], results_list1[i][4], results_list2[i][2], results_list1[i][5], results_list2[i][3], results_list2[i][4]])
                iksmAPI().results_information(battle_number: results_list1[i][0])
                db.close()
            }
        }
        
        
    }
    
    //ギア　追加
    func results_gear_update(battele_number: [Int], player_cd: Int, results_list3: [[String]]) {
        
        
        let uodateSQL = "INSERT INTO gear_table VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        battle_number_check = max_battle_number()
        for i in 0..<49 {
            if (battele_number.count != 0 && battele_number[i] > battle_number_check) {
                db.open()
                db.executeUpdate(uodateSQL, withArgumentsIn: [battele_number[i], player_cd, results_list3[i][0], results_list3[i][1], results_list3[i][2], results_list3[i][3], results_list3[i][4], results_list3[i][5], results_list3[i][6], results_list3[i][7], results_list3[i][8], results_list3[i][9], results_list3[i][10], results_list3[i][11], results_list3[i][12], results_list3[i][13], results_list3[i][14]])
                db.close()
            }
        }
        
        
        
    }
    //味方の詳細
    func my_team_insert(results_list1: [Int], results_list2: [String], i:Int, battle_number:Int) {
        let uodateSQL = "INSERT INTO my_team_member_information VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        db.open()
        
        db.executeUpdate(uodateSQL, withArgumentsIn: [battle_number, i, results_list2[0], results_list2[1], results_list2[2], results_list2[3], results_list1[0], results_list1[1], results_list1[2], results_list1[3], results_list2[4], results_list2[5], results_list2[6], results_list2[7], results_list2[8], results_list2[9], results_list2[10], results_list2[11], results_list2[12], results_list2[13], results_list2[14], results_list2[15], results_list2[16], results_list2[17], results_list2[18]])
        
        
        db.close()
        
    
    }
    //敵の詳細
    func other_team_insert(results_list1: [Int], results_list2: [String], i:Int, battle_number: Int) {
        let uodateSQL = "INSERT INTO other_team_member_information VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        db.open()
        
        db.executeUpdate(uodateSQL, withArgumentsIn: [battle_number, i, results_list2[0], results_list2[1], results_list2[2], results_list2[3], results_list1[0], results_list1[1], results_list1[2], results_list1[3], results_list2[4], results_list2[5], results_list2[6], results_list2[7], results_list2[8], results_list2[9], results_list2[10], results_list2[11], results_list2[12], results_list2[13], results_list2[14], results_list2[15], results_list2[16], results_list2[17], results_list2[18]])
        
        
        db.close()
        
    }
    
    func schedules_select() -> [[String]] {
        var schedules_list = [[String]]()
        let selectSQL = "SELECT * FROM schedule_table;"
        db_select.open()
        
        let schedules = db_select.executeQuery(selectSQL, withArgumentsIn: [])
        
        while (schedules!.next()) {
            
            schedules_list.append([schedules!.string(forColumn: "start_time")!, schedules!.string(forColumn: "end_time")!, schedules!.string(forColumn: "rule")!, schedules!.string(forColumn: "stage_a")!, schedules!.string(forColumn: "stage_b")!])
            
        }
        db_select.close()
        return schedules_list
    }
    
    //battle_number最大値
    func max_battle_number() -> Int {
        var max_battle_number = Int()
        let selectSQL = "SELECT MAX(battle_number) FROM result_table;"
        db.open()
        
        let schedules = db.executeQuery(selectSQL, withArgumentsIn: [])
        
        while (schedules!.next()) {
            max_battle_number = Int(schedules!.string(forColumn: "MAX(battle_number)")!)!
        }
        db.close()
        return max_battle_number
    }
    
    
    /*func result_select() -> [[String]] {
        var results_list = [[String]]()
        let selectSQL = "SELECT * FROM result_table;"
        db.open()
        
        let results = db.executeQuery(selectSQL, withArgumentsIn: [])
        
        while (results!.next()) {
            
            results_list.append([results!.string(forColumn: "weapon")!, results!.string(forColumn: "special_weapon")!, results!.string(forColumn: "rule")!, results!.string(forColumn: "stage")!, results!.string(forColumn: "kill_count")!, results!.string(forColumn: "assist_count")!, results!.string(forColumn: "death_count")!, results!.string(forColumn: "special_count")!, results!.string(forColumn: "udemae")!,  results!.string(forColumn: "x_power")!])

        }
        db.close()
        return results_list
    }*/
    
    //個別集計エリアのみ集計
    func result_area_select(rule: String) -> [[String]] {
        var results_list = [[String]]()
        let selectSQL = "SELECT * FROM result_table WHERE RULE = '" + rule + "' ORDER BY battle_number DESC;"
        db.open()
        
        let results = db.executeQuery(selectSQL, withArgumentsIn: [])
        
        
        while (results!.next()) {
            
            results_list.append([results!.string(forColumn: "weapon")!, results!.string(forColumn: "special_weapon")!, results!.string(forColumn: "rule")!, results!.string(forColumn: "stage")!, results!.string(forColumn: "kill_count")!, results!.string(forColumn: "assist_count")!, results!.string(forColumn: "death_count")!, results!.string(forColumn: "special_count")!, results!.string(forColumn: "udemae")!,  results!.string(forColumn: "x_power")!])

        }
        db.close()
        return results_list
    }
    
    //現在のXパワー_更新
    func now_x_power_insert(rule: String, x_power: String) {

        let deleteSQL = "DELETE FROM now_x_power WHERE rule = \"" + rule + "\";"
        db.open()
        db.executeUpdate(deleteSQL, withArgumentsIn:[])
        db.close()
        
        let uodateSQL = "INSERT INTO now_x_power VALUES (?, ?);"
        db.open()
        db.executeUpdate(uodateSQL, withArgumentsIn:[rule, x_power])
        
        db.close()
    }
    
    //現在のXパワー取得
    func now_x_power_select(rule: String) -> String {
        var now_x_power = String()
        let selectSQL = "SELECT * FROM now_x_power WHERE rule = \"" + rule + "\";"
        db.open()
        
        let results = db.executeQuery(selectSQL, withArgumentsIn: [])
        
        
        while (results!.next()) {
            
            now_x_power = results!.string(forColumn: "x_power")!

        }
        db_select.close()
        return now_x_power
    }
    
    func create_table() {
        let sql = "CREATE TABLE IF NOT EXISTS schedule_table (start_time    TEXT,end_time    TEXT,rule    TEXT,stage_a    TEXT,stage_b    TEXT);"
        db_select.open()
        db_select.executeUpdate(sql, withArgumentsIn:[])
        db_select.close()
    }
    
    func db_copy() {
        try? FileManager.default.copyItem(atPath: Bundle.main.path(forResource: "splatoon2_db", ofType: "db")!, toPath: copy_path)
    }
}
