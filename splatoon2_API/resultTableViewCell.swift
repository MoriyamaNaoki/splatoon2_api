//戦績一覧
import UIKit

class resultTableViewCell: UITableViewCell {

    @IBOutlet weak var rule_label: UILabel!
    @IBOutlet weak var stage_label: UILabel!
    @IBOutlet weak var x_power_label: UILabel!
    @IBOutlet weak var kill_count_count: UILabel!
    @IBOutlet weak var assist_count_label: UILabel!
    @IBOutlet weak var death_count_label: UILabel!
    @IBOutlet weak var special_count_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func SetData(indexPathNumber: IndexPath, results: [[String]]) {
        if results[indexPathNumber.row][2].isEqual("ガチホコバトル") {
            rule_label.text = "ガチホコ"
        } else {
            rule_label.text = results[indexPathNumber.row][2]
        }
        
        stage_label.text = results[indexPathNumber.row][3]
        x_power_label.text = results[indexPathNumber.row][9]
        kill_count_count.text = results[indexPathNumber.row][4]
        assist_count_label.text = results[indexPathNumber.row][5]
        death_count_label.text = results[indexPathNumber.row][6]
        special_count_label.text = results[indexPathNumber.row][7]
    }
}
