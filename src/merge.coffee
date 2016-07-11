# Description:
#   Integrate with GitHub merge API
#
# Dependencies:
#   "githubot": "1.0.0"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_ORG
#
# Commands:
#   hubot merge doximity/<head> into <base> - merges the selected branches or SHA commits
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
# Author:
#   maletor

module.exports = (robot) ->
  github = require('githubot')(robot)

  # http://rubular.com/r/dCyEJx5a6A
  robot.respond /merge ([-_\.0-9a-zA-Z]+)(\/([-_\.a-zA-z0-9\/]+))? into ([-_\.a-zA-z0-9\/]+)\s*$/i, (msg) ->
    app      = msg.match[1]
    head     = msg.match[3] || 'master'
    base     = msg.match[4]
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    org      = process.env.HUBOT_GITHUG_ORG
    url = "#{base_url}/repos/#{org}/#{app}/merges"

    github.handleErrors (response) ->
      msg.send "Fuck! #{response.error}!"

    github.post url, { base: base, head: head }, (merge) ->
      if merge and merge.commit
        msg.send 'Merged the shit out of it!'
      else
        msg.send 'Base already contains the head!'
