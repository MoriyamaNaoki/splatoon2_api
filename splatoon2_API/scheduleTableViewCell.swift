
import UIKit

class scheduleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stage_a_image: UIImageView!
    
    @IBOutlet weak var stage_b_image: UIImageView!
    
    @IBOutlet weak var rule_label: UILabel!
        
    @IBOutlet weak var time_label: UILabel!
    
    @IBOutlet weak var now_x_power_label: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    

    
    func SetSchedule(section: Int, schedules: [[String]], now_x_power: String) {

        time_label.adjustsFontSizeToFitWidth = true
        let start_time = NSDate(timeIntervalSince1970: NumberFormatter().number(from: schedules[section][0]) as! Double)
        let end_time = NSDate(timeIntervalSince1970: NumberFormatter().number(from: schedules[section][1]) as! Double)
        time_label.text = "\(stringFromDate(date: start_time as Date))\n▼\n\(stringFromDate(date: end_time as Date))"

        rule_label.adjustsFontSizeToFitWidth = true
        if schedules[section][2].isEqual("ガチホコバトル") {
            rule_label.text = "ガチホコ"
        } else {
            rule_label.text = schedules[section][2]
        }
        
        stage_a_image.image = UIImage(named: schedules[section][3])
        stage_b_image.image = UIImage(named: schedules[section][4])
        now_x_power_label.adjustsFontSizeToFitWidth = true
        now_x_power_label.text = "現在のXパワー\n" +  now_x_power
    }
    
    
    func stringFromDate(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}
