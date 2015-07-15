class Hash
  def stringify
    inject({}){|memo,(k,v)| memo[k.to_s] = v.to_s; memo}
  end
end