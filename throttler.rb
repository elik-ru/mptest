#!/usr/bin/env ruby

require 'goliath'
require 'pp'

#Goliath::Server::DEFAULT_PORT=5000

API_KEYS=["key1","key2","key3"]
DELAY=5

$times={}


class Subscribe < Goliath::API
  def response(env)
      path = env["REQUEST_URI"]	
      if path.match /\/context\?api_key=(.*)/	
        key=Regexp.last_match[1]
        if API_KEYS.include? key
          if $times[key].nil? or (Time.now-$times[key])>DELAY
            $times[key]=Time.now
            [200, {}, "Good\n"]
          else
            wait=(DELAY-(Time.now-$times[key])).round
            [429, {'Retry-After' => wait.to_s}, "To many requests \n"]
          end
        else
          [401, {}, "Authorization required\n"]
        end
      else
        [404, {}, "Not Found\n"]
      end
  end

end