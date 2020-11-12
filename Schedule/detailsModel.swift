//
//  detailsModel.swift
//  Schedule
//
//  Created by Govardhan Goli on 10/29/20.
//

import Foundation

// API model
struct Result : Codable{
  var  GameList : GameList?
}

struct  GameList: Codable {
    var  Team : selectedTeam?
    var DefaultGameId : String?
    var GameSection : [GameSection]?
}

struct selectedTeam : Codable{
    var TriCode : String?
    var Name: String?
    var Record : String?
    private enum CodingKeys : String, CodingKey {
            case TriCode = "-TriCode", Name = "-Name", Record = "-Record"
        }
}

struct GameSection: Codable{
    var Heading : String?
    var Game : MetadataType?
    private enum CodingKeys : String, CodingKey {
            case Heading = "-Heading", Game
        }
}

struct Game: Codable {
    var Id : String?
    var Types : String?
    var Week: String?
    var AwayScore : String?
    var HomeScore : String?
    var Date : date?
    var Opponent : selectedTeam?
    private enum CodingKeys : String, CodingKey {
            case Id = "-Id", Types = "-Type", Week = "-Week", AwayScore = "-AwayScore", HomeScore = "-HomeScore", Date, Opponent
    }
}

struct date: Codable{
    var Time : String?
    var Timestamp : String?
    private enum CodingKeys : String, CodingKey {
            case Time = "-Time", Timestamp = "-Timestamp"
    }
}

enum MetadataType: Codable {
    case array([Game])
    case `Any`(Game)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .array(container.decode(Array.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .Any(container.decode(Game.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(MetadataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .array(let array):
            try container.encode(array)
        case .Any(let Game):
            try container.encode(Game)
        }
    }
    
    var gameArrayValue : [Game]? {
        guard case let .array(value)  = self else { return nil }
        return value
    }

    var gameValue : Game? {
        guard case let .Any(value) = self else { return nil }
        return value
    }
}


