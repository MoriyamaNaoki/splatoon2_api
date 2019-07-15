import UIKit
var schedules = iksmDAO().schedules_select()

class scheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var schedule_table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "コルクボード")!)

        self.schedule_table.backgroundColor = UIColor.clear
        //let schedules = iksmDAO().schedules_select()

        schedule_table.register(UINib(nibName: "scheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "Identifier")


    }
    //行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 375
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for:  indexPath) as! scheduleTableViewCell
        let now_x_power = iksmDAO().now_x_power_select(rule: schedules[indexPath.section][2])
        cell.SetSchedule(section: indexPath.section, schedules: schedules,  now_x_power: now_x_power)
        
        return cell
    }
    
    //ヘッダーの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 5

        } else {
            return 0

        }
    }
    
    //ヘッダーのタイトル
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let label : UILabel = UILabel()
        label.backgroundColor = UIColor.black
        return label
    }
 
    //フッターの高さ
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 5
    }
    
    //フッターのタイトル
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let label : UILabel = UILabel()
        label.backgroundColor = UIColor.black
        return label
    }
    
    //現在のスケジュール取得
    @IBAction func schedule_reload(_ sender: Any) {
        //スケジュール取得
        iksmAPI().schedules()
        schedule_table.reloadData()
        //再読み込み
        loadView()
        viewDidLoad()
    }
    
}
