//JSON構造
import UIKit

class iksmJSON: NSObject {
    struct iksmData : Codable {
        var results: [results]
    }
    
    //戦績
    struct results : Codable {
        
        let battle_number: String
        var estimate_x_power: Double?
        let my_team_result: name
       
        let player_result: player_result
        let rule: name
        let stage: name
        var udemae: name?

    }
    
    //プレイヤー情報
    struct player_result : Codable {
        let assist_count: Int
        let death_count: Int
        let kill_count: Int
        let special_count: Int
        
        let player : player
    }

    //スケジュール
    struct schedule : Codable {
        
        let gachi: [gachi]?
    }
    //ガチマッチのステージ情報
    struct gachi : Codable {
        let stage_a: name
        let stage_b: name
        let rule: name
        let start_time: Double
        let end_time: Double
    }
    //味方詳細
    struct my_team : Codable {
        let my_team_members: [my_team_members]
        //let rank: Int
        let other_team_members: [other_team_members]
    }
    
    struct my_team_members : Codable {
        let assist_count: Int
        let death_count: Int
        let kill_count: Int
        let special_count: Int
        var player: players
        
    }
    
    //敵詳細
    struct other_team_members : Codable {
        let assist_count: Int
        let death_count: Int
        let kill_count: Int
        let special_count: Int
        let player: players
        
    }
    struct players : Codable {
        let head: name
        let clothes: name
        let shoes: name
        var head_skills: gear_skills
        
        let clothes_skills: gear_skills
        
        let shoes_skills: gear_skills
        
        let nickname: String
        
        let weapon: weapon
    }

    struct player : Codable {
        let head: name
        let clothes: name
        let shoes: name
        let head_skills: gear_skills

        let clothes_skills: gear_skills

        let shoes_skills: gear_skills
        
        let nickname: String
        
        let weapon: weapon
    }

    struct gear_skills : Codable {
        let main: name
        var subs: [subs_name?]
    }
    struct subs_name : Codable {
        var name: String
    }
    struct name : Codable {
        var name: String
    }

    //武器
    struct weapon : Codable {
        let name: String
        let special: name
        let sub: name
    }

}
