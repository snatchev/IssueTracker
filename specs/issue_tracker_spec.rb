require_relative 'spec_helper'

include Rack::Test::Methods

describe IssueTracker do
  def app
    IssueTracker
  end

  it "should serve the javascript" do
    get 'issue-tracker.js'
    last_response.status.must_equal 200
    last_response.content_type.must_equal "application/javascript;charset=utf-8"
  end

  it "should allow the repo param to have a splash" do
    get '/snatchev/IssueTracker/issues', page: 0
    last_response.status.must_equal 200
  end

  it "should accept a list of issue ids and a page" do
    post '/snatchev/IssueTracker/issues', issue_ids: [1,2,3], page: 0
    last_response.body.must_equal "[1,2,3]"
  end

end
