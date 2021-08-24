//
//  FriendListModel.swift
//
//  Created by Developer on 12/18/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class FriendListModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let exclude = "exclude"
    static let pendingrequest = "pendingrequest"
    static let uploadId = "upload_id"
    static let address = "address"
    static let nickname = "nickname"
    static let profileImage = "profile_image"
    static let accprequest = "accprequest"
    static let status = "status"
    static let senderId = "sender_id"
    static let request = "request"
    static let id = "id"
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let message = "message"
    static let reqId = "req_id"
    static let profilePicture = "profile_picture"
    static let recevierId = "recevier_id"
  }

  // MARK: Properties
  public var exclude: Int?
  public var pendingrequest: String?
  public var uploadId: String?
  public var address: String?
  public var nickname: String?
  public var profileImage: String?
  public var accprequest: String?
  public var status: String?
  public var senderId: String?
  public var request: String?
  public var id: String?
  public var firstName: String?
  public var lastName: String?
  public var message: String?
  public var reqId: String?
  public var profilePicture: String?
  public var recevierId: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    exclude = json[SerializationKeys.exclude].int
    pendingrequest = json[SerializationKeys.pendingrequest].string
    uploadId = json[SerializationKeys.uploadId].string
    address = json[SerializationKeys.address].string
    nickname = json[SerializationKeys.nickname].string
    profileImage = json[SerializationKeys.profileImage].string
    accprequest = json[SerializationKeys.accprequest].string
    status = json[SerializationKeys.status].string
    senderId = json[SerializationKeys.senderId].string
    request = json[SerializationKeys.request].string
    id = json[SerializationKeys.id].string
    firstName = json[SerializationKeys.firstName].string
    lastName = json[SerializationKeys.lastName].string
    message = json[SerializationKeys.message].string
    reqId = json[SerializationKeys.reqId].string
    profilePicture = json[SerializationKeys.profilePicture].string
    recevierId = json[SerializationKeys.recevierId].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = exclude { dictionary[SerializationKeys.exclude] = value }
    if let value = pendingrequest { dictionary[SerializationKeys.pendingrequest] = value }
    if let value = uploadId { dictionary[SerializationKeys.uploadId] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    if let value = nickname { dictionary[SerializationKeys.nickname] = value }
    if let value = profileImage { dictionary[SerializationKeys.profileImage] = value }
    if let value = accprequest { dictionary[SerializationKeys.accprequest] = value }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = senderId { dictionary[SerializationKeys.senderId] = value }
    if let value = request { dictionary[SerializationKeys.request] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = firstName { dictionary[SerializationKeys.firstName] = value }
    if let value = lastName { dictionary[SerializationKeys.lastName] = value }
    if let value = message { dictionary[SerializationKeys.message] = value }
    if let value = reqId { dictionary[SerializationKeys.reqId] = value }
    if let value = profilePicture { dictionary[SerializationKeys.profilePicture] = value }
    if let value = recevierId { dictionary[SerializationKeys.recevierId] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.exclude = aDecoder.decodeObject(forKey: SerializationKeys.exclude) as? Int
    self.pendingrequest = aDecoder.decodeObject(forKey: SerializationKeys.pendingrequest) as? String
    self.uploadId = aDecoder.decodeObject(forKey: SerializationKeys.uploadId) as? String
    self.address = aDecoder.decodeObject(forKey: SerializationKeys.address) as? String
    self.nickname = aDecoder.decodeObject(forKey: SerializationKeys.nickname) as? String
    self.profileImage = aDecoder.decodeObject(forKey: SerializationKeys.profileImage) as? String
    self.accprequest = aDecoder.decodeObject(forKey: SerializationKeys.accprequest) as? String
    self.status = aDecoder.decodeObject(forKey: SerializationKeys.status) as? String
    self.senderId = aDecoder.decodeObject(forKey: SerializationKeys.senderId) as? String
    self.request = aDecoder.decodeObject(forKey: SerializationKeys.request) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.firstName = aDecoder.decodeObject(forKey: SerializationKeys.firstName) as? String
    self.lastName = aDecoder.decodeObject(forKey: SerializationKeys.lastName) as? String
    self.message = aDecoder.decodeObject(forKey: SerializationKeys.message) as? String
    self.reqId = aDecoder.decodeObject(forKey: SerializationKeys.reqId) as? String
    self.profilePicture = aDecoder.decodeObject(forKey: SerializationKeys.profilePicture) as? String
    self.recevierId = aDecoder.decodeObject(forKey: SerializationKeys.recevierId) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(exclude, forKey: SerializationKeys.exclude)
    aCoder.encode(pendingrequest, forKey: SerializationKeys.pendingrequest)
    aCoder.encode(uploadId, forKey: SerializationKeys.uploadId)
    aCoder.encode(address, forKey: SerializationKeys.address)
    aCoder.encode(nickname, forKey: SerializationKeys.nickname)
    aCoder.encode(profileImage, forKey: SerializationKeys.profileImage)
    aCoder.encode(accprequest, forKey: SerializationKeys.accprequest)
    aCoder.encode(status, forKey: SerializationKeys.status)
    aCoder.encode(senderId, forKey: SerializationKeys.senderId)
    aCoder.encode(request, forKey: SerializationKeys.request)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(firstName, forKey: SerializationKeys.firstName)
    aCoder.encode(lastName, forKey: SerializationKeys.lastName)
    aCoder.encode(message, forKey: SerializationKeys.message)
    aCoder.encode(reqId, forKey: SerializationKeys.reqId)
    aCoder.encode(profilePicture, forKey: SerializationKeys.profilePicture)
    aCoder.encode(recevierId, forKey: SerializationKeys.recevierId)
  }

}
