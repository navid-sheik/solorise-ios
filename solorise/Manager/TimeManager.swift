//
//  TimeManager.swift
//  solorise
//
//  Created by Navid Sheikh on 28/05/2024.
//

import Foundation
import UIKit

class TimeManager {
    
    struct EstimatedDates {
        var minShippingDate: Date
        var maxShippingDate: Date
        var minDeliveryDate: Date
        var maxDeliveryDate: Date
    }
    
    

    static func timeAgo(from dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions.insert(.withFractionalSeconds)
           

           guard let date = dateFormatter.date(from: dateString) else {
               return "Invalid date"
           }
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: date, to: now)

        if let years = components.year, years >= 1 {
            return "\(years) year\(years > 1 ? "s" : "") ago"
        }

        if let months = components.month, months >= 1 {
            return "\(months) month\(months > 1 ? "s" : "") ago"
        }

        if let weeks = components.weekOfYear, weeks >= 1 {
            return "\(weeks) week\(weeks > 1 ? "s" : "") ago"
        }

        if let days = components.day, days >= 1 {
            return "\(days) day\(days > 1 ? "s" : "") ago"
        }

        if let hours = components.hour, hours >= 1 {
            return "\(hours) hour\(hours > 1 ? "s" : "") ago"
        }

        if let minutes = components.minute, minutes >= 1 {
            return "\(minutes) minute\(minutes > 1 ? "s" : "") ago"
        }

        if let seconds = components.second, seconds >= 3 {
            return "\(seconds) second\(seconds > 1 ? "s" : "") ago"
        }

        return "Just now"
    }
    static func orderDateFormatter(_ dateString: String) -> String {
           let isoFormatter = ISO8601DateFormatter()
           isoFormatter.formatOptions.insert(.withFractionalSeconds)

           guard let date = isoFormatter.date(from: dateString) else {
               return "Invalid date"
           }
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMM d, yyyy"
           
           return dateFormatter.string(from: date)
       }
    
    static func orderFormatterWithTime(_ dateString: String) -> String {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime, .withTimeZone, .withFractionalSeconds]
            
            guard let date = isoFormatter.date(from: dateString) else {
                return "Invalid date"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
            
            return dateFormatter.string(from: date)
        }
    
    
    static func openSinceYear(from dateString: String) -> String {
           let dateFormatter = ISO8601DateFormatter()
           dateFormatter.formatOptions.insert(.withFractionalSeconds)
           
           guard let date = dateFormatter.date(from: dateString) else {
               return "Invalid date"
           }
           
           let yearFormatter = DateFormatter()
           yearFormatter.dateFormat = "yyyy"
           
           let yearString = yearFormatter.string(from: date)
           return "Open since \(yearString)"
       }
    
    static func formatStripeDate(_ stripeDate: Int) -> String {
           // Convert the Unix timestamp to a Date object
           let date = Date(timeIntervalSince1970: TimeInterval(stripeDate))
           
           // Create a DateFormatter to format the Date object
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "d MMM, HH:mm" // 13 Jul, 02:02 format
           
           // Return the formatted date string
           return dateFormatter.string(from: date)
       }
    
//    
//    static func calculateEstimatedDates(for orderItem: OrderItem) -> EstimatedDates? {
//            guard let createdAt = orderItem.createdAt else {
//                return nil // No date provided
//            }
//            
//            let dateFormatter = ISO8601DateFormatter()
//            dateFormatter.formatOptions.insert(.withFractionalSeconds)
//            
//            guard let createdAtDate = dateFormatter.date(from: createdAt) else {
//                return nil // Invalid date
//            }
//            
//            let minProcessingTime = orderItem.product.shippingInfo.processingTime.min
//            let maxProcessingTime = orderItem.product.shippingInfo.processingTime.max
//            
//            let minDeliveryTime = orderItem.product.shippingInfo.standardDelivery.deliveryTime.min
//            let maxDeliveryTime = orderItem.product.shippingInfo.standardDelivery.deliveryTime.max
//            
//            // Calculate estimated shipping time (processing time)
//            let minShippingEstimate = Calendar.current.date(byAdding: .day, value: minProcessingTime, to: createdAtDate)!
//            let maxShippingEstimate = Calendar.current.date(byAdding: .day, value: maxProcessingTime, to: createdAtDate)!
//            
//            // Calculate estimated delivery time based on max shipping estimate
//            let minDeliveryEstimate = Calendar.current.date(byAdding: .day, value: minDeliveryTime, to: maxShippingEstimate)!
//            let maxDeliveryEstimate = Calendar.current.date(byAdding: .day, value: maxDeliveryTime, to: maxShippingEstimate)!
//            
//            return EstimatedDates(minShippingDate: minShippingEstimate, maxShippingDate: maxShippingEstimate, minDeliveryDate: minDeliveryEstimate, maxDeliveryDate: maxDeliveryEstimate)
//        }
    
    static func formatEstimatedDates(_ estimatedDates: EstimatedDates) -> (maxShippingDate: String, maxDeliveryDate: String) {
        // Create a DateFormatter to format the Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy" // Aug 21, 2023 format

        // Format max shipping and delivery dates
        let maxShipping = dateFormatter.string(from: estimatedDates.maxShippingDate)
        let maxDelivery = dateFormatter.string(from: estimatedDates.maxDeliveryDate)
        
        // Return formatted date strings for max shipping and max delivery dates
        return (maxShipping, maxDelivery)
    }
    static func daysUntilOrderItem(_ targetDate: Date, from currentDate: Date = Date()) -> String {
         let calendar = Calendar.current
         let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
         
         if let days = components.day {
             switch days {
             case 0:
                 return "Today"
             case 1:
                 return "Tomorrow"
             case 2...6:
                 return "\(days) Days"
             case 7:
                 return "1 Week"
             case 8...13:
                 return "\(days) Days" // Optional, depending on how you want to handle this range
             case 14...20:
                 return "2 Weeks"
             case ..<0:
                 let absoluteDays = abs(days)
                 switch absoluteDays {
                 case 1:
                     return "Yesterday"
                 case 2...6:
                     return "\(absoluteDays) Days Ago"
                 case 7:
                     return "1 Week Ago"
                 case 8...13:
                     return "\(absoluteDays) Days Ago" // Optional, depending on how you want to handle this range
                 case 14...20:
                     return "2 Weeks Ago"
                 default:
                     return "\(absoluteDays) Days Ago" // or "\(absoluteDays/7) Weeks Ago"
                 }
             default:
                 return "\(days) Days" // or "\(days/7) Weeks"
             }
         }
         
         return "Unknown"
     }

    
    
//
//    static func calculateEstimatedDates(createdAt: String?, minProcessingTime: Int, maxProcessingTime: Int, minDeliveryTime: Int, maxDeliveryTime: Int) -> EstimatedDates? {
//
//        guard let createdAt = createdAt else {
//            return nil // No date provided
//        }
//
//        let dateFormatter = ISO8601DateFormatter()
//
//        guard let createdAtDate = dateFormatter.date(from: createdAt) else {
//            return nil // Invalid date
//        }
//
//        // Calculate estimated shipping time (processing time)
//        let minShippingEstimate = Calendar.current.date(byAdding: .day, value: minProcessingTime, to: createdAtDate)!
//        let maxShippingEstimate = Calendar.current.date(byAdding: .day, value: maxProcessingTime, to: createdAtDate)!
//
//        // Calculate estimated delivery time based on max shipping estimate
//        let minDeliveryEstimate = Calendar.current.date(byAdding: .day, value: minDeliveryTime, to: maxShippingEstimate)!
//        let maxDeliveryEstimate = Calendar.current.date(byAdding: .day, value: maxDeliveryTime, to: maxShippingEstimate)!
//
//        return EstimatedDates(minShippingDate: minShippingEstimate, maxShippingDate: maxShippingEstimate, minDeliveryDate: minDeliveryEstimate, maxDeliveryDate: maxDeliveryEstimate)
//    }
}

