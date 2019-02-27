//
//  Created by Tagir Nafikov on 16/04/2018.
//

import UIKit
import MessageUI


class SettingsViewController: UITableViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let appStoreURLString = "itms-apps://itunes.apple.com/ru/app/id1454203769"
        static let appShareURLString = "https://itunes.apple.com/ru/app/id1454203769"
    }
    

    // MARK: - Outlets
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Настройки"
        notificationSwitch.isOn = SettingsManager.isReminderEnabled
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    // MARK: - Actions
    
    @IBAction func notificationSwitchSwitched(_ sender: UISwitch) {
        SettingsManager.isReminderEnabled = sender.isOn
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 1 {
            if row == 0 {
                showFeedbackScreen()
            }
        } else if section == 2 {
            if row == 0 {
                showAppInAppStore()
            } else if row == 1 {
                shareApp()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Private methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["sltn.developments@gmail.com"])
        mailComposerVC.setSubject("Отзыв на приложение Таджвид")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertView = AlertView(
            title: "Ошибка",
            message: "Вы не настроили отправку электронных писем",
            style: .alert)
        alertView.show(in: self)
    }

    // MARK: - Actions
    
    private func showFeedbackScreen() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController()
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }
    
    private func showAppInAppStore() {
        guard let url = URL(string: Constants.appStoreURLString),
            UIApplication.shared.canOpenURL(url)
            else {
                return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func shareApp() {
        let link = Constants.appShareURLString
        let activityViewController = UIActivityViewController(
            activityItems: [link],
            applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
