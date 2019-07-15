import UIKit

//var results = iksmDAO().result_select()

var results_area = iksmDAO().result_area_select(rule: "ガチエリア")

var results_yagura = iksmDAO().result_area_select(rule: "ガチヤグラ")

var results_hoko = iksmDAO().result_area_select(rule: "ガチホコバトル")

var results_asari = iksmDAO().result_area_select(rule: "ガチアサリ")

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var resultTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iksmDAO().db_copy()
        resultTable.register(UINib(nibName: "resultTableViewCell", bundle: nil), forCellReuseIdentifier: "result")
    }
    
    
    //行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return results_area.count
        } else if(section == 1) {
            return results_yagura.count
        } else if(section == 2) {
            return results_hoko.count
        } else if(section == 3) {
            return results_asari.count
        }
        return 0
    }
    
    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "result", for:  indexPath) as! resultTableViewCell
        if (indexPath.section == 0) {
            cell.SetData(indexPathNumber: indexPath, results: results_area)
        } else if (indexPath.section == 1) {
            cell.SetData(indexPathNumber: indexPath, results: results_yagura)
        } else if (indexPath.section == 2) {
            cell.SetData(indexPathNumber: indexPath, results: results_hoko)
        } else if (indexPath.section == 3) {
            cell.SetData(indexPathNumber: indexPath, results: results_asari)
        }
        
        return cell
    }
    
    //ヘッダーの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 5
    }
    
    //ヘッダーのタイトル
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
     {
     return "ヘッダー section:\(section)"
     }
     */
    //フッターの高さ
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 25
    }
    /*
     //フッターのタイトル
     func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
     {
     return "フッター section:\(section)"
     }
     */
    
    //更新ボタン_戦績読み込み
    @IBAction func result_reload(_ sender: Any) {
        iksmAPI().results()
        //xパワー現在値計測
        iksmDAO().now_x_power_insert(rule: results_area[0][2], x_power: results_area[0][9])
        iksmDAO().now_x_power_insert(rule: results_yagura[0][2], x_power: results_yagura[0][9])
        iksmDAO().now_x_power_insert(rule: results_hoko[0][2], x_power: results_hoko[0][9])
        iksmDAO().now_x_power_insert(rule: results_asari[0][2], x_power: results_asari[0][9])
    }
    

}

