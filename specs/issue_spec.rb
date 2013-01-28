require_relative 'spec_helper'

describe Issue do

  it "should update or create issues with their position" do
    github_ids = [1,2,3]
    issues = Issue.update_issue_order(github_ids, "snatchev/IssueTracker", 1)
    issues.each_with_index do |issue, idx|
      issue.github_id.must_equal github_ids[idx]
      issue.position.must_equal github_ids.index(issue.github_id)
    end
  end

  it "should find or create an github issue and update its position" do
    issue = Issue.gh_issue(1, "snatchev/IssueTracker", 1, 0)
    issue.position.must_equal 0
    issue.github_page.must_equal 1

    issue = Issue.gh_issue(1, "snatchev/IssueTracker", 2, 1)
    issue.position.must_equal 31
    issue.github_page.must_equal 2

    issue = Issue.gh_issue(1, "snatchev/IssueTracker", nil, 1)
    issue.position.must_equal 1
    issue.github_page.must_equal 1
  end
end
