#!/usr/bin/ruby -w
require 'rexml/document'
require 'json'

include REXML

xmlFileName = ARGV.first
puts "Parsing: " + xmlFileName

begin
  xmlfile = File.new(xmlFileName)
  rescue
    print "Failed to open #{xmlFileName}\n"
    print "Please specifcy events.xml for the BBB meeting for which you want to extract polling data\n"
  exit
end

xmldoc = Document.new(xmlfile)
# Now get the root element
root = xmldoc.root

class User
  def initialize(userId, name, role, externaluserId)
    @userId = userId
    @name = name
    @role = role
    @externaluserId = externaluserId
    @polls = Array.new
  end
 
  def to_s
    "User: #{@userId} #{@name} #{@role} #{@externaluserId} #{@polls}"
  end

  def as_json(options={})
    {
      userId: @userId,
      name: @name,
      role: @role,
      externaluserId: @externaluserId,
      pollAnswer: @polls.to_json
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

  attr_accessor :userId, :name, :polls

end

class Poll
  def initialize(pollId, pollTime, pollAnswer)
    @pollId = pollId
    @pollTime = pollTime
    @pollAnswer = pollAnswer
  end

  def as_json(options={})
    {
      pollId: @pollId,
      pollTime: @pollTime,
      pollAnswer: @pollAnswer
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end

puts "BigBlueButton Poll Analytics"

puts "Meeting Id : " + root.attributes["meeting_id"]

answerArray = Array.new
users = Array.new

xmldoc.elements.each("recording/event") do |e|
  
  if(e.attributes["eventname"] == "ParticipantJoinEvent")
    user = User.new(e.elements["userId"].text(),
                    e.elements["name"].text(),
                    e.elements["role"].text(),
                    e.elements["externalUserId"].text()
                    )
    users.push(user) 
  elsif(e.attributes["eventname"] == "PollStartedRecordEvent")
    # create answerArray to find answer key from given answer id when UserRespondedToPollRecordEvent is parsed
    answerArray = JSON.parse(e.elements["answers"].text())

  elsif(e.attributes["eventname"] == "UserRespondedToPollRecordEvent")

    # answerArray would get populated when PollStartedRecordEvent element is parsed in the earlier if-else
    if answerArray.length > 0
      for answerElement in answerArray
        if(answerElement["id"].to_s == e.elements["answerId"].text())
          poll = Poll.new(e.elements["pollId"].text(),
                          e.elements["date"].text(),
                          answerElement["key"])
            for u in users
              if(u.userId == e.elements["userId"].text())
		u.polls.push(poll)
              end
            end
        end
      end
    end


  end


end

# print all users with poll data
for u in users
  puts u.to_json
end

