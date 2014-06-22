class Tasks::RegistUranaiTask
        def self.execute
			client = Twitter::REST::Client.new do |config|
				config.consumer_key = ENV['CONSUMER_KEY'] 
				config.consumer_secret = ENV['CONSUMER_SECRET']
				config.access_token = ENV['ACCESS_TOKEN']
				config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
			end
            #twitter API実行
            options = {"count" => 12, "screen_name" => 'mezaura'}
            uranais = []
            client.user_timeline(options).each do |res|
				uranai = {}
				uranai['all'] = res.text
				date = ''
				if /\[(.+?)\] \* (.+?)位 \* (.+?) --- (.+?) --- ラッキーポイント：(.+?)$/ =~ res.text then
					date = $1
					#yyyy-mm-ddの形に整形
					#年は含まれていないので、バッチ実行時の年にしておく
					d = Date.today
					year  = d.year
					month = date[0,2]
					day   = date[3,2]
					
					uranai['date'] = year.to_s + "-" + month.to_s + "-" + day.to_s
					uranai['rank'] = $2
					
					#(6/22〜7/22)みたいのが付いてくるので取り除く
					pos = $3.index("(")
					constellation = $3[0, pos]
					uranai['constellation'] = constellation
					uranai['comment'] = $4
					
					if($5.index("アドバイス") || $5.index("おまじない")) then
						if /(.+?) --- (.+?)：(.+?)$/ =~ $5 then
							uranai['lucky']  = $1
							uranai['advice'] = $3
						end
					else
						uranai['lucky'] = $5
						uranai['advice'] = ""
					end
					
					uranais << uranai
				end
				
			end
    		#DB登録
    		uranais.each do |u|
	    		mUranai = Uranai.new(
	    			:all           => u['all'], 
	    			:date          => u['date'], 
	    			:rank          => u['rank'],
	    			:constellation => u['constellation'],
	    			:comment       => u['comment'],
	    			:lucky         => u['lucky'],
	    			:advice        => u['advice']
	    		)
	    		mUranai.save
	    	end
        end

end
