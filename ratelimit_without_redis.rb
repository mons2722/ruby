class RateLimit
    def initialize
        @requests=Hash.new{|hash,key| hash[key]={timestamps: [],count: 0}}
        @exp_time=120
        @req_lim=3
    end

    def allowed?(user_id)
        user_data=@requests[user_id]
        cur_time=Time.now.to_i

         # Remove timestamps older than expiry time
         user_data[:timestamps].delete_if { |timestamp| timestamp < cur_time - @exp_time }

         if user_data[:timestamps].length < @req_lim
            user_data[:timestamps]<<cur_time
            user_data[:count]+=1
            rem_req=@req_lim-user_data[:timestamps].length
            puts "Your request has been processed!!"
            puts "Request allowed for user #{user_id}. Remaining requests: #{rem_req}"
            return true
         else
            puts "Request limit exceeded for user #{user_id}. 
            No requests left!\nPlease Try after few minutes!!"
      return false
         end
        end
    end


limit = RateLimit.new

puts "API Rate Limiter is running. Press Ctrl+C to exit."
loop do
  print "Enter user_id: "
  user_id = gets.chomp
  print "Enter your request: "
  req_url = gets.chomp

  limit.allowed?(user_id)
end