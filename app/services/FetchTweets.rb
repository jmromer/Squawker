module FetchTweets
  def self.call(username:)
    OpenStruct.new.tap do |result|
      begin
        # Query for the timeline associated with the given handle
        tweets = TwitterAPI.instance.client.user_timeline(username, count: 100)
        result.user, = Squawk.new_collection_from_tweets(tweets)
      rescue Twitter::Error::Unauthorized
        # If user's account is set to private, query only for their public
        # profile info
        tweeter = TwitterAPI.instance.client.user(username)
        result.user = User.new_from_tweeter(tweeter)
      end
    end
  end
end
