require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
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
      issue = first_or_create(github_id: gid, repo: repo)
      issue.github_page = page
      issue.position = idx + (page.to_i * PER_PAGE)
      issue.save
      issues << issue.github_id
    end
    issues
  end
end

class IssueTracker < Sinatra::Base
  helpers Sinatra::JSON

  configure do
    DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/db/#{ENV['RACK_ENV']}.sqlite3"))
    DataMapper.auto_upgrade!
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/:user/:repo/issue_ids' do |user, repo|
    issues = Issue.all(github_page: params[:page], repo: "#{user}/#{repo}", order: :position)
    issue_ids = issues.map do |issue|
      issue.id
    end
    json issue_ids
  end

  get '/:user/:repo/issues' do |user, repo|
    issues = Issue.all(github_page: params[:page], repo: "#{user}/#{repo}", order: :position)
    json issues: []
  end

  post '/:user/:repo/issues' do |user,repo|
    json Issue.update_issue_order(params[:issue_ids], "#{user}/#{repo}", params[:page])
  end
end