import Foundation

protocol ChatDelegate{
    func newBuddyOnline(buddyName:String)
    func buddyWentOffline(buddyName:String)
    func didDisconnect()
}
