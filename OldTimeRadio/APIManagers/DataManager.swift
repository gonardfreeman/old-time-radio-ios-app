//
//  DataManager.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 06.08.2022.
//

import Foundation

protocol DataServiceProtocol {
    func getPlayChannelList(chanelName: String, completion: @escaping (ChanelPlaylist) -> Void)
    func getShows(completion: @escaping ([Show]) -> Void)
    func getChannels(completion: @escaping ([Channel]) -> Void)
}

final class DataManager: DataServiceProtocol {
    
    func getPlayChannelList(chanelName: String, completion: @escaping (ChanelPlaylist) -> Void) {
        makeRequest(url: "https://oldtime.radio/api/channel/\(chanelName)") { resp in
            do {
                completion(try JSONDecoder().decode(ChanelPlaylist.self, from: resp))
            } catch let error {
                print("error decoding:", error)
                completion(ChanelPlaylist())
            }
        }
    }
    
    func getShows(completion: @escaping ([Show]) -> Void) {
        makeRequest(url: "https://oldtime.radio/api/shows") { resp in
            do {
                completion(try JSONDecoder().decode([Show].self, from: resp))
            } catch let error {
                print("error decoding:", error)
                completion([])
            }
        }
    }
    
    func getChannels(completion: @escaping ([Channel]) -> Void) {
        makeRequest(url: "https://oldtime.radio/api/channels") { resp in
            do {
                let decodedChannels = try JSONDecoder().decode([String].self, from: resp)
                completion(decodedChannels.map { channelName in
                    Channel(id: channelName, name: channelName, userChannel: false)
                })
            } catch let error {
                print("error decoding:", error)
                completion([])
            }
        }
    }
    
    private func makeRequest(url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let dataTask =  URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request err: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else {return}
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
        dataTask.resume()
    }
}
