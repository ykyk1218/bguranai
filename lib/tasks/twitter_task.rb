class Tasks::TwitterTask
        def self.execute
		#twitter API実行
            	options = {"count" => 12, "screen_name" => 'mezaura'}
            	uranais = []
		client = Twitter::REST::Client
            	client.user_timeline(options).each do |res|
			uranai = {}
			uranai['all'] = res.text
			if /\[(.+?)\] \* (.+?)位 \* (.+?) --- (.+?) --- ラッキーポイント：(.+?)$/ =~ res.text then
				uranai['date'] = $1
				uranai['rank'] = $2
				uranai['constellation'] = $3
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
p uranais
	end
end
