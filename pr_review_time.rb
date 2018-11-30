require 'octokit'

def checker(event:, context:)
  puts event
  repo = event[:repo] || 'tknzk/tknzk.com'
  client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  pull_requests = client.pulls(repo)
  targets = []
  pull_requests.each do |pr|
    next if pr.title =~ /\[WIP\]/
    targets << pr
  end

  request_list = {}
  done_list = {}
  targets.each do |target|
    if target.requested_reviewers.size == 0
      done_list[target.user.login] = [] unless done_list.key?(target.user.login)
      done_list[target.user.login] << target.html_url
    else
      target.requested_reviewers.each do |reviewer|
        request_list[reviewer.login] = [] unless request_list.key?(reviewer.login)
        request_list[reviewer.login] << target.html_url
      end
    end
  end
  puts request_list
  puts "----"
  puts done_list

end

checker(event: {repo: 'rails/rails'}, context: nil)
