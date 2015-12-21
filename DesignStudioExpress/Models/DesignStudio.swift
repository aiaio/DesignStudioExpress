//
//  DesignStudio.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/14/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class DesignStudio: Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var title = ""
    dynamic var dateCreated: NSDate = NSDate()
    dynamic var started = false
    dynamic var finished = false
    dynamic var template = false // only for built-in templates
    dynamic var currentChallengeId: String = ""
    dynamic var currentActivityId: String = ""
    
    let challenges = List<Challenge>()
    
    // minutes
    var duration: Int {
        get {
            var duration = 0
            for challenge in self.challenges {
                duration += challenge.duration
            }
            return duration
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // TODO: we should implement NSCopying instead
    func makeACopy() -> DesignStudio? {
        let copyDS = DesignStudio()
        copyDS.title = self.title
        copyDS.started = self.started
        copyDS.finished = self.finished
        copyDS.template = false
        copyDS.currentChallengeId = self.currentChallengeId
        copyDS.currentActivityId = self.currentActivityId
        
        for challenge in self.challenges {
            let copyChallenge = Challenge()
            copyChallenge.title = challenge.title
            copyChallenge.challengeDescription = challenge.challengeDescription
            copyChallenge.finished = false
            
            for activity in challenge.activities {
                let copyActivity = Activity()
                copyActivity.title = activity.title
                copyActivity.activityDescription = activity.activityDescription
                copyActivity.duration = activity.duration
                copyActivity.notes = activity.notes
                copyActivity.finished = false
                                
                copyChallenge.activities.append(copyActivity)
            }
            copyDS.challenges.append(copyChallenge)
        }
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(copyDS)
            }
        } catch {
            return nil
            //TODO handle errors
        }
        
        return copyDS
    }
    
    class func createDefaultTemplate1() {
        let realm = try! Realm()
        
        realm.beginWrite()
        
        let ds = DesignStudio()
        ds.title = "Template: New Concept"
        ds.template = true
       
        let challenge = Challenge()
        challenge.title = "Solo Sketching"
        challenge.challengeDescription  = "This round focuses on cardstorming and rapid sketching. Stick to rough sketches that convey your ideas. You will present, critique and refine your ideas after each activity. Good luck and get sketchy!"
        
        let activity1 = Activity()
        activity1.title = "Cardstorming"
        activity1.activityDescription = "Warmup and cardstorming. Write as many feature ideas as you can on individual stickies. Save features as your idea palette for sketching."
        activity1.duration = 5
        challenge.activities.append(activity1)
        
        let activity2 = Activity()
        activity2.title = "5 ideas in 5 minutes"
        activity2.activityDescription = "Generate 5 ideas in 5 minutes — should be unique concepts, but can be very rough. Give one minute per idea. It’s okay to have fewer than the 5 ideas."
        activity2.duration = 5
        challenge.activities.append(activity2)
        
        let activity3 = Activity()
        activity3.title = "Discuss in mini groups"
        activity3.activityDescription = "Present ideas to the group to share your concepts and get a critique. Write ideas/questions down as notes. Use most of this time to share ideas."
        activity3.duration = 10
        challenge.activities.append(activity3)
        
        let activity4 = Activity()
        activity4.title = "Refine & sketch"
        activity4.activityDescription = "Refine your concepts into the top 2 ideas. Incorporate others’ ideas into your designs."
        activity4.duration = 10
        challenge.activities.append(activity4)
        
        let activity5 = Activity()
        activity5.title = "Prepare to present"
        activity5.activityDescription = "Prepare to present your ideas as a group—condense and eliminate as much as possible. Don’t be afraid to throw away ideas, keep the strongest ones."
        activity5.duration = 10
        challenge.activities.append(activity5)
        
        let activity6 = Activity()
        activity6.title = "Share and discuss"
        activity6.activityDescription = "Each group presents and receives critiques. Discuss all ideas and determine which ideas people like the best. If you’d like, hold a vote."
        activity6.duration = 20
        challenge.activities.append(activity6)
        
        let activity7 = Activity()
        activity7.title = "Break"
        activity7.activityDescription = "If you think people need one! Don’t forget to refresh all your supplies for the next challenge."
        activity7.duration = 5
        challenge.activities.append(activity7)
        
        ds.challenges.append(challenge)
        
        // Challenge #2
        
        let challenge2 = Challenge()
        challenge2.title = "Group Sketching"
        challenge2.challengeDescription  = "This round focuses on cardstorming and rapid sketching. Stick to rough sketches that convey your ideas. You will present, critique and refine your ideas after each activity. Good luck and get sketchy!"
        
        let activity21 = Activity()
        activity21.title = "Cardstorming"
        activity21.activityDescription = "Warmup and cardstorming. Write as many feature ideas as you can on individual stickies. Save features as your idea palette for sketching."
        activity21.duration = 5
        challenge2.activities.append(activity21)
        
        let activity22 = Activity()
        activity22.title = "5 ideas in 5 minutes"
        activity22.activityDescription = "Generate 5 ideas in 5 minutes — should be unique concepts, but can be very rough. Give one minute per idea. It’s okay to have fewer than the 5 ideas."
        activity22.duration = 5
        challenge2.activities.append(activity22)
        
        let activity23 = Activity()
        activity23.title = "Share within mini groups"
        activity23.activityDescription = "Present ideas to the group to share your concepts and get a critique. Write ideas/questions down as notes. Use most of this time to share ideas."
        activity23.duration = 10
        challenge2.activities.append(activity23)
        
        let activity24 = Activity()
        activity24.title = "Sketch"
        activity24.activityDescription = "Refine your concepts into the top 2 ideas. Incorporate others’ ideas into your designs."
        activity24.duration = 5
        challenge2.activities.append(activity24)
        
        let activity25 = Activity()
        activity25.title = "Collaborative sketching"
        activity25.activityDescription = "Together, each mini group sketches, consolidating their ideas into a single vision to answer the challenge."
        activity25.duration = 10
        challenge2.activities.append(activity25)
        
        let activity26 = Activity()
        activity26.title = "Share and discuss"
        activity26.activityDescription = "Each group presents and receives critiques. Discuss all ideas and determine which ideas people like the best. If you’d like, hold a vote."
        activity26.duration = 20
        challenge2.activities.append(activity26)
        
        let activity27 = Activity()
        activity27.title = "Break"
        activity27.activityDescription = "If you think people need one! Don’t forget to refresh all your supplies for the next challenge."
        activity27.duration = 5
        challenge2.activities.append(activity27)
        
        ds.challenges.append(challenge2)
        
        
        // Challenge #3
        
        let challenge3 = Challenge()
        challenge3.title = "Affinity Mapping"
        challenge3.challengeDescription  = "This is a cardstorming challenge. Present your best ideas and discuss their value. Then refine and  combine them into themes. Remember — ideas should be mapped to the users’ goals and needs."
        
        let activity31 = Activity()
        activity31.title = "Cardstorming"
        activity31.activityDescription = "Warmup and cardstorming. Write as many feature ideas as you can on individual stickies. Save features as your idea palette."
        activity31.duration = 5
        challenge3.activities.append(activity31)
        
        let activity32 = Activity()
        activity32.title = "Present to mini group"
        activity32.activityDescription = "Present your feature ideas to the group.  Ideas that have more than one item might be winners and you can start to combine ideas into themes."
        activity32.duration = 10
        challenge3.activities.append(activity32)
        
        let activity33 = Activity()
        activity33.title = "Grouping themes"
        activity33.activityDescription = "Group major themes together. Record any new ideas that come up during grouping and add in new stickies."
        activity33.duration = 10
        challenge3.activities.append(activity33)
        
        let activity34 = Activity()
        activity34.title = "Prepare to present"
        activity34.activityDescription = "Prepare to present your ideas as a group—condense as much as possible. Give each category of stickies a name."
        activity34.duration = 10
        challenge3.activities.append(activity34)
        
        let activity35 = Activity()
        activity35.title = "Team Discussion"
        activity35.activityDescription = "Each group presents their categories and sub-topics. Group major themes together, other teams can add to existing categories or add new ones."
        activity35.duration = 20
        challenge3.activities.append(activity35)
        
        ds.challenges.append(challenge3)
        
        // Final Challenge 
        
        let challenge4 = Challenge()
        challenge4.title = "Wrapup"
        challenge4.challengeDescription  = "Discuss and document your work. During discussion think about the strengths and weaknesses from the user’s point of view. Remember to take photos, you don’t want to lose any valuable ideas."
        
        let activity41 = Activity()
        activity41.title = "Final discussion"
        activity41.activityDescription = "Share final thoughts on the ideas created or the design studio. Consider next steps and how you can each move forward with your new ideas."
        activity41.duration = 20
        challenge4.activities.append(activity41)
        
        let activity42 = Activity()
        activity42.title = "Document and save"
        activity42.activityDescription = "Gather everyone’s notes, stickies, and sketches to refer to as you create higher fidelity designs. Don’t forget to take photos."
        activity42.duration = 5
        challenge4.activities.append(activity42)
        
        ds.challenges.append(challenge4)
        
        // save the DS
        realm.add(ds)
        
        do {
            try realm.commitWrite()
        } catch {
            // TODO handler error
        }
    }
    
    class func createDefaultTemplate2() {
        let realm = try! Realm()
        
        realm.beginWrite()
        
        let ds = DesignStudio()
        ds.title = "Template: Feature Iteration"
        ds.template = true
        
        let challenge = Challenge()
        challenge.title = "Challenge"
        challenge.challengeDescription  = "This round focuses on cardstorming and rapid sketching. Stick to rough sketches that convey your ideas. You will present, critique and refine your ideas after each activity. Good luck and get sketchy!"
        
        let activity1 = Activity()
        activity1.title = "Cardstorming"
        activity1.activityDescription = "Warmup and cardstorming. Write as many feature ideas as you can on individual stickies. Save features as your idea palette for sketching."
        activity1.duration = 5
        challenge.activities.append(activity1)
        
        let activity2 = Activity()
        activity2.title = "Discuss in mini groups"
        activity2.activityDescription = "Each person shares their ideas within their mini group."
        activity2.duration = 20
        challenge.activities.append(activity2)
        
        let activity3 = Activity()
        activity3.title = "5 ideas in 5 minutes"
        activity3.activityDescription = "Sketch 5 ideas in 5 minutes — should be unique concepts, but can be very rough. Give one minute per idea. It’s okay to have fewer than the 5 ideas."
        activity3.duration = 5
        challenge.activities.append(activity3)
        
        let activity4 = Activity()
        activity4.title = "Discuss in mini groups"
        activity4.activityDescription = "Present ideas to the group to share your concepts and get a critique. Write ideas/questions down as notes. Use most of this time to share ideas."
        activity4.duration = 20
        challenge.activities.append(activity4)
        
        let activity5 = Activity()
        activity5.title = "Sketch"
        activity5.activityDescription = "Refine your concepts into the top 2 ideas. Incorporate others’ ideas into your designs."
        activity5.duration = 10
        challenge.activities.append(activity5)
        
        let activity6 = Activity()
        activity6.title = "Prepare to present"
        activity6.activityDescription = "Prepare to present your ideas as a group—condense and eliminate as much as possible. Don’t be afraid to throw away ideas, keep the strongest ones."
        activity6.duration = 10
        challenge.activities.append(activity6)
        
        let activity7 = Activity()
        activity7.title = "Team discussion"
        activity7.activityDescription = "Each group presents and receives critiques. Discuss all ideas and determine which ideas people like the best. If you’d like, hold a vote."
        activity7.duration = 20
        challenge.activities.append(activity7)
        
        ds.challenges.append(challenge)
        
        // Final Challenge
        
        let challenge2 = Challenge()
        challenge2.title = "Wrapup"
        challenge2.challengeDescription  = "Discuss and document your work. During discussion think about the strengths and weaknesses from the user’s point of view. Remember to take photos, you don’t want to lose any valuable ideas."
        
        let activity21 = Activity()
        activity21.title = "Final discussion"
        activity21.activityDescription = "Share final thoughts on the ideas created or the design studio. Consider next steps and how you can each move forward with your new ideas."
        activity21.duration = 20
        challenge2.activities.append(activity21)
        
        let activity22 = Activity()
        activity22.title = "Document and save"
        activity22.activityDescription = "Gather everyone’s notes, stickies, and sketches to refer to as you create higher fidelity designs. Don’t forget to take photos."
        activity22.duration = 5
        challenge2.activities.append(activity22)
        
        ds.challenges.append(challenge2)
        
        // save the DS
        realm.add(ds)
        
        do {
            try realm.commitWrite()
        } catch {
            // TODO handler error
        }
    }

}