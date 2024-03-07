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

# Take request after checking if user can send requests
#count value not required

# Test case 1: (Working)
# User_id: Monisha
# Request: fsdhf

# Test case 2: (Working)
# User_id: Monisha
# Request: fsdhf

# Test case 3: (Working, Checking if space is accepted in id)
# Enter user_id: Sharon monisha
# Enter your request: gfsd

# Test case 4: (Not working, fixed later, Empty userid and request)
# Enter user_id: 
# Enter your request: jkb

# Test case 5: (Working, Checking case handling)
# Enter user_id: monisha
# Enter your request: fhdsj

# Test case 6: (Working)
# Enter user_id: monisha
# Enter your request: fjkdbs

# Test case 7: (Working)
# Enter user_id: monisha
# Enter your request: jbjk

# Test case 8: (Working, More than accepted requests)
# Enter user_id: monisha
# Enter your request: euwi

# Test case 9: (Working, Checking if other userid is working when one doesnt work)
# Enter user_id: sharon
# Enter your request: jfdks

# Test case 10: (Working, After the timeout period)
# Enter user_id: monisha
# Enter your request: njcd