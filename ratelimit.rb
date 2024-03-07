require 'redis'

class RateLimit
  #initialize the redis url 
  def initialize(red_url)
    @redis=Redis.new(url: red_url)
  end
#checks whether a user is allowed to make another request based on the rate limit criteria.
  def allowed?(user_id)
    key="requests:#{user_id}"
    cur_time=Time.now.to_i #fetches current time stamp

    # add timestamp
    @redis.zadd(key,cur_time,cur_time)
    #remove old time stamps
    @redis.zremrangebyscore(key,'-inf',cur_time-120)

    #count the no. of requests made
    req_count=@redis.zcard(key)

    rem_req= 3-req_count

    if req_count<=3
      puts"Your request has been processed!!"
      puts "Request allowed for user #{user_id}.Remaining requests: #{rem_req}"
      return true
    else
      puts "Request limit exceeded for user #{user_id}. No requests left.\n 
      Please Try after few minutes!!"
      return false
    end
  end
end



red_url="redis://localhost:6379/0"

#create obj and call class 
limit=RateLimit.new(red_url)

puts "API Rate Limiter is running. Press Ctrl+C to exit."

loop do
  print "Enter user_id: "
  user_id = gets.chomp
  if user_id.empty?
    puts("User_id cannot be empty!! Please try again!")
    next
  end
  loop do
    print "Enter your request: "
    req_url = gets.chomp
  
    if req_url.empty?
      puts "Request field cannot be empty! Please try again."
    else
      break # Break out of the loop if req_url is not empty
    end
  end

  limit.allowed?(user_id)
end
    






