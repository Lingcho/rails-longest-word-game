class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.shuffle.drop(24 - 8)
    cookies[:score] = 0 if cookies[:score].nil?
    @total_score = cookies[:score]
  end

  def score
    @letters = params[:letters].split(' ')
    @answer = params[:answer].split('')
    cookies[:score] = 0 if cookies[:score].nil?
    @total_score = cookies[:score].to_i

    def valid?
      url = 'https://wagon-dictionary.herokuapp.com/'
      user_serialized = open(url + params[:answer]).read
      validation = JSON.parse(user_serialized)
      validation["found"] == true
    end

    def included?
      response = 0
      @answer.each do |letter|
        if @letters.include?(letter.downcase)
          response += 1
        end
      end
      response == @answer.length
    end

    if !included?
      @result = "Sorry but #{params[:answer]} can't be build out of #{@letters.join(', ').upcase}"
    elsif included? && !valid?
      @result = "Sorry but #{params[:answer]} does not seem to be a valid English word..."
    elsif included? && valid?
      @result = "Congratulations! #{params[:answer]} is a valid English word!"
      @total_score += @answer.length
      cookies[:score] = @total_score
    end
  end
end
