json.array! @repos do |repo|
  json.repo_name repo[0]
  json.repo_url repo[1]
end
