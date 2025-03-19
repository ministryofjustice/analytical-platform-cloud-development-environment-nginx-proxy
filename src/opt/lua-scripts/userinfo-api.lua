local http = require("resty.http")
local httpc = http.new()
local cjson = require("cjson")


local function get_access_token()
  local endpoint = "https://" .. ngx.var.auth0_tenant_domain .. "/oauth/token"
  local headers = {
    ["Content-Type"] = "application/x-www-form-urlencoded"
  }

  local body = {
    client_id = ngx.var.auth0_client_id,
    client_secret = ngx.var.auth0_client_secret,
    audience = "https://" .. ngx.var.auth0_tenant_domain .. "/api/v2/",
    grant_type = "client_credentials"
  }

  local res, err = httpc:request_uri(endpoint,  {
    method = "POST",
    body = ngx.encode_args(body),
    headers = headers,
  })
  ngx.log(ngx.NOTICE, ngx.var.auth0_tenant_domain)
  if not res then
    ngx.log(ngx.NOTICE, err)
    return false, nil, err
  else
    return true, cjson.decode(res.body).access_token, nil
  end
end

local function get_user_info(access_token)
  local user_endpoint = "https://" .. ngx.var.auth0_tenant_domain .. "/api/v2/users"
  local user_info_headers = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer " .. access_token
  }

  local search_params = {
    q = "nickname: " .. ngx.var.username,
    search_engine = "v2"
  }

  local user_res, err = httpc:request_uri(user_endpoint,  {
    method = "GET",
    query = search_params,
    headers = user_info_headers,
  })

  local found_user = cjson.decode(user_res.body)[1]
  if not found_user then
    return '{"error": 404, "message": "Not found"}'
  else
    return cjson.encode(found_user)
  end
end

-- Main entry
local succeeded, access_token, err = get_access_token()

if succeeded then
  ngx.say(get_user_info(access_token))
else
  ngx.status = 400
  ngx.say(err)
end
