require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require 'data_mapper'
require 'json'

class Issue

  PER_PAGE = 30

  include DataMapper::Resource
  property :id, Serial
  property :github_id, Integer
  property :github_page, Integer
  property :position, Integer
  property :repo, String

  def self.update_issue_order(github_ids, repo, page)
    issues = []
    github_ids.each_with_index do |gid, idx|
      issues << gh_issue(gid, repo, page, idx)
    end
    issues
  end

  def self.gh_issue(github_id, repo, page, idx)
    page = [0, (page.to_i - 1)].max
    issue = first_or_create(github_id: github_id, repo:repo)
    issue.github_page = page+1
    issue.position = idx + (page * PER_PAGE)
    issue.save

    issue
  end

end

class IssueTracker < Sinatra::Base
  helpers Sinatra::JSON

  configure do
    DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/db/#{ENV['RACK_ENV']}.sqlite3"))
    DataMapper.auto_upgrade!
    register Sinatra::CrossOrigin
    enable :cross_origin
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/:user/:repo/issue_ids' do |user, repo|
    issues = Issue.all(github_page: params[:page], repo: "#{user}/#{repo}", order: :position)
    json issues.map{|i| i.github_id }
  end

  get '/:user/:repo/issues' do |user, repo|
    issues = Issue.all(github_page: params[:page], repo: "#{user}/#{repo}", order: :position)
    json issues.map{|i| i.github_id }
  end

  post '/:user/:repo/issues' do |user,repo|
    issues = Issue.update_issue_order(params[:issue_ids], "#{user}/#{repo}", params[:page])
    json issues.map{|i| i.github_id }
  end
end
