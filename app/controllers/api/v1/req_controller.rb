class Api::V1::ReqController < ApplicationController
  def send_it
    @arr = [[], [], [], []]
    @all = Anime.all.order(rating: :desc).group_by(&:title_orig)

    @top100 = @all.drop(10).first(100)
    @top40 = @all.first(40)
    @without_first_100 = @all.drop(110)

    @first_part = @top40.sample(5)
    @second_part = @top100.sample(20)
    @last_part = @without_first_100.sample(75)

    @variants1 = @top40 - @first_part
    @variants2 = @top100 - @second_part
    @variants3 = @without_first_100 - @last_part

    for i in 1...4
    	@cur_var1 = @variants1.sample(5)
    	@cur_var2 = @variants2.sample(20)
    	@cur_var3 = @variants3.sample(75)

    	@arr[i] = @cur_var1
    	@arr[i] += @cur_var2
    	@arr[i] += @cur_var3

    	@variants1 -= @cur_var1
    	@variants2 -= @cur_var2
    	@variants3 -= @cur_var3
    end

    @arr[0] = @first_part
    @arr[0] += @second_part
    @arr[0] += @last_part

    render json: @arr
  end
end
