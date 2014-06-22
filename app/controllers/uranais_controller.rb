class UranaisController < ApplicationController
	def index
		#DB検索
		@uranais = Uranai.where(:constellation => 'いて座')
	end
end
