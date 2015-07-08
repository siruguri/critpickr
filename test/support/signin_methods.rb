def devise_sign_in(u, scope = :user)
  @request.env["devise.mapping"] = Devise.mappings[scope]
  u.confirm!
  sign_in u
end

def devise_sign_out(u)
  sign_out u
end
